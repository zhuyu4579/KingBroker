//
//  WZPagesViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  首页

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
#import "WZLoadDateSeviceOne.h"
#import "WZFindHouseListItem.h"
#import "WZNEWHTMLController.h"
#import "WZRecommendTableView.h"
#import "NSString+LCExtension.h"
#import "WZPagesViewController.h"
#import "WZHouseNoteController.h"
#import "WZHouseDatisController.h"
#import "WZNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "WZGoodHouseCollectionView.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"
#import "WZSupportHouseDatisController.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
@interface WZPagesViewController ()<WZCyclePhotoViewClickActionDeleage,UIScrollViewDelegate,CLLocationManagerDelegate>
//导航栏
@property(nonatomic,strong)UIView *titleView;
//标题
@property(nonatomic,strong)UIImageView *imageViewTitle;
//滚动视图
@property (nonatomic, strong)UIScrollView *scrollView;
//下啦刷新
@property (nonatomic, strong)MJRefreshNormalHeader *header;
//轮播图view
@property(nonatomic,strong)UIView *cycleView;
//轮播图
@property (nonatomic, strong)WZCyclePhotoView *cyclePlayView;
//优选view
@property(nonatomic,strong)UIView *goodHouseView;
//优选标题
@property(nonatomic,strong)UIImageView *goodHouseImage;
@property(nonatomic,strong)UILabel *goodHouseTitle;
@property(nonatomic,strong)UILabel *goodHouseTitleE;
//推荐view
@property(nonatomic,strong)UIView *recommendView;
//推荐标题
@property(nonatomic,strong)UIImageView *recommendImage;
@property(nonatomic,strong)UILabel *recommendTitle;
@property(nonatomic,strong)UILabel *recommendTitleE;
//推荐
@property (nonatomic, strong)WZRecommendTableView *recommendTV;
//优选
@property (nonatomic, strong)WZGoodHouseCollectionView *goodHouseCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout *layouts;
//按钮动态模块
@property (nonatomic, strong)WZPageButtonView *pageView;
//使用定位
@property (nonatomic , strong)CLLocationManager *locationManager;
//定位
@property(nonatomic,strong)NSString *lnglat;
//更新
@property(nonatomic,strong)UIView *updateView;
//责任声明
@property(nonatomic,strong)UIView *dutyView;
@end

