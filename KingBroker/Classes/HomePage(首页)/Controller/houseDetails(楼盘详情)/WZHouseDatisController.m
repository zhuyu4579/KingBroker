//
//  WZHouseDatisController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHouseDatisController.h"
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZCyclePhotoView.h"
#import "WZDetailsViewOne.h"
#import <Masonry.h>
#import "WZDynamictableView.h"
#import "WZMainUnitCollection.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "UIView+Center.h"
#import "WZTrafficTableView.h"
#import "WZSchoolTableView.h"
#import "WZShoppingTableView.h"
#import "WZHospitalTableView.h"
#import "WZBankTableView.h"
#import "WZReportController.h"
#import "GKCover.h"
#import <WXApi.h>
#import <WXApiObject.h>
#import "WZAlbumsViewController.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "WZMainUnitItem.h"
#import "NSString+LCExtension.h"
#import "WZPeripheryItem.h"
#import "WZAlbumPhonesViewController.h"
#import "WZLBCollectionView.h"
#import "WZLunBoItem.h"
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
#import "WZShareHouseController.h"
@interface WZHouseDatisController ()<WZCyclePhotoViewClickActionDeleage,UIScrollViewDelegate,MAMapViewDelegate>
//总view
@property(nonatomic,strong)UIScrollView *scrollView;
//轮播图
@property(nonatomic,strong)WZLBCollectionView *cycleView;
//底部按钮view
@property(nonatomic,strong)UIView *buttonView;
//导航栏view
@property(nonatomic,strong)UIView *tabView;
@property(nonatomic,strong)UIView *ineView;
@property(nonatomic,strong)UILabel *Bartitle;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)UIButton *shareButtons;
@property(nonatomic,strong)UIView *redView;
@property(nonatomic,strong)UIButton *popButton;
//楼盘简介
@property(nonatomic,strong)UIView *houseIntroduce;
@property(nonatomic,strong)UILabel *contents;
@property(nonatomic,strong)UIButton *moreButton;
//相册按钮
@property(nonatomic,strong)UIButton *album;
@property(nonatomic,strong)UIView *viewFour;
//分销流程
@property(nonatomic,strong)UIView *viewFive;
@property(nonatomic,strong)UIView *buttonViewIneOne;
@property(nonatomic,strong)UIView *buttonViewIneTwo;
@property(nonatomic,strong)UILabel *ScLabelOnes;
@property(nonatomic,strong)UILabel *ScLabelTwos;
@property(nonatomic,strong)UILabel *ScLabelThrees;
//主力户型
@property(nonatomic,strong)UIView *viewSix;
//主力户型
@property(nonatomic,strong)WZMainUnitCollection *collect;
//位置以及周边
@property(nonatomic,strong)UIView *viewSeven;
@property(nonatomic,strong)UIButton *previousClickButton;
@property(nonatomic,strong)UIView *titleUnderLine;
@property(nonatomic,strong)UIView *tableView;
//位置坐标
@property(nonatomic,strong)NSArray *lnglat;
//数据字典
@property(nonatomic,strong)NSDictionary *houseDatils;
//基本信息
@property(nonatomic,strong)WZDetailsViewOne *dView;
//楼盘动态
@property(nonatomic,strong)UIView *dynamicView;
@property(nonatomic,strong)WZDynamictableView *dynamic;
@property(nonatomic,strong)UILabel *dyname;
@property(nonatomic,assign)CGFloat dynameHeight;
//合同有效期
@property(nonatomic,strong)UILabel *contract;
//结佣时间
@property(nonatomic,strong)UILabel *settlement;
//地图
@property(nonatomic,strong)MAMapView *mapView;
//地图点
@property(nonatomic,strong)MAPointAnnotation *pointAnnotation;
//周边
@property(nonatomic,strong)WZTrafficTableView *traffic;
@property(nonatomic,strong)WZSchoolTableView *school;
@property(nonatomic,strong)WZShoppingTableView *shop;
@property(nonatomic,strong)WZHospitalTableView *hospital;
@property(nonatomic,strong)WZBankTableView *bank;
//报备按钮
@property(nonatomic,strong)UIButton *reportButton;

@property(nonatomic,assign)CGFloat offor;
//打电话弹窗
@property(nonatomic,strong)UIView *playView;
@property(nonatomic,strong)UIButton *playTelphoneButton;
//电话数据
@property(nonatomic,strong)NSArray *telphoneArray;
//分享内容
@property(nonatomic,strong)NSDictionary *detailShareContents;
@end

@implementation WZHouseDatisController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];

    [AMapServices sharedServices].apiKey = @"3bb40a8380b1fdd9927ccac85bcd9a6d";
    [super viewDidLoad];
    //设置背景色
    [self setNavTitle];
    //创建UIScreenVIew
    [self getUpScreen];
    //创建分享和报备按钮
    [self getUpButton];
    //点击楼盘统计
    [self editClickNum];
    [self headerRefresh];
    //分享弹框
    [self shareTasks];
}

