//
//  WZSystemController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSystemController.h"
#import "WZAnnNewItem.h"
#import "WZTaskCell.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZNEWHTMLController.h"
#import "WZTabBarController.h"
#import "WZSettingController.h"
#import "UIBarButtonItem+Item.h"
#import "WZAuthenSuccessController.h"
#import "WZBoardingDetailsController.h"
#import "WZBelongedStoreController.h"
@interface WZSystemController (){
    //页数
    NSInteger current;
}
//数据列表
@property(nonatomic,strong)NSArray *newsArray;
//列表数据
@property(nonatomic,strong)NSMutableArray *listArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
@end
static  NSString * const ID = @"cell";
//查询条数
static NSString *size = @"20";
@implementation WZSystemController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [self setNoData];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"系统通知";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtons:self action:@selector(readAll) title:@"一键已读"];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZTaskCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _isRequestFinish = YES;
    _listArray = [NSMutableArray array];
    current = 1;
    
    [self headerRefresh];
    
}
//一键已读
-(void)readAll{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
     NSString *url = [NSString stringWithFormat:@"%@/userMessage/setFullReading",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            
            _listArray = [NSMutableArray array];
            current = 1;
            [self loadDate];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadDate];
}
//请求数据
#pragma mark -请求数据
-(void)loadDate{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
    paraments[@"pageNumber"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"pageSize"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/read/list",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSMutableDictionary *data = [responseObject valueForKey:@"data"];
            NSMutableArray *rows = [data valueForKey:@"rows"];
            //将数据转换成模型
            if (rows.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                for (int i=0; i<rows.count; i++) {
                    [_listArray addObject:rows[i]];
                }
                current +=1;
                [self.tableView.mj_footer endRefreshing];
            }
            if (_listArray.count != 0) {
                [_viewNo setHidden:YES];
            }else{
                [_viewNo setHidden:NO];
            }
            NSMutableArray *nArray =   [WZAnnNewItem mj_objectArrayWithKeyValuesArray:_listArray];
            _newsArray = nArray;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
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
    view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-45);
    [view setHidden:NO];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"vacancy"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(194);
        make.width.offset(94);
        make.height.offset(96);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有收到任何通知哦~";
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WZTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZAnnNewItem *item = _newsArray[indexPath.row];
    cell.item = item;
    return cell;
}
#pragma mark -点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZTaskCell *anCell = [tableView cellForRowAtIndexPath:indexPath];
    [self read:anCell];
    
}
//已读接口
-(void)read:(WZTaskCell *)anCell{
    NSString *ID = anCell.ID;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = ID;
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/readFinish",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        [self NoreadNews:anCell];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//查询未读消息
-(void)NoreadNews:(WZTaskCell *)anCell{
    
    NSString *url = anCell.url;
    //跳转类型
    NSString *viewType = anCell.viewType;
    //楼盘ID/订单ID
    NSString *additional = anCell.additional;
    
    //指定页面
    NSString *param = anCell.param;
    //查询未读消息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
 
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *urls = [NSString stringWithFormat:@"%@/userMessage/read/notreadCount",HTTPURL];
    [mgr GET:urls parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *counts = [data valueForKey:@"count"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:counts forKey:@"newCount"];
            [defaults synchronize];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
   //跳转对应页面
    if([viewType isEqual:@"1"]){
        WZNEWHTMLController *new = [[WZNEWHTMLController alloc] init];
        new.url = url;
        [self.navigationController pushViewController:new animated:YES];
    }else if ([viewType isEqual:@"2"]){
        NSInteger paramId = [param integerValue];
        
        if (paramId == 100) {
            //订单详情
            WZBoardingDetailsController *boaringVC = [[WZBoardingDetailsController alloc] init];
            boaringVC.ID = additional;
            [self.navigationController pushViewController:boaringVC animated:YES];
        }else if (paramId == 102){

            //订单详情
            WZBoardingDetailsController *boaringVC = [[WZBoardingDetailsController alloc] init];
            boaringVC.ID = additional;
            [self.navigationController pushViewController:boaringVC animated:YES];
            
        }else if (paramId == 104){
            //我的设置
            WZSettingController *setting = [[WZSettingController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
            
        }else if (paramId == 105){
            //我的页面
            WZTabBarController *tabVC = [[WZTabBarController alloc] init];
            tabVC.selectedViewController = [tabVC.viewControllers objectAtIndex:2];
            [self.navigationController presentViewController:tabVC animated:YES completion:nil];
            
        }else if (paramId == 106){
            //实名认证成功
            WZAuthenSuccessController *success = [[WZAuthenSuccessController alloc] init];
            [self.navigationController pushViewController:success animated:YES];
            
        }else if(paramId == 103){
            //所属门店
            WZBelongedStoreController *store = [[WZBelongedStoreController alloc] init];
            [self.navigationController pushViewController:store animated:YES];
        }
    }else{
        
        _listArray = [NSMutableArray array];
        current = 1;
        [self loadDate];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}
@end
