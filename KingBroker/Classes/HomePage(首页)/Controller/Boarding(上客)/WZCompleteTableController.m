//
//  WZCompleteTableController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZCompleteTableController.h"
#import <AFNetworking.h>
#import "WZBoaringCell.h"
#import "UIView+Frame.h"
#import "WZBoardingDetailsController.h"
#import <SVProgressHUD.h>
#import "WZBoardingItem.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
#import <Masonry.h>
@interface WZCompleteTableController (){
    //页数
    NSInteger current;
}
@property(nonatomic,weak)WZBoaringCell *cell;
//订单列表数据
@property(nonatomic,strong)NSMutableArray *listArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
@end
//查询条数
static NSString *size = @"20";

@implementation WZCompleteTableController

- (void)viewDidLoad {
    [super viewDidLoad];

    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [self setNoData];
    self.view.backgroundColor = [UIColor clearColor];
    
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = YES;
    _listArray = [NSMutableArray array];
    current = 1;
    _isRequestFinish = YES;
   // [self loadDate];
    
    
    [self headerRefresh];
    //创造通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewTopics) name:@"Refresh" object:nil];
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
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}
-(void)loadNewTopics{
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
    
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadDate];
}
#pragma mark -请求数据
-(void)loadDate{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish  = NO;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        NSString *userId = [ user objectForKey:@"userId"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer.timeoutInterval = 60;
    
        //申明返回的结果是json类型
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"userId"] = userId;
        paraments[@"types"] = @"3";
        paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
        paraments[@"size"] = size;
        NSString *url = [NSString stringWithFormat:@"%@/order/list",HTTPURL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
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
                NSMutableArray *boaringItem =   [WZBoardingItem mj_objectArrayWithKeyValuesArray:_listArray];
                _boaringItem = boaringItem;
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
    view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-45);
    [view setHidden:NO];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"wddd_k"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(94);
        make.width.offset(181);
        make.height.offset(150);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无订单";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    label.textColor = UIColorRBG(187, 187, 187);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(42);
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _boaringItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"BoadingCellThree";//对应xib中设置的identifier
    NSInteger index = 2; //xib中第几个Cell
     WZBoardingItem *item = _boaringItem[indexPath.row];
    WZBoaringCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WZBoaringCell" owner:self options:nil] objectAtIndex:index];
    }
    cell.item = item;
    self.cell = cell;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 147;
}
#pragma mark -跳转详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取点击cell的数据
    WZBoaringCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *Identifier =  cell.reuseIdentifier;
    
    //跳转详情页
    WZBoardingDetailsController *detailVC = [[WZBoardingDetailsController alloc] init];
    detailVC.Identifier = Identifier;
    WZBoardingItem *item = _boaringItem[indexPath.row];
    detailVC.ID = item.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNewTopics];
}
@end
