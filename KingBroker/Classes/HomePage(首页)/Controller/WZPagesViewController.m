//
//  WZPagesViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//









#import "GKCover.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import "WZGoodHouseItem.h"
#import "WZCyclePhotoView.h"
#import "WZPageButtonView.h"
#import "WZTaskController.h"
#import "WZFindHouseListItem.h"
#import "WZNEWHTMLController.h"
#import "WZRecommendTableView.h"
#import "NSString+LCExtension.h"
#import "WZPagesViewController.h"
#import "WZNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "WZGoodHouseCollectionView.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZJionStoreAndStoreHeadController.h"

@interface WZPagesViewController ()<WZCyclePhotoViewClickActionDeleage,UIScrollViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)UIView *cycleView;
@property (nonatomic, strong)NSMutableArray *tags;
@property (nonatomic, strong)WZCyclePhotoView *cyclePlayView;
@property (nonatomic, strong)WZRecommendTableView *recommendTV;
@property (nonatomic, strong)WZGoodHouseCollectionView *goodHouseCollectView;
@property (nonatomic, strong)UIScrollView *scrollView;
//动态模块
@property (nonatomic, strong)WZPageButtonView *pageView;
//使用定位
@property (nonatomic , strong)CLLocationManager *locationManager;
//定位
@property(nonatomic,strong)NSString *lnglat;
//
@property(nonatomic,strong)UIView *updateView;

@end

@implementation WZPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    //创建控件
    [self setViewController];
    //获取最新版本
    [self findversion];
    
    [self loadNewsAnnounceme];
    
}

//开启定位
-(void)locate{
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        [_locationManager startUpdatingLocation];//开启定位
}
//获取定位信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSString *lnglat = @"";
    if (locations.count != 0) {
      CLLocation *currentLocation = locations[0];
      CLLocationCoordinate2D  touchMapCoordinate = currentLocation.coordinate;
      [manager stopUpdatingLocation];
      lnglat = [NSString stringWithFormat:@"%f,%f",touchMapCoordinate.longitude,touchMapCoordinate.latitude];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"定位失败"];
    }
    _lnglat = lnglat;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lnglat forKey:@"lnglat"];
    [defaults synchronize];
}

#pragma mark -创建首页控件
-(void)setViewController{
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    //导航栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, kApplicationStatusBarHeight+44)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    //标题
    UIImageView *imageViewTitle = [[UIImageView alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight+9, 118, 27)];
    imageViewTitle.image = [UIImage imageNamed:@"sy_title"];
    [titleView addSubview:imageViewTitle];
    
    //创建一个滚动视图
    _scrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+44, SCREEN_WIDTH, self.view.fHeight - JF_BOTTOM_SPACE-93-kApplicationStatusBarHeight)];
    
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = UIColorRBG(242, 242, 242);
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
    
    //设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    _scrollView.mj_header = header;
    //创建轮播图view
    _cycleView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 190*n)];
    _cycleView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_cycleView];
    //初始化轮播图
    NSMutableArray *images = [[NSMutableArray alloc]init];
    UIImage *image = [UIImage imageNamed:@"banner_1"];
    [images addObject:image];
    self.cyclePlayView = [[WZCyclePhotoView alloc] initWithImages:images withFrame:CGRectMake(15, 0, _cycleView.fWidth-15, _cycleView.fHeight)];
    self.cyclePlayView.delegate = self;