-(void)editClickNum{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/editClickNum",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
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
    
    self.scrollView.mj_header = header;
    
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.scrollView.mj_header beginRefreshing];
   
    [self loadData];
    
}
//数据请求
-(void)loadData{
   
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 30;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
        NSString *url = [NSString stringWithFormat:@"%@/proProject/projectInfo",HTTPURL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            //获取数据
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                _houseDatils = [responseObject valueForKey:@"data"];
                [self setData];
                
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
            }
            [self.scrollView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            [self.scrollView.mj_header endRefreshing];
        }];
    
}
//设置参数
-(void)setData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [user objectForKey:@"realtorStatus"];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    NSString *invisibleLinkmanFlag = [user objectForKey:@"invisibleLinkmanFlag"];
    //楼盘ID
    _ID = [_houseDatils valueForKey:@"id"];
    //设置照片
    NSArray *picCollect = [_houseDatils valueForKey:@"picCollect"];
     _cycleView.arrayDatas = [WZLunBoItem mj_objectArrayWithKeyValuesArray:picCollect];
    //[UIView setAnimationsEnabled:NO];
    [UIView performWithoutAnimation:^{
        //刷新界面
       [_cycleView reloadData];
        //[UIView setAnimationsEnabled:YES];
    }];
    
    //设置页面张数
    NSString *alnumSum = [_houseDatils valueForKey:@"pictureNum"];
    [_album setTitle:[NSString stringWithFormat:@"共%@张",alnumSum] forState:UIControlStateNormal];
    //设置收藏
    NSString  *collect = [_houseDatils valueForKey:@"collect"];
    if ([collect isEqual:@"0"]) {
        _likeButton.selected = NO;
    }else{
        _likeButton.selected = YES;
    }
    //设置楼盘名
    _dView.itemName.text = [_houseDatils valueForKey:@"name"];
    //设置单价
    //总价
    NSString *totalPrice = [_houseDatils valueForKey:@"totalPrice"];
     NSString *price = [_houseDatils valueForKey:@"averagePrice"];
    if (totalPrice && ![totalPrice isEqual:@""]) {
        _dView.price.text = totalPrice;
    }else{
        _dView.price.text = price;
    }

    NSArray *labelArray = [_houseDatils valueForKey:@"tage"];
    for (int i = 0; i<labelArray.count; i++) {
        if (i == 0) {
             _dView.itemLabel.text = labelArray[0];
        } else if(i == 1){
            _dView.itemLabelTwo.text = labelArray[1];
        }else if(i == 2){
             _dView.itemLabelThree.text = labelArray[2];
        }
    }
    
    if ([realtorStatus isEqual:@"2"]) {
        [_dView.JoinButton setHidden:YES];
        [_dView.JoinButton setEnabled:NO];
        [_dView.commissionButton setHidden:NO];
        [_dView.Commission setHidden:NO];
        if([commissionFag isEqual:@"0"]){
             _dView.Commission.text = [_houseDatils valueForKey:@"commission"];
            _reportButton.enabled = YES;
        }else{
            _dView.Commission.text = @"";
            _reportButton.enabled = YES;
        }
        if ([invisibleLinkmanFlag isEqual:@"0"]) {
            _dView.chargeMan.text = [_houseDatils valueForKey:@"chargeMan"];
            _dView.phone.text = [_houseDatils valueForKey:@"telphone"];
        }else{
            _dView.chargeMan.text = @"电话不可见";
            _dView.phone.text = @"";
        }
    }else{
        [_dView.JoinButton setHidden:NO];
        [_dView.JoinButton setEnabled:YES];
        [_dView.commissionButton setHidden:YES];
        [_dView.Commission setHidden:YES];
        [_dView.JoinButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
         _reportButton.enabled = YES;
        _dView.chargeMan.text = @"加入门店可见电话";
        _dView.phone.text = @"";
    }
    
    _dView.address.text = [_houseDatils valueForKey:@"address"];

    //公司名称
    _dView.companyName.text = [_houseDatils valueForKey:@"companyName"];

    //楼盘动态
//    _dynamic.name = [_houseDatils valueForKey:@"dynamic"];
//    [_dynamic reloadData];
    _dyname.text = [_houseDatils valueForKey:@"dynamic"];
    //楼盘简介
    _contents.text = [_houseDatils valueForKey:@"outlining"];
    //合同有效期
    _contract.text = [_houseDatils valueForKey:@"strCollEndTime"];
    //结佣时间
    _settlement.text = [_houseDatils valueForKey:@"settlement"];
    //分销流程
    _ScLabelOnes.text = [_houseDatils valueForKey:@"reportDescribe"];
     _ScLabelTwos.text = [_houseDatils valueForKey:@"boardingDescribe"];
     _ScLabelThrees.text = [_houseDatils valueForKey:@"dealDescribe"];
    //主力户型
    NSArray *cols = [_houseDatils valueForKey:@"projectPictures"];
   
    _collect.collectDatas = [WZMainUnitItem mj_objectArrayWithKeyValuesArray:cols];
    [_collect reloadData];
    //位置及周边
    NSString *lng = [_houseDatils valueForKey:@"lnglat"];
    if (![lng isEqual:@""]) {
        _lnglat = [lng componentsSeparatedByString:@","];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake( [_lnglat[1] doubleValue], [_lnglat[0] doubleValue]);
        _pointAnnotation.coordinate = CLLocationCoordinate2DMake([_lnglat[1] doubleValue], [_lnglat[0] doubleValue]);
        _pointAnnotation.title = [_houseDatils valueForKey:@"address"];
        [_mapView selectAnnotation:_pointAnnotation animated:YES];
    }
    
    //位置数组
    NSMutableArray *traffics = [self setString:[_houseDatils valueForKey:@"traffics"]];
    _traffic.array =  [WZPeripheryItem mj_objectArrayWithKeyValuesArray:traffics];
    [_traffic reloadData];
    NSMutableArray *hospitals = [self setString:[_houseDatils valueForKey:@"hospitals"]];
    _hospital.array =  [WZPeripheryItem mj_objectArrayWithKeyValuesArray:hospitals];
    [_hospital reloadData];
    NSMutableArray *educations = [self setString:[_houseDatils valueForKey:@"educations"]];
    _school.array =  [WZPeripheryItem mj_objectArrayWithKeyValuesArray:educations];
    [_school reloadData];
    NSMutableArray *shops = [self setString:[_houseDatils valueForKey:@"shops"]];
    _shop.array =  [WZPeripheryItem mj_objectArrayWithKeyValuesArray:shops];
    [_shop reloadData];
    [self setDynamicHeight];
    [_reportButton setEnabled:YES];
}
//动态修改楼盘动态高度
-(void)setDynamicHeight{
    
    CGSize titleSize = [_dyname.text sizeWithFont:_dyname.font constrainedToSize:CGSizeMake(_dyname.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat n = titleSize.height+91;
    if (n==_dynameHeight) {
        return;
    }
    _dynameHeight = n;
    
    if(n>210){
        _dynamicView.fHeight +=n-210;
        _houseIntroduce.fY += n-210;
        _viewFour.fY +=n-210;
        _viewFive.fY +=n-210;
        _viewSix.fY +=n-210;
        _viewSeven.fY += n-210;
        _scrollView.contentSize = CGSizeMake(0,_viewSeven.fY + _viewSeven.fHeight+10);
    }else{
        _dynamicView.fHeight -=210-n;
        _houseIntroduce.fY -= 210-n;
        _viewFour.fY -=210-n;
        _viewFive.fY -=210-n;
        _viewSix.fY -=210-n;
        _viewSeven.fY -= 210-n;
        _scrollView.contentSize = CGSizeMake(0,_viewSeven.fY + _viewSeven.fHeight+10);
    }
    
}
-(void)setNavTitle{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
}
-(void)getUpScreen{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-JF_BOTTOM_SPACE)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    //创建轮播图
    [self getUpCycle];
    //设置导航条
    UIView *tabView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kApplicationStatusBarHeight+44)];
    tabView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    self.tabView = tabView;
    [self.view addSubview:tabView];
    //创建导航条返回按钮
    [self getUpTabButton];
    //创建图片相册按钮
    UIButton *album = [[UIButton alloc] initWithFrame:CGRectMake(self.view.fWidth -65,194-kApplicationStatusBarHeight, 50, 20)];
    [album setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
    [album addTarget:self action:@selector(albums) forControlEvents:UIControlEventTouchUpInside];
    [album setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    album.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    self.album = album;
    [scrollView addSubview:album];
    //创建第二个view
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, _cycleView.fHeight-kApplicationStatusBarHeight, scrollView.fWidth, 232)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:viewTwo];
    WZDetailsViewOne *dView = [WZDetailsViewOne detailViewTwo];
    dView.frame = viewTwo.bounds;
    _dView = dView;
    [viewTwo addSubview:dView];
    //创建第三个view
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY +viewTwo.fHeight +10, scrollView.fWidth, 210)];
    viewThree.backgroundColor = [UIColor whiteColor];
    _dynamicView = viewThree;
    //创建第三个view中的控件
    [self getUpThree:viewThree];
    [scrollView addSubview:viewThree];
    
    //楼盘简介
    UIView *houseIntroduce = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY +viewThree.fHeight +10, scrollView.fWidth, 208)];
    houseIntroduce.backgroundColor = [UIColor whiteColor];
    _houseIntroduce = houseIntroduce;
    [self houseIntroduce:houseIntroduce];
    [scrollView addSubview:houseIntroduce];
    
    //创建第四个view
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, houseIntroduce.fY +houseIntroduce.fHeight +10, scrollView.fWidth, 60)];
    //创建第四个view中的控件
    [self getUpFour:viewFour];
    _viewFour = viewFour;
    [scrollView addSubview:viewFour];
   
    //创建第五个view
    UIView *viewFive = [[UIView alloc] initWithFrame:CGRectMake(0, viewFour.fY +viewFour.fHeight +10, scrollView.fWidth, 500)];
    viewFive.backgroundColor = [UIColor whiteColor];
    self.viewFive = viewFive;
    //创建第五个view中的控件
    [self getUpFive:viewFive];
    [scrollView addSubview:viewFive];
    //创建第六个view
    UIView *viewSix = [[UIView alloc] initWithFrame:CGRectMake(0, viewFive.fY +viewFive.fHeight +10, scrollView.fWidth, 287)];
    viewSix.backgroundColor = [UIColor whiteColor];
    self.viewSix = viewSix;
    //创建第六个模块中的控件
    [self getUpSix:viewSix];
    [scrollView addSubview:viewSix];
    //创建第七个view
    UIView *viewSeven = [[UIView alloc] initWithFrame:CGRectMake(0, viewSix.fY +viewSix.fHeight +10, scrollView.fWidth, 646)];
    viewSeven.backgroundColor = [UIColor whiteColor];
    self.viewSeven = viewSeven;
    //创建第七个view的控件
    [self getUpSeven:viewSeven];
    [scrollView addSubview:viewSeven];
    scrollView.contentSize = CGSizeMake(0,viewSeven.fY + viewSeven.fHeight+10);
}

