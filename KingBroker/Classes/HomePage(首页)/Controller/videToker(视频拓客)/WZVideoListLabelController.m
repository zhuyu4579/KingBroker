//
//  WZVideoListLabelController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZTokerVItem.h"
#import "LMHWaterFallLayout.h"
#import "NSString+LCExtension.h"
#import "WZLabelVideoListCell.h"
#import "WZVideoListLabelController.h"
#import "WZVideoDailtelController.h"
@interface WZVideoListLabelController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    //页数
    NSInteger current;
}
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *listArray;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;

@property(nonatomic,strong)UICollectionView *collectionView;
@end

static NSString * const ID = @"Cells";

@implementation WZVideoListLabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    _listArray = [NSMutableArray array];
    current = 1;
    _isRequestFinish = YES;
    
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    
    LMHWaterFallLayout *waterFallLayout = [[LMHWaterFallLayout alloc] init];
    
    // 创建collectionView
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:waterFallLayout];
    collectionView.backgroundColor = UIColorRBG(247, 247, 247);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView = collectionView;
    [self.view addSubview:collectionView];
    //注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WZLabelVideoListCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self headerRefresh];
}
//下拉刷新
-(void)headerRefresh{
    //创建下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    // 设置文字
    [header setTitle:@"刷新完毕..." forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.mj_h = 30;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    self.collectionView.mj_header = header;
    
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    self.collectionView.mj_footer = footer;
    
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic{
    [self.collectionView.mj_header beginRefreshing];
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}

-(void)loadMoreTopic{
    [self.collectionView.mj_footer beginRefreshing];
    [self loadDate];
}
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
    if ([_type isEqual:@"0"]) {
        paraments[@"title"] = _name;
    }else{
        paraments[@"classfiyId"] = _classfiyId;
    }
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = @"20";
      NSString *url = [NSString stringWithFormat:@"%@/hotTopic/read/querycontent",HTTPURL];
    if ([_type isEqual:@"1"]) {
        url = [NSString stringWithFormat:@"%@/video/moreVodioByClassfiy",HTTPURL];
    }

    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSMutableDictionary *data = [responseObject valueForKey:@"data"];
            NSMutableArray *rows = [data valueForKey:@"rows"];
            
            //将数据转换成模型
            if (rows.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i = 0; i<rows.count; i++) {
                    [_listArray addObject:rows[i]];
                }
                current +=1;
                [self.collectionView.mj_footer endRefreshing];
            }
            //            if (_listArray.count != 0) {
            //                [_viewNo setHidden:YES];
            //            }else{
            //                [_viewNo setHidden:NO];
            //            }
            
            NSMutableArray *boaringItem = [WZTokerVItem mj_objectArrayWithKeyValuesArray:_listArray];
            _array = boaringItem;
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                
                [NSString isCode:self.navigationController code:code];
                //更新指定item
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                item.badgeValue= nil;
            }
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }
        _isRequestFinish = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        _isRequestFinish = YES;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZLabelVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZTokerVItem *item = _array[indexPath.row];
    cell.item = item;
    return cell;
}
//点击图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self loadUpVideo];
    WZLabelVideoListCell *cell = (WZLabelVideoListCell *) [collectionView cellForItemAtIndexPath:indexPath];
    WZVideoDailtelController *videoDail = [[WZVideoDailtelController alloc] init];
    videoDail.dicty = cell.dicty;
    [self.navigationController pushViewController:videoDail animated:YES];
    
}
#pragma mark -点击视频
-(void)loadUpVideo{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *url = [NSString stringWithFormat:@"%@/video/videoClick",HTTPURL];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