@implementation WZPagesViewController
#pragma mark -初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    
    [self.view addSubview:self.titleView];
    [self.titleView addSubview:self.imageViewTitle];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.cycleView];
    [self.scrollView addSubview:self.pageView];
    [self.scrollView addSubview:self.goodHouseView];
    self.scrollView.mj_header = self.header;
    [self.goodHouseView addSubview:self.goodHouseImage];
    [self.goodHouseView addSubview:self.goodHouseTitle];
    [self.goodHouseView addSubview:self.goodHouseTitleE];
    [self.goodHouseView addSubview:self.goodHouseCollectView];
    [self.scrollView addSubview:self.recommendView];
    [self.recommendView addSubview:self.recommendImage];
    [self.recommendView addSubview:self.recommendTitle];
    [self.recommendView addSubview:self.recommendTitleE];
    [self.recommendView addSubview:self.recommendTV];
    
    //获取最新版本
    [self findversion];
    //声明
    [self loadDutyState];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    self.titleView.frame = CGRectMake(0, 0, self.view.fWidth, kApplicationStatusBarHeight+44);
    self.imageViewTitle.frame = CGRectMake(15, kApplicationStatusBarHeight+9, 118, 27);
    self.scrollView.frame = CGRectMake(0, kApplicationStatusBarHeight+44, SCREEN_WIDTH, self.view.fHeight - JF_BOTTOM_SPACE-44-kApplicationStatusBarHeight);
    self.cycleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190*n);
    self.pageView.frame = CGRectMake(0, self.cycleView.fHeight, SCREEN_WIDTH, 200);
    self.goodHouseView.frame = CGRectMake(0, self.pageView.fY+self.pageView.fHeight+10, SCREEN_WIDTH, 288*n);
    self.goodHouseCollectView.frame = CGRectMake(0, 43, self.goodHouseView.fWidth, 288*n-43);
    self.recommendView.frame = CGRectMake(0, self.goodHouseView.fY+self.goodHouseView.fHeight+10, SCREEN_WIDTH, 964);
    self.recommendTV.frame = CGRectMake(0, 48, self.recommendView.fWidth, 915);
    self.scrollView.contentSize = CGSizeMake(0, self.recommendView.fY+self.recommendView.fHeight);
    //查询更新版本
    [self setloadData];
    //查询字典
    [self dictList];
    //查询banner数据
    [self loadBanner];
    //查询动态消息
    [self loadNewsAnnounceme];
    //查询优选楼盘数据
    [self goodHouseLoadData];
    //查询e为你推荐数据
    [self loadDateTask];
    //定位
    [self openlocation];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.goodHouseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodHouseView.mas_centerX);
        make.top.equalTo(self.goodHouseView.mas_top).offset(20);
        make.width.offset(190);
        make.height.offset(3);
    }];
    [self.goodHouseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodHouseView.mas_centerX);
        make.top.equalTo(self.goodHouseView.mas_top).offset(15);
        make.height.offset(14);
    }];
    [self.goodHouseTitleE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.goodHouseView.mas_centerX);
        make.top.equalTo(self.goodHouseTitle.mas_bottom).offset(6);
        make.height.offset(9);
    }];
    [self.recommendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recommendView.mas_centerX);
        make.top.equalTo(self.recommendView.mas_top).offset(20);
        make.width.offset(190);
        make.height.offset(3);
    }];
    [self.recommendTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recommendView.mas_centerX);
        make.top.equalTo(self.recommendView.mas_top).offset(15);
        make.height.offset(14);
    }];
    [self.recommendTitleE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recommendView.mas_centerX);
        make.top.equalTo(self.recommendTitle.mas_bottom).offset(6);
        make.height.offset(9);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.cyclePlayView.timer invalidate];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -CLLocationManagerDelegate
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
    self.lnglat = lnglat;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lnglat forKey:@"lnglat"];
    [defaults synchronize];
}
#pragma mark -WZCyclePhotoViewClickActionDeleage点击图片
- (void)cyclePageClickAction:(NSDictionary *)data
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *parameters = [data valueForKey:@"parameters"];
    NSInteger type = [[data valueForKey:@"type"] integerValue];
    NSString *url = [data valueForKey:@"url"];
    NSString *selfEmployed = [data valueForKey:@"selfEmployed"];
    if (type == 1) {
        WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
        html.url = url;
        [self.navigationController pushViewController:html animated:YES];
    } else if(type == 2){
        if (uuid&&![uuid isEqual:@""]) {
            if ([selfEmployed isEqual:@"2"]) {
                WZSupportHouseDatisController *houseDatis = [[WZSupportHouseDatisController alloc] init];
                houseDatis.ID = parameters;
                [self.navigationController pushViewController:houseDatis animated:YES];
            }else{
                WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
                houseDatis.ID = parameters;
                [self.navigationController pushViewController:houseDatis animated:YES];
            }
            
        }else{
            [NSString isCode:self.navigationController code:@"401"];
        }
        
    }else if(type == 3){
        if (uuid&&![uuid isEqual:@""]){
            WZTaskController *task = [[WZTaskController alloc] init];
            if ([url containsString:@"?"]) {
                task.url = [NSString stringWithFormat:@"%@&uuid=%@",url,uuid];
            } else {
                task.url = [NSString stringWithFormat:@"%@?uuid=%@",url,uuid];
            }
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:task];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }else{
            [NSString isCode:self.navigationController code:@"401"];
        }
        
    }else if(type == 4){
        //活动详情页
        //        if (uuid&&![uuid isEqual:@""]) {
        //跳转
        WZHouseNoteController *task = [[WZHouseNoteController alloc] init];
        if ([url containsString:@"?"]) {
            task.url = [NSString stringWithFormat:@"%@&uuid=%@",url,uuid];
        } else {
            task.url = [NSString stringWithFormat:@"%@?uuid=%@",url,uuid];
        }
        WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:task];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}
#pragma mark -加载数据
-(void)openlocation{
    //定位初始化
    _locationManager=[[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy= kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter=10;
    [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    [_locationManager startUpdatingLocation];//开启定位
}
-(void)loadBanner{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            NSArray  *rows = [data valueForKey:@"rows"];
            //加载banner
            [self setBanner:rows];
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/banner/read/list"];
    
}
-(void)loadNewsAnnounceme{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
         NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            _pageView.anNewLabel.text = [data valueForKey:@"title"];
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/userMessage/announcement"];
    
}
-(void)goodHouseLoadData{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            if (rows.count>0) {
                _goodHouseCollectView.houseArray = [WZGoodHouseItem mj_objectArrayWithKeyValuesArray:rows];
                [_goodHouseCollectView reloadData];
            }
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/projectLabel/selectLabelList"];
    
}
-(void)loadDateTask{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"location"] = _lnglat;
    paraments[@"num"] = @"6";
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            if (rows.count != 0) {
                _recommendTV.listArray = [WZFindHouseListItem mj_objectArrayWithKeyValuesArray:rows];
                [_recommendTV  reloadData];
            }
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
        [_scrollView.mj_header endRefreshing];
    } andFail:^(NSString *str) {
        [_scrollView.mj_header endRefreshing];
    } parament:paraments URL:@"/proProject/recommend/projectList"];
    
}

