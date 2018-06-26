//
//  WZPagesViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPagesViewController.h"
#import "WZCyclePhotoView.h"
#import "UIView+Frame.h"
#import "WZPageButtonView.h"
#import <Masonry.h>
#import <AFNetworking.h>
#import "WZTaskController.h"
#import "WZTaskTagItem.h"
#import <MJExtension.h>
#import "WZTaskTagCell.h"
#import "WZRecommendTableView.h"
#import "WZTaskTableView.h"
#import <MJRefresh.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "NSString+LCExtension.h"
#import <SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "WZFindHouseListItem.h"
#import "WZNEWHTMLController.h"
#import "GKCover.h"
@interface WZPagesViewController ()<WZCyclePhotoViewClickActionDeleage,UIScrollViewDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)UIView *cycleView;
@property (nonatomic, strong)WZCyclePhotoView *cyclePlayView;
@property (nonatomic, strong)NSMutableArray *tags;
@property (nonatomic, strong)WZTaskTableView *tableVC;
@property (nonatomic, strong)WZRecommendTableView *recommendTV;
@property (nonatomic, strong)UIScrollView *scrollView;
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
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    
    [self setViewController];
    //获取最新版本
    [self findversion];
    
    [self dictList];
   
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    //创建一个滚动视图
    _scrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.fHeight - JF_BOTTOM_SPACE-49)];
    
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
    _cycleView = [[UIView alloc] initWithFrame: CGRectMake(0, -kApplicationStatusBarHeight, SCREEN_WIDTH, 190*n)];
    _cycleView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_cycleView];
    //初始化轮播图
    NSMutableArray *images = [[NSMutableArray alloc]init];
    UIImage *image = [UIImage imageNamed:@"banner-1"];
    [images addObject:image];
    self.cyclePlayView = [[WZCyclePhotoView alloc] initWithImages:images withFrame:CGRectMake(0, 0, _cycleView.fWidth, _cycleView.fHeight)];
    self.cyclePlayView.delegate = self;
    [self.cyclePlayView.timer  invalidate];
    self.cyclePlayView.backgroundColor = [UIColor grayColor];
    [_cycleView addSubview:self.cyclePlayView];
    //创建按钮栏
    UIView *buttons = [[UIView alloc] initWithFrame:CGRectMake(0, _cycleView.fHeight-kApplicationStatusBarHeight, SCREEN_WIDTH, 136)];
    buttons.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:buttons];
    WZPageButtonView *pageView = [WZPageButtonView pageButtons];
    pageView.frame = buttons.bounds;
    [buttons addSubview:pageView];
//    //创建任务中心
//    UIView *task = [[UIView alloc] initWithFrame:CGRectMake(0, buttons.fY+buttons.fHeight+10, SCREEN_WIDTH, 388)];
//    task.backgroundColor = [UIColor clearColor];
//    [_scrollView addSubview:task];

    //创建为你推荐
    UIView *Recommend = [[UIView alloc] initWithFrame:CGRectMake(0, buttons.fY+buttons.fHeight+10, SCREEN_WIDTH, 740*n)];
    Recommend.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:Recommend];
    //创建为你推荐图标
    UIImageView *recommendImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 17, 18)];
    recommendImage.image = [UIImage imageNamed:@"recmmend"];
    [Recommend addSubview:recommendImage];
    //创建为你推荐标题
    UILabel *recommendLable = [[UILabel alloc] initWithFrame:CGRectMake(42, 15, 71, 17)];
    recommendLable.text = @"为你推荐";
    recommendLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    recommendLable.textColor = UIColorRBG(68, 68, 68);
    [Recommend addSubview:recommendLable];
    //创建为你推荐房源view62
    _recommendTV = [[WZRecommendTableView alloc] initWithFrame:CGRectMake(0, recommendLable.fY+recommendLable.fHeight, Recommend.fWidth, 708*n)];
    
    [Recommend addSubview:_recommendTV];

    _scrollView.contentSize = CGSizeMake(0, Recommend.fY+Recommend.fHeight);
    
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
    paraments[@"num"] = @"2";
    NSString *url = [NSString stringWithFormat:@"%@/proProject/recommend/projectList",URL];
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
#pragma mark -滑动scrollview触发事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
}
-(BOOL)prefersStatusBarHidden{
    if(_scrollView.contentOffset.y>190){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -点击图片事件
- (void)cyclePageClickAction:(NSInteger)clickIndex
{
    WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
    html.url = @"https://www.jingfuapp.com/apph5/noticemessage.html";
    [self.navigationController pushViewController:html animated:YES];
}
#pragma mark -去刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    [_scrollView.mj_header beginRefreshing];
    [self loadDateTask];
}
//获取版本号
-(void)findversion{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    NSString *appVersion = [user objectForKey:@"appVersion"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    paraments[@"app"] = @"2";
    NSString *url = [NSString stringWithFormat:@"%@/version/versionUp",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            //最新版本号
            NSString *newVersion = [data valueForKey:@"version"];
            NSString *downAddress = [data valueForKey:@"downAddress"];
            if (![appVersion isEqual: newVersion]) {
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
    NSString *isno_up = [dicy valueForKey:@"isno_up"];
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
    description.text = [dicy valueForKey:@"version_description"];
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
//获取字典
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
    NSString *url = [NSString stringWithFormat:@"%@/version/dictList",URL];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
//根据URL获取图片
-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
@end
