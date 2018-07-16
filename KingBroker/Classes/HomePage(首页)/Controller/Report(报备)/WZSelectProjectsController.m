//
//  WZSelectProjectsController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSelectProjectsController.h"
#import "WZSelectProjectCell.h"
#import "WZSelcetProjectItem.h"
#import "UIBarButtonItem+Item.h"
#import "WZSearchProjectController.h"
#import "NSString+LCExtension.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
static  NSString * const ID = @"cell";
@interface WZSelectProjectsController (){
    //页数
    NSInteger current;
}
//楼盘列表数据
@property(nonatomic,strong)NSMutableArray *projectListArray;
//楼盘列表数据s
@property(nonatomic,strong)NSMutableArray *projectListArrays;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;

@end
//查询条数
static NSString *size = @"20";

@implementation WZSelectProjectsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择楼盘";
    self.tableView.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search_1"] highImage:[UIImage imageNamed:@"search"] target:self action:@selector(searchProject)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZSelectProjectCell" bundle:nil] forCellReuseIdentifier:ID];
    _projectListArray = [NSMutableArray array];
    current = 1;
    _isRequestFinish = YES;
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
    [self loadData];
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    footer.mj_h +=JF_BOTTOM_SPACE + 20;
    self.tableView.mj_footer = footer;
    
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadData];
}
//请求数据列表
-(void)loadData{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *storeId = [ user objectForKey:@"storeId"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"storeId"] = storeId;
    paraments[@"name"] = @"";
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/projectCompany/projectList",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *dacty = [responseObject valueForKey:@"data"];
            NSMutableArray *houseDatas = [dacty valueForKey:@"rows"];
            
            if (houseDatas.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<houseDatas.count; i++) {
                    [_projectListArray addObject:houseDatas[i]];
                }
                current +=1;
                [self.tableView.mj_footer endRefreshing];
            }
            _projectListArrays = [WZSelcetProjectItem mj_objectArrayWithKeyValuesArray:_projectListArray];
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
        _isRequestFinish = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        _isRequestFinish = YES;
    }];
}
//搜索楼盘
-(void)searchProject{
    WZSearchProjectController *searchVc = [[WZSearchProjectController alloc] init];
    searchVc.blockItem = ^(NSDictionary *dicty) {
        if (_projectBlock) {
            _projectBlock(dicty);
        }
    };
    [self.navigationController pushViewController:searchVc animated:YES];
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _projectListArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZSelectProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZSelcetProjectItem *item = _projectListArrays[indexPath.row];
    cell.item = item;
    return cell;
}
//选择数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZSelectProjectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    WZSelcetProjectItem *item = _projectListArrays[indexPath.row];
    dicty[@"projectName"] = cell.projectName.text;
    dicty[@"projectId"] = cell.projectId;
    dicty[@"signStatus"]= item.signStatus;
    dicty[@"telphone"]= item.tel;
    if (_projectBlock) {
        _projectBlock(dicty);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