-(void)findversion{
    //当前版本
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *appVersion = [user objectForKey:@"appVersion"];
    
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    paraments[@"app"] = @"2";
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
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
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/version/versionUp"];
    
}
-(void)loadDutyState{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            NSString *statementValue = [data valueForKey:@"statementValue"];
            if (![statementValue isEqual:@"1"]) {
                [self dutyState];
            }
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/userGlobalInfo/getInfo"];
    
}

-(void)dictList{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *version = [user objectForKey:@"version"];
    if (!version) {
        version = @"0";
    }
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"version"] = version;
    paraments[@"type"] = @"1";
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSDictionary *data = [dic valueForKey:@"data"];
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
        
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/version/dictList"];
    
}

-(void)setloadData{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
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
        
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/userMessage/read/readAllCount"];
    
}
#pragma mark -点击事件
-(void)setBanner:(NSArray *)array{
    if (self.cycleView.subviews.count>0) {
        [self.cycleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    //初始化轮播图
    self.cyclePlayView = [[WZCyclePhotoView alloc] initWithImages:array withFrame:CGRectMake(15, 0, self.cycleView.fWidth-15, self.cycleView.fHeight)];
    self.cyclePlayView.pageChangeTime = 5.0;
    self.cyclePlayView.delegate = self;
    //[self.cyclePlayView.timer  invalidate];
    self.cyclePlayView.backgroundColor = [UIColor whiteColor];
    [self.cycleView addSubview:self.cyclePlayView];
}
-(void)loadNewTopic:(id)refrech{
    [_scrollView.mj_header beginRefreshing];
    [self goodHouseLoadData];
    [self loadDateTask];
    [self loadNewsAnnounceme];
    [self loadBanner];
}

-(void)dutyStateButton{
    [GKCover hide];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
    } andFail:^(NSString *str) {
    } parament:paraments URL:@"/userGlobalInfo/agreeInfo"];
}