//轮播图
-(void)getUpCycle{
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    UIView *imageView = [[UIView alloc] initWithFrame: CGRectMake(0, -kApplicationStatusBarHeight, SCREEN_WIDTH,230*n)];
    [_scrollView addSubview:imageView];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(imageView.fWidth, imageView.fHeight);
    
    layout.minimumLineSpacing = 0;
    //创建collectionView 通过一个布局策略layout来创建
    WZLBCollectionView *LBCV = [[WZLBCollectionView alloc]initWithFrame:CGRectMake(0, 0, imageView.fWidth, imageView.fHeight) collectionViewLayout:layout];
    LBCV.projectId = _ID;
    self.cycleView = LBCV;
    [imageView addSubview:LBCV];
}
-(void)getUpTabButton{
    //创建返回按钮
    UIButton *popButton = [[UIButton alloc] initWithFrame:CGRectMake(15,kApplicationStatusBarHeight+7, 30, 30)];
    [popButton setBackgroundImage:[UIImage imageNamed:@"back_2"] forState:UIControlStateNormal];
    [popButton setBackgroundImage:[UIImage imageNamed:@"back_2"] forState:UIControlStateHighlighted];
    self.popButton = popButton;
    [popButton addTarget:self action:@selector(black) forControlEvents:UIControlEventTouchUpInside];
    [self.tabView addSubview:popButton];
    //创建分享按钮
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.fWidth-90, kApplicationStatusBarHeight+7, 30, 30)];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"share_2"] forState:UIControlStateNormal];
    self.shareButtons = shareButton;
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.tabView addSubview:shareButton];
    
    //创建收藏按钮
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.fWidth-45, kApplicationStatusBarHeight+7, 30, 30)];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"favorite_2"] forState:UIControlStateSelected];
    self.likeButton = likeButton;
    [likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabView addSubview:likeButton];
    
    
    UIView *ine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.fHeight, self.tabView.fWidth, 1)];
    ine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
    self.ineView = ine;
    [self.tabView addSubview:ine];
    UILabel *title= [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    title.textColor =[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0];
    title.text = @"楼盘详情";
    self.Bartitle = title;
    [self.tabView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tabView.mas_centerX);
        make.top.equalTo(self.tabView.mas_top).mas_offset(kApplicationStatusBarHeight+15);
        make.height.offset(14);
        
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (_offor >= 106) {
        
        return UIStatusBarStyleDefault;
    }
    
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
//滑动触发事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y - 106;
    _offor = scrollView.contentOffset.y;
     [self setNeedsStatusBarAppearanceUpdate];
    if(self.scrollView.contentOffset.y >= 106){
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.Bartitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        [_popButton setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
        [_popButton setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateHighlighted];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"favorite_3"] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"favorite_2(2)"] forState:UIControlStateSelected];
        [_shareButtons setBackgroundImage:[UIImage imageNamed:@"share-1"] forState:UIControlStateNormal];
    }else{
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
        self.Bartitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 0];
        [_popButton setBackgroundImage:[UIImage imageNamed:@"back_2"] forState:UIControlStateNormal];
        [_popButton setBackgroundImage:[UIImage imageNamed:@"back_2"] forState:UIControlStateHighlighted];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"favorite_2"] forState:UIControlStateSelected];
        [_shareButtons setBackgroundImage:[UIImage imageNamed:@"share_2"] forState:UIControlStateNormal];
    }
}
//第三个view中的控件
-(void)getUpThree:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"楼盘动态";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(20);
        make.height.offset(1);
        make.width.equalTo(view.mas_width);
    }];
    //
    UILabel *dyname = [[UILabel alloc] init];
    _dyname = dyname;
    dyname.numberOfLines = 0;
    dyname.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    dyname.textColor =  UIColorRBG(102, 102, 102);
    [view addSubview:dyname];
    [dyname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ineView.mas_bottom).mas_offset(20);
        make.width.offset(view.fWidth-30);
    }];
    