//  [self.cyclePlayView.timer  invalidate];
    self.cyclePlayView.backgroundColor = [UIColor whiteColor];
    [_cycleView addSubview:self.cyclePlayView];
    //创建按钮栏
    UIView *buttons = [[UIView alloc] initWithFrame:CGRectMake(0, _cycleView.fHeight, SCREEN_WIDTH, 200)];
    buttons.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:buttons];
    WZPageButtonView *pageView = [WZPageButtonView pageButtons];
    pageView.frame = buttons.bounds;
    _pageView = pageView;
    [buttons addSubview:pageView];
    //创建优质楼盘
    UIView *goodHouseView = [[UIView alloc] initWithFrame:CGRectMake(0, buttons.fY+buttons.fHeight+10, SCREEN_WIDTH, 288)];
    goodHouseView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:goodHouseView];
    //创建为你推荐图标
    UIImageView *imageTitle = [[UIImageView alloc] init];
    imageTitle.image = [UIImage imageNamed:@"sy_pic"];
    [goodHouseView addSubview:imageTitle];
    [imageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(goodHouseView.mas_centerX);
        make.top.equalTo(goodHouseView.mas_top).offset(20);
        make.width.offset(190);
        make.height.offset(3);
    }];
    UILabel *goodHouseTitle = [[UILabel alloc] init];
    goodHouseTitle.text = @"优选楼盘";
    goodHouseTitle.textColor = UIColorRBG(51, 51, 51);
    goodHouseTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [goodHouseView addSubview:goodHouseTitle];
    [goodHouseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(goodHouseView.mas_centerX);
        make.top.equalTo(goodHouseView.mas_top).offset(15);
        make.height.offset(14);
    }];
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.textColor = UIColorRBG(102, 102, 102);
    subTitle.text = @"OPTIMIZING BUILDINGS";
    subTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    [goodHouseView addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(goodHouseView.mas_centerX);
        make.top.equalTo(goodHouseTitle.mas_bottom).offset(6);
        make.height.offset(9);
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(100, 100);
    WZGoodHouseCollectionView *goodHouseCollectView = [[WZGoodHouseCollectionView alloc] initWithFrame:CGRectMake(0, 43, goodHouseView.fWidth, 245) collectionViewLayout:layout];
    goodHouseCollectView.backgroundColor = [UIColor clearColor];
    _goodHouseCollectView = goodHouseCollectView;
    //禁止滑动
    goodHouseCollectView.scrollEnabled = NO;
    [goodHouseView addSubview:goodHouseCollectView];
    
    //创建为你推荐
    UIView *Recommend = [[UIView alloc] initWithFrame:CGRectMake(0, goodHouseView.fY+goodHouseView.fHeight+10, SCREEN_WIDTH, 964)];
    Recommend.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:Recommend];
    //创建为你推荐图标
    UIImageView *recommendImage = [[UIImageView alloc] init];
    recommendImage.image = [UIImage imageNamed:@"sy_pic"];
    [Recommend addSubview:recommendImage];
    [recommendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Recommend.mas_centerX);
        make.top.equalTo(Recommend.mas_top).offset(20);
        make.width.offset(190);
        make.height.offset(3);
    }];
    //创建为你推荐标题
    UILabel *recommendLable = [[UILabel alloc] init];
    recommendLable.text = @"为你推荐";
    recommendLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    recommendLable.textColor = UIColorRBG(51, 51, 51);
    [Recommend addSubview:recommendLable];
    [recommendLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Recommend.mas_centerX);
        make.top.equalTo(Recommend.mas_top).offset(15);
        make.height.offset(14);
    }];
    UILabel *subTitles = [[UILabel alloc] init];
    subTitles.textColor = UIColorRBG(102, 102, 102);
    subTitles.text = @"RECOMMEND TO YOU";
    subTitles.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    [Recommend addSubview:subTitles];
    [subTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(Recommend.mas_centerX);
        make.top.equalTo(recommendLable.mas_bottom).offset(6);
        make.height.offset(9);
    }];
    //创建为你推荐房源view62
    _recommendTV = [[WZRecommendTableView alloc] initWithFrame:CGRectMake(0, 48, Recommend.fWidth, 915)];
    
    [Recommend addSubview:_recommendTV];

    _scrollView.contentSize = CGSizeMake(0, Recommend.fY+Recommend.fHeight);
    
}
#pragma mark -查询最新动态公告
-(void)loadNewsAnnounceme{
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
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/announcement",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            
            _pageView.anNewLabel.text = [data valueForKey:@"title"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark -查询优选楼盘
-(void)goodHouseLoadData{
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
    NSString *url = [NSString stringWithFormat:@"%@/projectLabel/selectLabelList",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
           NSArray *rows = [data valueForKey:@"rows"];
            if (rows.count>0) {
                _goodHouseCollectView.houseArray = [WZGoodHouseItem mj_objectArrayWithKeyValuesArray:rows];
                [_goodHouseCollectView reloadData];
            }
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark -请求数据查询为你推荐
-(void)loadDateTask{
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
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"location"] = _lnglat;
    paraments[@"num"] = @"6";
    NSString *url = [NSString stringWithFormat:@"%@/proProject/recommend/projectList",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            if (rows.count != 0) {
                _recommendTV.listArray = [WZFindHouseListItem mj_objectArrayWithKeyValuesArray:rows];
                [_recommendTV  reloadData];
            }
             [_scrollView.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
             [_scrollView.mj_header endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [_scrollView.mj_header endRefreshing];
    }];
}

//点击模块
-(void)Tacks{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    
    if(uuid){
        if([realtorStatus isEqual:@"2"]){
            //跳转
            WZTaskController *task = [[WZTaskController alloc] init];
            task.url = [NSString stringWithFormat:@"%@/apptask/getuuid.html",HTTPH5];
             WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:task];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }else if([realtorStatus isEqual:@"0"] ||[realtorStatus isEqual:@"3"]){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"未加入门店" message:@"你还没有加入经纪门店，不能进行更多操作"  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不加入" style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                  }];
            UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"加入门店" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       WZJionStoreAndStoreHeadController *JionStore = [[WZJionStoreAndStoreHeadController alloc] init];
                                                                       WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
                                                                       JionStore.type = @"1";
                                                                       JionStore.jionType = @"1";
                                                                       [self presentViewController:nav animated:YES completion:nil];
                                                                   }];
            [cancelAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
            [defaultAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
            [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
        }
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }

}
#pragma mark -点击图片事件
- (void)cyclePageClickAction:(NSInteger)clickIndex
{
    WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
    html.url = [NSString stringWithFormat:@"%@/apph5/noticemessage.html",HTTPH5];
    [self.navigationController pushViewController:html animated:YES];
}
#pragma mark -去刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    [_scrollView.mj_header beginRefreshing];
    [self goodHouseLoadData];
    [self loadDateTask];
    [self loadNewsAnnounceme];
    
}
//获取版本号
-(void)findversion{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //当前版本
    NSString *appVersion = [user objectForKey:@"appVersion"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    paraments[@"app"] = @"2";
    NSString *url = [NSString stringWithFormat:@"%@/version/versionUp",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            //最新版本号
            NSString *newVersion = [data valueForKey:@"version"];
            NSString *downAddress = [data valueForKey:@"downAddress"];
            
            NSArray * array1 = [appVersion componentsSeparatedByString:@"."];
            NSInteger currentVersionInt = 0;
            if (array1.count == 3)//默认版本号1.0.0类型
            {
                currentVersionInt = [array1[0] integerValue]*100 + [array1[1] integerValue]*10 + [array1[2] integerValue];
            }else if(array1.count == 2){
                currentVersionInt = [array1[0] integerValue]*100 + [array1[1] integerValue]*10;
            }
            NSArray * array2 = [newVersion componentsSeparatedByString:@"."];
            NSInteger lineVersionInt = 0;
            if (array2.count == 3)
            {
                lineVersionInt = [array2[0] integerValue]*100 + [array2[1] integerValue]*10 + [array2[2] integerValue];
            }else if(array2.count == 2){
                lineVersionInt = [array2[0] integerValue]*100 + [array2[1] integerValue]*10;
            }
         
            if (lineVersionInt>currentVersionInt) {
                [self updateVersion:data];
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:newVersion forKey:@"newVersion"];
            [defaults setObject:downAddress forKey:@"downAddress"];
            [defaults synchronize];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建更新弹窗
-(void)updateVersion:(NSDictionary *)dicy{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(290, 300);
    _updateView = view;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, view.fWidth, view.fHeight);
    imageView.image = [UIImage imageNamed:@"pop"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发现新版本";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    label.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(115);
        make.height.offset(18);
    }];
    UIButton *cleanButton = [[UIButton alloc] init];
    [cleanButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(closeVersion) forControlEvents:UIControlEventTouchUpInside];
    [cleanButton setEnlargeEdge:44];
    NSString *isno_up = [dicy valueForKey:@"isnoUp"];
    if ([isno_up isEqual:@"1"]) {
        [cleanButton setHidden:YES];
        cleanButton.enabled = NO;
    }else{
        [cleanButton setHidden:NO];
        cleanButton.enabled = YES;
    }
    [view addSubview:cleanButton];
    [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-21);
        make.top.equalTo(view.mas_top).offset(110);
        make.height.offset(22);
        make.width.offset(22);
    }];
    UILabel *description = [[UILabel alloc] init];
    description.text = [dicy valueForKey:@"versionDescription"];
    description.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    description.textColor = UIColorRBG(153, 153, 153);
    description.numberOfLines = 0;
    [view addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(24);
        make.width.offset(view.fWidth-40);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"立即更新" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updataVersions) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    button.layer.cornerRadius = 17.0;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-21);
        make.height.offset(34);
        make.width.offset(124);
    }];
    
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
}
//关闭
-(void)closeVersion{
    [GKCover hide];
}
#pragma mark - 更新版本
-(void)updataVersions{
    UIApplication *application = [UIApplication sharedApplication];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *downAddress = [ user objectForKey:@"downAddress"];
    [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mt=8",downAddress]]];
}

#pragma mark-获取字典
-(void)dictList{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *version = [user objectForKey:@"version"];
    if (!version) {
        version = @"0";
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
  
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"version"] = version;
    paraments[@"type"] = @"1";
    NSString *url = [NSString stringWithFormat:@"%@/version/dictList",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSMutableArray *array = [data valueForKey:@"dictGroups"];
        //数据持久化
        if (array) {
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *fileName = [path stringByAppendingPathComponent:@"dictGroup.plist"];
            [array writeToFile:fileName atomically:YES];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[data valueForKey:@"version"] forKey:@"version"];
        [defaults synchronize];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //定位当前位置信息
    [self locate];
    [self loadDateTask];
    [self setloadData];
    [self goodHouseLoadData];
    [self dictList];
}
#pragma mark-查询未读消息
-(void)setloadData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/read/notreadCount",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *count = [data valueForKey:@"count"] ;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:count forKey:@"newCount"];
            [defaults synchronize];
            
            NSInteger counts = [count integerValue];
            
            UITabBarItem *item =[self.tabBarController.tabBar.items objectAtIndex:1];
            
            if (counts<100&&counts>0) {
                item.badgeValue= [NSString stringWithFormat:@"%ld",(long)counts];
            }else if(counts>=100){
                item.badgeValue= [NSString stringWithFormat:@"99+"];
            }else{
                item.badgeValue = nil;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark -将数据写入文件
-(void)loadDateURl:(NSArray *)array plistName:(NSString *)plistName name:(NSString *)name{
    NSMutableArray *marray = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSMutableDictionary *dactionary = [NSMutableDictionary dictionary];
        dactionary[name] = array[i];
        [marray addObject:dactionary];
    }
    NSString *pathName = [NSString getFilePathWithFileName:plistName];
    [marray writeToFile:pathName atomically:YES];
}
#pragma mark-根据URL获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
@end