-(void)updataVersions{
    UIApplication *application = [UIApplication sharedApplication];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *downAddress = [ user objectForKey:@"downAddress"];
    [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mt=8",downAddress]]];
}

#pragma mark - getter控件懒加载

//导航栏
-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}
//导航栏标题图片
-(UIImageView *)imageViewTitle{
    if (!_imageViewTitle) {
        _imageViewTitle = [[UIImageView alloc] init];
        _imageViewTitle.image = [UIImage imageNamed:@"sy_title"];
    }
    return _imageViewTitle;
}
//滚动视图
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [ [UIScrollView alloc ] init];
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColorRBG(242, 242, 242);
    }
    return _scrollView;
}
//下拉刷新
-(MJRefreshNormalHeader *)header{
    if (!_header) {
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic:)];
        // 设置文字
        [_header setTitle:@"刷新完毕..." forState:MJRefreshStateIdle];
        [_header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
        [_header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
        // 隐藏时间
        _header.lastUpdatedTimeLabel.hidden = YES;
        _header.mj_h = 60;
        // 设置字体
        _header.stateLabel.font = [UIFont systemFontOfSize:15];
        _header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        //设置颜色
        _header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    }
    return _header;
}
//轮播图View
-(UIView *)cycleView{
    if (!_cycleView) {
        _cycleView = [[UIView alloc] init];
        _cycleView.backgroundColor = [UIColor whiteColor];
    }
    return _cycleView;
}
//按钮
-(WZPageButtonView *)pageView{
    if (!_pageView) {
        _pageView = [WZPageButtonView pageButtons];
        _pageView.backgroundColor = [UIColor whiteColor];
    }
    return _pageView;
}
//优选
-(UIView *)goodHouseView{
    if (!_goodHouseView) {
        _goodHouseView = [[UIView alloc] init];
        _goodHouseView.backgroundColor = [UIColor whiteColor];
    }
    return _goodHouseView;
}
//优选标题
-(UIImageView *)goodHouseImage{
    if (!_goodHouseImage) {
        _goodHouseImage = [[UIImageView alloc] init];
        _goodHouseImage.image = [UIImage imageNamed:@"sy_pic"];
    }
    return _goodHouseImage;
}
-(UILabel *)goodHouseTitle{
    if (!_goodHouseTitle) {
        _goodHouseTitle = [[UILabel alloc] init];
        _goodHouseTitle.text = @"优选楼盘";
        _goodHouseTitle.textColor = UIColorRBG(51, 51, 51);
        _goodHouseTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    }
    return _goodHouseTitle;
}
-(UILabel *)goodHouseTitleE{
    if (!_goodHouseTitleE) {
        _goodHouseTitleE = [[UILabel alloc] init];
        _goodHouseTitleE.textColor = UIColorRBG(102, 102, 102);
        _goodHouseTitleE.text = @"OPTIMIZING BUILDINGS";
        _goodHouseTitleE.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _goodHouseTitleE;
}
//优选layout
-(UICollectionViewFlowLayout *)layouts{
    if (!_layouts) {
        float n = [UIScreen mainScreen].bounds.size.width/375.0;
        _layouts = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直流布局
        _layouts.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layouts.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _layouts.minimumLineSpacing = 20;
        _layouts.minimumInteritemSpacing = 10;
        _layouts.itemSize = CGSizeMake(100*n, 100*n);
    }
    return _layouts;
}
//优选
-(WZGoodHouseCollectionView *)goodHouseCollectView{
    if (!_goodHouseCollectView) {
        _goodHouseCollectView = [[WZGoodHouseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layouts];
        
        _goodHouseCollectView.backgroundColor = [UIColor clearColor];
        //禁止滑动
        _goodHouseCollectView.scrollEnabled = NO;
    }
    return _goodHouseCollectView;
}
//推荐
-(UIView *)recommendView{
    if (!_recommendView) {
        _recommendView = [[UIView alloc] init];
        _recommendView.backgroundColor = [UIColor whiteColor];
    }
    return _recommendView;
}
//推荐标题
-(UIImageView *)recommendImage{
    if(!_recommendImage){
        _recommendImage = [[UIImageView alloc] init];
        _recommendImage.image = [UIImage imageNamed:@"sy_pic"];
    }
    return _recommendImage;
}
-(UILabel *)recommendTitle{
    if (!_recommendTitle) {
        _recommendTitle = [[UILabel alloc] init];
        _recommendTitle.text = @"为你推荐";
        _recommendTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        _recommendTitle.textColor = UIColorRBG(51, 51, 51);
    }
    return _recommendTitle;
}
-(UILabel *)recommendTitleE{
    if (!_recommendTitleE) {
        _recommendTitleE = [[UILabel alloc] init];
        _recommendTitleE.textColor = UIColorRBG(102, 102, 102);
        _recommendTitleE.text = @"RECOMMEND TO YOU";
        _recommendTitleE.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _recommendTitleE;
}
-(WZRecommendTableView *)recommendTV{
    if (!_recommendTV) {
     _recommendTV = [[WZRecommendTableView alloc] init];
    }
    return _recommendTV;
}

#pragma mark - 创建更新弹窗
-(void)updateVersion:(NSDictionary *)dicy{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(245, 313);
    _updateView = view;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, view.fWidth, view.fHeight);
    imageView.image = [UIImage imageNamed:@"gx"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发现新版本";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    label.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(137);
        make.height.offset(13);
    }];
    UIButton *cleanButton = [[UIButton alloc] init];
    [cleanButton setBackgroundImage:[UIImage imageNamed:@"gb"] forState:UIControlStateNormal];
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
        make.right.equalTo(view.mas_right).offset(-12);
        make.top.equalTo(view.mas_top).offset(64);
        make.height.offset(22);
        make.width.offset(22);
    }];
    UILabel *description = [[UILabel alloc] init];
    description.text = [dicy valueForKey:@"versionDescription"];
    description.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    description.textColor = UIColorRBG(153, 153, 153);
    description.numberOfLines = 0;
    [view addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(35);
        make.width.offset(view.fWidth-32);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"立即更新" forState:UIControlStateNormal];
    [button setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [button setBackgroundImage:[UIImage imageNamed:@"gx_button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updataVersions) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 18;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-13);
        make.height.offset(36);
        make.width.offset(145);
    }];
    
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
}
-(void)closeVersion{
    [GKCover hide];
}