//    WZDynamictableView *tableView = [[WZDynamictableView alloc] init];
//    _dynamic = tableView;
//    [view addSubview:tableView];
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left);
//        make.top.equalTo(ineView.mas_bottom);
//        make.width.equalTo(view.mas_width);
//        make.height.offset(150);
//    }];
}
//楼盘简介
-(void)houseIntroduce:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"楼盘简介";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(20);
        make.height.offset(1);
        make.width.equalTo(view.mas_width);
    }];
    UILabel *contents = [[UILabel alloc] init];
    _contents = contents;

    contents.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    contents.numberOfLines = 5;
    contents.textColor = UIColorRBG(102, 102, 102);
    [view addSubview:contents];
    [contents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(ineView.mas_bottom).mas_offset(20);
        make.width.offset(view.fWidth-30);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [button setTitle:@"更多简介" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [button addTarget:self action:@selector(MoreContents) forControlEvents:UIControlEventTouchUpInside];
    _moreButton = button;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).mas_offset(0);
        make.width.offset(view.fWidth);
        make.height.offset(40);
    }];
}
//查看更多简介
-(void)MoreContents{
    _contents.numberOfLines = 0;
    
    [self performSelector:@selector(setContentHeight) withObject:self afterDelay:0.01];
}
-(void)setContentHeight{
    CGFloat n = _contents.fHeight-91;
    if (n>0) {
        [_moreButton setTitle:@"收起简介" forState:UIControlStateNormal];
        [_moreButton removeTarget:self action:@selector(MoreContents) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton addTarget:self action:@selector(takeUp) forControlEvents:UIControlEventTouchUpInside];
        _houseIntroduce.fHeight += n;
        _viewFour.fY +=n;
        _viewFive.fY +=n;
        _viewSix.fY +=n;
        _viewSeven.fY += n;
        _scrollView.contentSize = CGSizeMake(0,_viewSeven.fY + _viewSeven.fHeight+10);
    }
}
//收起更多简介
-(void)takeUp{
    _contents.numberOfLines = 5;
    CGFloat n = _contents.fHeight-91;
    if (n>0) {
        [_moreButton setTitle:@"更多简介" forState:UIControlStateNormal];
        [_moreButton removeTarget:self action:@selector(takeUp) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton addTarget:self action:@selector(MoreContents) forControlEvents:UIControlEventTouchUpInside];
        _houseIntroduce.fHeight -= n;
        _viewFour.fY -=n;
        _viewFive.fY -=n;
        _viewSix.fY -=n;
        _viewSeven.fY -= n;
        _scrollView.contentSize = CGSizeMake(0,_viewSeven.fY + _viewSeven.fHeight+10);
    }
}
//第四个view中的控件
-(void)getUpFour:(UIView *)view{
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (view.fWidth-5)/2, view.fHeight)];
    oneView.backgroundColor = [UIColor whiteColor];
    [view addSubview:oneView];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"合作有效期";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [oneView addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oneView.mas_centerX);
        make.top.equalTo(oneView.mas_top).mas_offset(12);
        make.height.offset(12);
    }];
    UILabel *contract = [[UILabel alloc] init];
    _contract = contract;
    contract.textAlignment = NSTextAlignmentCenter;
    contract.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    contract.textColor = UIColorRBG(3, 133, 219);
    [oneView addSubview:contract];
    [contract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oneView.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).mas_offset(13);
        make.height.offset(15);
    }];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(oneView.fWidth+5, 0, (view.fWidth-5)/2, view.fHeight)];
    twoView.backgroundColor = [UIColor whiteColor];
    [view addSubview:twoView];
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"结佣时间";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    labelTwo.textColor = UIColorRBG(68, 68, 68);
    [twoView addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(twoView.mas_centerX);
        make.top.equalTo(twoView.mas_top).mas_offset(12);
        make.height.offset(12);
    }];
    UILabel *CommissionTime = [[UILabel alloc] init];
    _settlement = CommissionTime;
    CommissionTime.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    CommissionTime.textColor = UIColorRBG(3, 133, 219);
    CommissionTime.textAlignment = NSTextAlignmentCenter;
    [twoView addSubview:CommissionTime];
    [CommissionTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(twoView.mas_centerX);
        make.top.equalTo(labelTwo.mas_bottom).mas_offset(13);
        make.height.offset(15);
        make.width.offset((view.fWidth-10)/2);
    }];
    
}
//第五个view中的控件
-(void)getUpFive:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"分销流程";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(20);
        make.height.offset(1);
        make.width.equalTo(view.mas_width);
    }];
   
    UIButton *buttonOne = [[UIButton alloc] init];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [buttonOne setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    buttonOne.layer.borderWidth = 1;
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:10];
    buttonOne.layer.cornerRadius =  7.5;
    buttonOne.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [view addSubview:buttonOne];
    [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ineView.mas_bottom).mas_offset(20);
        make.height.offset(15);
        make.width.offset(15);
    }];
    UILabel *ScLabelOne = [[UILabel alloc] init];
    ScLabelOne.text = @"报备客户";
    ScLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
    ScLabelOne.textColor =UIColorRBG(102, 102, 102);
    [view addSubview:ScLabelOne];
    [ScLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonOne.mas_right).mas_offset(15);
        make.top.equalTo(ineView.mas_bottom).mas_offset(20);
        make.height.offset(16);
    }];
    UILabel *ScLabelOnes = [[UILabel alloc] init];
    ScLabelOnes.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    ScLabelOnes.textColor =UIColorRBG(153, 153, 153);
    self.ScLabelOnes = ScLabelOnes;
    ScLabelOnes.numberOfLines = 0;
    [view addSubview:ScLabelOnes];
    [ScLabelOnes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonOne.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelOne.mas_bottom).mas_offset(11);
        make.right.equalTo(view.mas_right).mas_offset(-15);
    }];
   
    UIButton *buttonTwo = [[UIButton alloc] init];
    [buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    buttonTwo.layer.borderWidth = 1;
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:10];
    buttonTwo.layer.cornerRadius =  7.5;
    buttonTwo.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [view addSubview:buttonTwo];
    [buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ScLabelOnes.mas_bottom).mas_offset(20);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //绘制连线
    UIView *buttonViewIneOne = [[UIView alloc] init];
    buttonViewIneOne.backgroundColor = UIColorRBG(3, 133, 219);
    [view addSubview:buttonViewIneOne];
    self.buttonViewIneOne = buttonViewIneOne;
    
    UIView *buttonViewIneTwo = [[UIView alloc] init];
    buttonViewIneTwo.backgroundColor = UIColorRBG(3, 133, 219);
    [view addSubview:buttonViewIneTwo];
    self.buttonViewIneTwo = buttonViewIneTwo;
    UILabel *ScLabelTwo = [[UILabel alloc] init];
    ScLabelTwo.text = @"上客";
    ScLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
    ScLabelTwo.textColor =UIColorRBG(102, 102, 102);
    [view addSubview:ScLabelTwo];
    [ScLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonTwo.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelOnes.mas_bottom).mas_offset(20);
        make.height.offset(16);
    }];
    UILabel *ScLabelTwos = [[UILabel alloc] init];
    ScLabelTwos.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    ScLabelTwos.textColor =UIColorRBG(153, 153, 153);
    self.ScLabelTwos = ScLabelTwos;
    ScLabelTwos.numberOfLines = 0;
    [view addSubview:ScLabelTwos];
    [ScLabelTwos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonTwo.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelTwo.mas_bottom).mas_offset(11);
        make.right.equalTo(view.mas_right).mas_offset(-15);
    }];
    
    UIButton *buttonThree = [[UIButton alloc] init];
    [buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [buttonThree setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    buttonThree.layer.borderWidth = 1;
    buttonThree.titleLabel.font = [UIFont systemFontOfSize:10];
    buttonThree.layer.cornerRadius =  7.5;
    buttonThree.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [view addSubview:buttonThree];
    [buttonThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ScLabelTwos.mas_bottom).mas_offset(20);
        make.height.offset(15);
        make.width.offset(15);
    }];
    UILabel *ScLabelThree = [[UILabel alloc] init];
    ScLabelThree.text = @"成交";
    ScLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
    ScLabelThree.textColor =UIColorRBG(102, 102, 102);
    [view addSubview:ScLabelThree];
    [ScLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonThree.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelTwos.mas_bottom).mas_offset(20);
        make.height.offset(16);
    }];
    UILabel *ScLabelThrees = [[UILabel alloc] init];
    
    ScLabelThrees.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    ScLabelThrees.textColor =UIColorRBG(153, 153, 153);
    self.ScLabelThrees = ScLabelThrees;
    ScLabelThrees.numberOfLines = 0;
    [view addSubview:ScLabelThrees];
    [ScLabelThrees mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonThree.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelThree.mas_bottom).mas_offset(11);
        make.right.equalTo(view.mas_right).mas_offset(-15);
    }];
}
//动态修改模块的y值
-(void)viewDidLayoutSubviews{
    [self.view layoutIfNeeded];
    self.buttonViewIneOne.frame = CGRectMake(self.ScLabelOnes.fX-23, self.ScLabelOnes.fY-12, 1, self.ScLabelOnes.fHeight+32);
    self.buttonViewIneTwo.frame = CGRectMake(self.ScLabelTwos.fX-23, self.ScLabelTwos.fY-12, 1, self.ScLabelTwos.fHeight+32);
    self.viewFive.fHeight = _ScLabelThrees.fHeight+_ScLabelThrees.fY + 20;
    self.viewSix.fY = self.viewFive.fHeight + self.viewFive.fY +10;
    self.viewSeven.fY = self.viewSix.fHeight +self.viewSix.fY +10;
    _scrollView.contentSize = CGSizeMake(0,_viewSeven.fY + _viewSeven.fHeight+10);
}
//创建第六个模块的控件
-(void)getUpSix:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"主力户型";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(20);
        make.height.offset(1);
        make.width.equalTo(view.mas_width);
    }];
    UIView *Unit = [[UIView alloc] initWithFrame:CGRectMake(0, 75, view.fWidth, 193)];
    Unit.backgroundColor = [UIColor clearColor];
    [view addSubview:Unit];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(130, 193);
    layout.sectionInset = UIEdgeInsetsMake(0, 15,0,15);
    layout.minimumLineSpacing = 15;
    //创建collectionView 通过一个布局策略layout来创建
    WZMainUnitCollection * collect = [[WZMainUnitCollection alloc] initWithFrame:CGRectMake(0, 0, Unit.fWidth, Unit.fHeight) collectionViewLayout:layout];
    _collect = collect;
    [Unit addSubview:collect];
}
//创建第七个view的控件
-(void)getUpSeven:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"位置及周边";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:15];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(20);
        make.height.offset(1);
        make.width.equalTo(view.mas_width);
    }];
    //创建地图view
    UIView *mapViews = [[UIView alloc] initWithFrame:CGRectMake(0, 56, view.fWidth, 195)];
    mapViews.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:mapViews];
    [AMapServices sharedServices].enableHTTPS = YES;
    //初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:mapViews.bounds];
    _mapView = mapView;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.zoomLevel = 16.1;
    
    [mapViews addSubview:mapView];
    
    mapView.delegate = self;
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    _pointAnnotation = pointAnnotation;
    
    [mapView addAnnotation:pointAnnotation];
    //创建按钮导航栏
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, view.fWidth, 44)];
    
    [view addSubview:buttonView];
    //创建按钮
    [self getUpAddButton:buttonView];
     [self setupTitlesUnderline:buttonView];
    UIView *ineViewTwo = [[UIView alloc] init];
    ineViewTwo.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineViewTwo];
    [ineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(buttonView.mas_bottom);
        make.height.offset(1);
        make.width.equalTo(view.mas_width);
    }];
    //创建tableView的view
    UIView *tableView = [[UIView alloc] initWithFrame:CGRectMake(0, view.fHeight - 351, view.fWidth, 352)];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    [view addSubview:tableView];
    //初始化tableview
    [self initTableView:tableView];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"place1"];
        
        annotationView.canShowCallout= YES;//设置气泡可以弹出，默认为NO
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
-(void)initTableView:(UIView *)view{
    WZTrafficTableView *traffic = [[WZTrafficTableView alloc] initWithFrame:CGRectMake(0, view.fHeight - 352, SCREEN_WIDTH, 352)];
    _traffic = traffic;
    [view addSubview:traffic];
    WZSchoolTableView *school = [[WZSchoolTableView alloc] initWithFrame:CGRectMake(0, view.fHeight - 352, SCREEN_WIDTH, 352)];
    _school  = school;
    [view addSubview:school];
    WZShoppingTableView *shop = [[WZShoppingTableView alloc] initWithFrame:CGRectMake(0, view.fHeight - 352, SCREEN_WIDTH, 352)];
    _shop = shop;
    [view addSubview:shop];
    WZHospitalTableView *hospital = [[WZHospitalTableView alloc] initWithFrame:CGRectMake(0, view.fHeight - 352, SCREEN_WIDTH, 352)];
    _hospital = hospital;
    [view addSubview:hospital];
//    WZBankTableView *bank = [[WZBankTableView alloc] initWithFrame:CGRectMake(0, view.fHeight - 352, SCREEN_WIDTH, 352)];
//    _bank = bank;
//    [view addSubview:bank];
    
    [self hideTableView];
}
-(void)hideTableView{
    for (UIView *view in self.tableView.subviews) {
        [view setHidden:YES];
    }
}
-(void)getUpAddButton:(UIView *)view{
    //文字
    NSArray *titles =@[@"交通",@"学校",@"购物",@"医院"];
    
    CGFloat titleButtonW = view.fWidth/4;
    CGFloat titleButtonH =view.fHeight;
    
    for (NSInteger i = 0; i<4; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [view addSubview:titleButton];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i*titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
        titleButton.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        if (i == 0) {
            
            [self titleButtonClick:titleButton];
            
        }
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}

#pragma mark -按钮点击事件
-(void)titleButtonClick:(UIButton *)titleButton{
    self.previousClickButton.selected =NO;
    titleButton.selected = YES;
    self.previousClickButton = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        //处理下划线
        self.titleUnderLine.cX = titleButton.cX;
        [self hideTableView];
    }completion:^(BOOL finished) {
         UIView *childsView = self.tableView.subviews[titleButton.tag];
        [childsView setHidden:NO];
    }];
}
#pragma mark -设置下划线
-(void)setupTitlesUnderline:(UIView *)view{
    UIButton *firstTitleButton = view.subviews.firstObject;
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.fHeight = 2;
    titleUnderLine.fWidth = 65;
    titleUnderLine.fY = view.fHeight - titleUnderLine.fHeight;
    titleUnderLine.cX = view.fWidth/8;
    titleUnderLine.backgroundColor = [firstTitleButton  titleColorForState:UIControlStateSelected];
    [view addSubview:titleUnderLine];
    self.titleUnderLine = titleUnderLine;
}

