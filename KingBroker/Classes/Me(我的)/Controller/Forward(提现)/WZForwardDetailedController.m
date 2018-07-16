//
//  WZForwardDetailedController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "WZFrowardItem.h"
#import "WZFrowardDetailedCell.h"
#import "NSString+LCExtension.h"
#import "WZForwardDetailedController.h"

@interface WZForwardDetailedController (){
    //页数
    NSInteger current;
}
@property(nonatomic,strong)NSMutableArray *detailedArray;

@property(nonatomic,strong)NSMutableArray *array;
@end

static  NSString * const ID = @"cell";
//查询条数
static NSString *size = @"20";

@implementation WZForwardDetailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"明细";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
     _array = [NSMutableArray array];
    _detailedArray = [NSMutableArray array];
    current = 1;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZFrowardDetailedCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headerRefresh];
}
//下拉刷新
-(void)headerRefresh{
    //创建下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic:)];
    
    // 设置文字
    [header setTitle:@"刷新完毕..." forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.mj_h = 60;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    footer.mj_h += JF_BOTTOM_SPACE+20;
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _detailedArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadData];
}
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];;
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/userCapitalDetailed/detailed",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSString *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            //转换模型_
            //将数据转换成模型
            if (rows.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<rows.count; i++) {
                    [_detailedArray addObject:rows[i]];
                }
                current +=1;
                [self.tableView.mj_footer endRefreshing];
            }
            
            _array =  [WZFrowardItem mj_objectArrayWithKeyValuesArray:_detailedArray];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                
                [NSString isCode:self.navigationController code:code];
                //更新指定item
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];;
                item.badgeValue= nil;
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZFrowardDetailedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZFrowardItem *item = _array[indexPath.row];
    cell.item = item;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

@end