#pragma mark - 创建责任声明
-(void)dutyState{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(345, 574);
    _dutyView = view;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, view.fWidth, view.fHeight);
    imageView.image = [UIImage imageNamed:@"sy_tcsm"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"用户协议更新";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];
    label.textColor = UIColorRBG(54, 51, 50);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(30);
        make.height.offset(20);
    }];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"为了您能获得更优质的服务，我们推出喜喜直推楼盘";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelOne.textColor = UIColorRBG(102, 102, 102);
    labelOne.numberOfLines = 0;
    [view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(38);
        make.width.offset(view.fWidth-46);
    }];
    [UILabel changeSpaceForLabel:labelOne withLineSpace:1 WordSpace:1];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"1.喜喜直推是房喜喜平台全新上线的“实验室功能”，主要用于新模式新功能的测试。";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelTwo.textColor = UIColorRBG(102, 102, 102);
    labelTwo.numberOfLines = 0;
    [view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).offset(8);
        make.width.offset(view.fWidth-46);
    }];
    [UILabel changeSpaceForLabel:labelTwo withLineSpace:1 WordSpace:1];
    
    UILabel *labelThree = [[UILabel alloc] init];
    labelThree.numberOfLines = 0;
    [view addSubview:labelThree];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(labelTwo.mas_bottom).offset(8);
        make.width.offset(view.fWidth-46);
    }];
    NSString *cLabelString = @"2.标注为“喜喜直推”的楼盘，请直接在APP内进行客户报备。将由房喜喜平台跟进楼盘信息确认、客户报备、带看直至结佣的全过程并提供相应服务。";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cLabelString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 13],NSForegroundColorAttributeName: UIColorRBG(102, 102, 102),NSKernAttributeName:@(1.0)}];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:1];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [cLabelString length])];
    
    [string addAttributes:@{NSForegroundColorAttributeName: UIColorRBG(252, 143, 2)} range:NSMakeRange(6, 4)];
    
    [string addAttributes:@{NSForegroundColorAttributeName:UIColorRBG(252, 143, 2)} range:NSMakeRange(19, 4)];
    
    labelThree.attributedText = string;
    
    UILabel *labelFour = [[UILabel alloc] init];
    labelFour.numberOfLines = 0;
    [view addSubview:labelFour];
    [labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(labelThree.mas_bottom).offset(8);
        make.width.offset(view.fWidth-46);
    }];
    NSString *test3 = @"3.喜喜直推楼盘，售楼部可能未更新“扫码上客”功能，经纪人可在现场填写“客户报备单”，使用“凭证上客”功能上传纸质报备单，完成带看确认。为便于房喜喜开展服务，现场报备单上，请标注“房喜喜”字样，未正确标注的客户可能不被判定有效，敬请重视。";
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:test3 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 13],NSForegroundColorAttributeName: UIColorRBG(102, 102, 102),NSKernAttributeName:@(1.0)}];
    NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setLineSpacing:1];
    [string2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [test3 length])];
    
    [string2 addAttributes:@{NSForegroundColorAttributeName: UIColorRBG(252, 143, 2)} range:NSMakeRange(31, 11)];
    
    [string2 addAttributes:@{NSForegroundColorAttributeName:UIColorRBG(252, 143, 2)} range:NSMakeRange(46, 4)];
    
     [string2 addAttributes:@{NSForegroundColorAttributeName:UIColorRBG(252, 143, 2)} range:NSMakeRange(90, 3)];
    
    labelFour.attributedText = string2;
    
    UILabel *labelFive = [[UILabel alloc] init];
    labelFive.text = @"4.由售楼部现场直接发放的带看奖励、车费报销、补贴等款项由带看经纪人直接领取，房喜喜平台不代结代领，也不收取平台服务费用。";
    labelFive.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelFive.textColor = UIColorRBG(102, 102, 102);
    labelFive.numberOfLines = 0;
    [view addSubview:labelFive];
    [labelFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(labelFour.mas_bottom).offset(8);
        make.width.offset(view.fWidth-46);
    }];
    [UILabel changeSpaceForLabel:labelFive withLineSpace:1 WordSpace:1];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"我已阅读" forState:UIControlStateNormal];
    [button setTitleColor:UIColorRBG(255, 255, 255) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    button.backgroundColor = UIColorRBG(252, 213, 2);
    button.layer.cornerRadius = 22;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(dutyStateButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-66);
        make.height.offset(45);
        make.width.offset(view.fWidth-52);
    }];
    
    [GKCover coverFrom:[UIApplication sharedApplication].keyWindow
           contentView:view
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
   
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