#pragma mark -相册
-(void)albums{
    WZAlbumsViewController *albums = [[WZAlbumsViewController alloc] init];
    albums.ID = _ID;
    [self.navigationController pushViewController:albums animated:YES];
}

-(void)black{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击收藏
-(void)like:(UIButton *)button{
    //请求数据
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    if(uuid){
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
        NSString *url = [NSString stringWithFormat:@"%@/proProject/collectProject",HTTPURL];
        button.enabled = NO;
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSString *collect = [data valueForKey:@"collect"];
                if ([collect isEqual:@"1"]) {
                    _likeButton.selected = YES;
                    [SVProgressHUD showInfoWithStatus:@"加入我的楼盘成功"];
                }else{
                    _likeButton.selected = NO;
                }
                
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            }
             button.enabled = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
             button.enabled = YES;
        }];
    }
    
    
}
-(void)getUpButton{
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-JF_BOTTOM_SPACE, SCREEN_WIDTH, 49+JF_BOTTOM_SPACE)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    self.buttonView = buttonView;
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 1)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [buttonView addSubview:ineView];
    //创建打电话按钮
    UIImageView *playPhone = [[UIImageView alloc] initWithFrame:CGRectMake(30, (buttonView.fHeight-37)/2.0, 19, 21)];
    playPhone.image = [UIImage imageNamed:@"xmxq_phone"];
    [buttonView addSubview:playPhone];

    UILabel *labelP = [[UILabel alloc] init];
    labelP.frame = CGRectMake(29,playPhone.fY+25,25,12);
    labelP.text = @"电话";
    [labelP setTextColor:UIColorRBG(3, 133, 219)];
    labelP.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelP.textColor = UIColorRBG(3, 133, 219);
    [buttonView addSubview:labelP];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, buttonView.fHeight)];
    _playTelphoneButton = playButton;
    [playButton addTarget:self action:@selector(playPhones) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:playButton];
    //按钮的分割线
    UIView *ineViewTwo = [[UIView alloc] initWithFrame:CGRectMake(75, 5, 1, buttonView.fHeight-10)];
    ineViewTwo.backgroundColor = UIColorRBG(242, 242, 242);
    [buttonView addSubview:ineViewTwo];
    //创建分享按钮
    UIImageView *but = [[UIImageView alloc] initWithFrame:CGRectMake(101, (buttonView.fHeight-37)/2.0, 19, 19)];
    but.image = [UIImage imageNamed:@"share"];
    [buttonView addSubview:but];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(99,but.fY+25,25,12);
    label.text = @"分享";
    [label setTextColor:UIColorRBG(3, 133, 219)];
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    label.textColor = UIColorRBG(3, 133, 219);
    [buttonView addSubview:label];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 0, 75, buttonView.fHeight)];
     [shareButton addTarget:self action:@selector(shares) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:shareButton];
    //创建报备客户按钮
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, buttonView.fWidth-150, buttonView.fHeight)];
    [reportButton setTitle:@"报备客户" forState:UIControlStateNormal];
    reportButton.backgroundColor = UIColorRBG(3, 133, 219);
    _reportButton = reportButton;
    [reportButton setEnabled:NO];
    reportButton.titleLabel.textColor = [UIColor whiteColor];
    [reportButton addTarget:self action:@selector(resport) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:reportButton];
    
}

