//
//  WZHouseManagesController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZHouseManageItem.h"
#import "WZHouseManagesCell.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import "WZAddHousesController.h"
#import "WZHouseManagesController.h"

@interface WZHouseManagesController (){
    //页数
    NSInteger current;
}
//楼盘列表数据
@property(nonatomic,strong)NSMutableArray *projectListArray;
//楼盘列表数据s
@property(nonatomic,strong)NSMutableArray *projectListArrays;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;

@property(nonatomic,strong)UIView *viewNo;

@end
static  NSString * const ID = @"cell";
static NSString *size = @"20";
@implementation WZHouseManagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNoData];
    self.navigationItem.title = @"楼盘管理";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtons:self action:@selector(addHouse) title:@"添加楼盘"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZHouseManagesCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@",HTTPURL];
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
            if (_projectListArray.count>0) {
                [_viewNo setHidden:YES];
            }else{
                [_viewNo setHidden:NO];
            }
            _projectListArrays = [WZHouseManageItem mj_objectArrayWithKeyValuesArray:_projectListArray];
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
//创建无图表
-(void)setNoData{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-50);
    [view setHidden:NO];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"wd_mx"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(120);
        make.width.offset(181);
        make.height.offset(150);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有任何楼盘哦";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(29);
    }];
    
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _projectListArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZHouseManagesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZHouseManageItem *item = _projectListArrays[indexPath.row];
    cell.item = item;
    return cell;
}
//选择数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZHouseManagesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
}
#pragma mark-添加楼盘
-(void)addHouse{
    WZAddHousesController *addHouse = [[WZAddHousesController alloc] init];
    [self.navigationController pushViewController:addHouse animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    _projectListArray = [NSMutableArray array];
    current = 1;
    _isRequestFinish = YES;
    [self loadData];
}
@end