//查询电话列表
-(void)findCoustrom{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/telList",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            
            if (rows.count>0) {
                [self playViewPhone:rows];
                _telphoneArray = rows;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
//创建打电话弹框
-(void)playViewPhone:(NSArray *)array{
    NSInteger n = array.count;
    //可见
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-JF_BOTTOM_SPACE)];
    views.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    _playView = views;
     [views addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePlayViews)]];
    [views setHidden:YES];
    [self.view addSubview:views];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0,views.fHeight-50*n,self.view.fWidth, 50*n);
    [views addSubview:view];
    for (int i = 0; i<n; i++) {
        UILabel *name = [[UILabel alloc] init];
        name.text = [array[i] valueForKey:@"linkman"];
        name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        name.textColor = UIColorRBG(51, 51, 51);
        [view addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(15);
            make.top.equalTo(view.mas_top).offset(50*i+17);
            make.height.offset(16);
        }];
        UILabel *type = [[UILabel alloc] init];
        NSString *types = [array[i] valueForKey:@"type"];
        if ([types isEqual:@"1"]) {
            type.text = @" 负责人 ";
            type.textColor = [UIColor whiteColor];
            type.backgroundColor = UIColorRBG(86, 177, 255);
        }else{
            type.text = @" 报备对接人 ";
            type.textColor = UIColorRBG(153, 153, 153);
            type.backgroundColor = UIColorRBG(238, 238, 238);
        }
        type.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        [view addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right).offset(6);
            make.top.equalTo(view.mas_top).offset(50*i+17);
            make.height.offset(16);
        }];
        UIButton *pButton = [[UIButton alloc] init];
        [pButton setBackgroundImage:[UIImage imageNamed:@"xmxq_phone"] forState:UIControlStateNormal];
        pButton.tag = i;
        [pButton addTarget:self action:@selector(playTelphone:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:pButton];
        [pButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-15);
            make.top.equalTo(view.mas_top).offset(50*i+15);
            make.width.offset(19);
            make.height.offset(21);
        }];
        
        UILabel *cityName = [[UILabel alloc] init];
        cityName.text = [array[i] valueForKey:@"cityName"];
        cityName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        cityName.textColor = UIColorRBG(51, 51, 51);
        cityName.textAlignment = NSTextAlignmentRight;
        [view addSubview:cityName];
        [cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(pButton.mas_left).offset(-15);
            make.top.equalTo(view.mas_top).offset(50*i+18);
            make.height.offset(14);
            make.width.offset(100);
        }];
        if (i>0) {
            UIView *ineView = [[UIView alloc] init];
            ineView.backgroundColor = UIColorRBG(242, 242, 242);
            [view addSubview:ineView];
            [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left).offset(15);
                make.top.equalTo(view.mas_top).offset(50*i);
                make.height.offset(1);
                make.width.offset(view.fWidth-15);
            }];
        }
    }
}
-(void)hideViews{
    [_playView setHidden:YES];
}
//打电话弹框
-(void)playPhones{
     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
     NSString *invisibleLinkmanFlag = [user objectForKey:@"invisibleLinkmanFlag"];
    NSString *realtorStatus = [user objectForKey:@"realtorStatus"];
    if([realtorStatus isEqual:@"2"]){
        if ([invisibleLinkmanFlag isEqual:@"0"]) {
            [_playView setHidden:NO];
            [_playTelphoneButton removeTarget:self action:@selector(playPhones) forControlEvents:UIControlEventTouchUpInside];
            [_playTelphoneButton addTarget:self action:@selector(closePlayViews) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"无法拨打电话" message:@"电话不可见，将不能拨打电话，可联系门店负责人设置电话可见"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                  }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"无法拨打电话" message:@"你还没有加入经纪门店，将不能拨打电话"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不加入" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"加入门店" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   WZJionStoreController *JionStore = [[WZJionStoreController alloc] init];
                                                                   WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
                                                                   JionStore.type = @"1";
                                                                   [self presentViewController:nav animated:YES completion:nil];
                                                               }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
}
-(void)closePlayViews{
    [_playView setHidden:YES];
    [_playTelphoneButton removeTarget:self action:@selector(closePlayViews) forControlEvents:UIControlEventTouchUpInside];
    [_playTelphoneButton addTarget:self action:@selector(playPhones) forControlEvents:UIControlEventTouchUpInside];
}
-(void)playTelphone:(UIButton *)button{
    [self hideViews];
    NSString *phone = [_telphoneArray[0] valueForKey:@"linkTelphone"];
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}
//查询分享数据
-(void)findShare{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
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
    paraments[@"id"] = _ID;
    
    NSString *url = [NSString stringWithFormat:@"%@/proProject/projectInfoShare",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSMutableDictionary *data = [responseObject valueForKey:@"data"];
            
            _detailShareContents = data;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//分享弹框
-(void)shareTasks{
    //弹出分享页
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT -250, self.view.fWidth, 250)];
    redView.backgroundColor = UIColorRBG(246, 246, 246);
    _redView = redView;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(16,16,50,12);
    label.text = @"分享至：";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    label.textColor = UIColorRBG(102, 102, 102);
    [redView addSubview:label];
    //创建微信按钮
    UIButton *WXButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0-87, 67, 50, 50)];
    [WXButton setBackgroundImage:[UIImage imageNamed:@"wewhat"] forState:UIControlStateNormal];
    [WXButton addTarget:self action:@selector(WXShare) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:WXButton];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.frame = CGRectMake(redView.fWidth/2.0-87,126,50,12);
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.text = @"微信好友";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [redView addSubview:labelOne];
    
    
    //创建朋友圈按钮
    UIButton *friendsButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+37, 67, 50, 50)];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"circle-of-friend"] forState:UIControlStateNormal];
    [friendsButton addTarget:self action:@selector(friendsButton) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:friendsButton];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.frame = CGRectMake(redView.fWidth/2.0+37,126,50,12);
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.text = @"朋友圈";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelTwo.textColor =  UIColorRBG(68, 68, 68);
    [redView addSubview:labelTwo];
    
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, redView.fWidth, 1)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [redView addSubview:ineView];
    //创建取消按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 201, redView.fWidth, 49)];
    [cleanButton setTitle:@"取消" forState:UIControlStateNormal];
    [cleanButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    
    [cleanButton addTarget:self action:@selector(closeGkCover) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:cleanButton];
    
}
//分享到微信
-(void)WXShare{
    
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = [_detailShareContents valueForKey:@"name"];
    mediaMsg.description = [_detailShareContents valueForKey:@"outlining"];
    UIImage *image =  [self handleImageWithURLStr:[_detailShareContents valueForKey:@"url"]];
    [mediaMsg setThumbImage:image];
    //分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [_detailShareContents valueForKey:@"shareUrl"];
    mediaMsg.mediaObject = webpageObject;
    
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    req.scene = WXSceneSession;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    
    [self closeGkCover];
    
}
//分享到朋友圈
-(void)friendsButton{
    
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    
    mediaMsg.title = [_detailShareContents valueForKey:@"name"];
    mediaMsg.description = [_detailShareContents valueForKey:@"outlining"];
    
    UIImage *image =  [self handleImageWithURLStr:[_detailShareContents valueForKey:@"url"]];
    [mediaMsg setThumbImage:image];
    
    //2.分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [_detailShareContents valueForKey:@"shareUrl"];
    mediaMsg.mediaObject = webpageObject;
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    req.scene = WXSceneTimeline;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    [self closeGkCover];
    
}
//详情分享
-(void)share{
    [GKCover translucentCoverFrom:self.view content:_redView animated:YES];
}
//关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
//分享图片压缩
- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark -分享
-(void)shares{
    [self hideViews];
    WZShareHouseController *shareVc = [[WZShareHouseController alloc] init];
    shareVc.ID = _ID;
    [self.navigationController pushViewController:shareVc animated:YES];
}

#pragma mark -报备客户
-(void)resport{
    [self hideViews];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [user objectForKey:@"realtorStatus"];
    if ([realtorStatus isEqual:@"2"]){
        WZReportController *report = [[WZReportController alloc] init];
        report.itemID = _ID;
        report.itemName = [_houseDatils valueForKey:@"name"];
        report.types = @"1";
        report.sginStatus = [_houseDatils valueForKey:@"sginStatus"];
        report.telphone = [_houseDatils valueForKey:@"telphone"];
        report.name = @"";
        report.phone = @"";
        [self.navigationController pushViewController:report animated:YES];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"未加入门店" message:@"你还没有加入经纪门店，不能进行更多操作"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不加入" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"加入门店" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   WZJionStoreController *JionStore = [[WZJionStoreController alloc] init];
                                                                   WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
                                                                   JionStore.type = @"1";
                                                                   [self presentViewController:nav animated:YES completion:nil];
                                                               }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadData];
    [self findCoustrom];
    [self findShare];
}
//数据分解
-(NSMutableArray *)setString:(NSArray *)array{
    NSMutableArray *arrays = [NSMutableArray array];
    if (array.count == 0) {
        return arrays;
    }
    for (int i = 0; i<array.count; i++) {
        NSArray *strs = [array[i] componentsSeparatedByString:@"距离："];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"name"] = [strs[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        data[@"distance"] = [NSString stringWithFormat:@"%@m",strs[1]];
        [arrays addObject:data];
    }
    return arrays;
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
