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
#import "UIView+Center.h"
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
#import "WZHouseDetilItem.h"
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
#import "WZShareHouseController.h"
#import "WZLBCollectionViewCell.h"
#import "WZTitleCollectionCell.h"
@interface WZHouseDatisController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,WZCyclePhotoViewClickActionDeleage,UIScrollViewDelegate>
//总view
@property(nonatomic,strong)UIScrollView *scrollView;
//轮播图
@property(nonatomic,strong)UICollectionView *cycleView;
@property(nonatomic,strong)UICollectionView *titleView;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSIndexPath *oldIndexPath;
@property (nonatomic,assign)NSInteger sum;
//底部按钮view
@property(nonatomic,strong)UIView *buttonView;
//导航栏view
@property(nonatomic,strong)UIView *tabView;
@property(nonatomic,strong)UIView *navView;
@property(nonatomic,strong)UIView *ineView;
@property(nonatomic,strong)UILabel *Bartitle;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)UIButton *shareButtons;
@property(nonatomic,strong)UIView *redView;
@property(nonatomic,strong)UIButton *popButton;
//佣金规则
@property(nonatomic,strong)UIView *maidView;
@property(nonatomic,strong)UILabel *maidRule;
@property(nonatomic,assign)CGFloat maidHeight;
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
static NSString * const ID = @"cell";
static NSString * const IDS = @"cells";
@implementation WZHouseDatisController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    _sum = 0;
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
    
    [self loadData];
    
    [self findCoustrom];
    
    [self findShare];
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
    NSArray *pcad = [_houseDatils valueForKey:@"pcad"];
    _titleArray = [WZHouseDetilItem mj_objectArrayWithKeyValuesArray:pcad];
    
    
    [UIView performWithoutAnimation:^{
        //刷新界面
       [_cycleView reloadData];
       [_titleView reloadData];
       NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
       [self.titleView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    }];
    //设置页面张数
    if (pcad.count!=0) {
         [_album setTitle:[NSString stringWithFormat:@"1/%@",[pcad[0] valueForKey:@"pcdNum"]] forState:UIControlStateNormal];
    }
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
    _dView.itemLabel.text = @"";
    _dView.itemLabelTwo.text = @"";
    _dView.itemLabelThree.text = @"";
    NSArray *labelArray = [_houseDatils valueForKey:@"tage"];
    for (int i = 0; i<labelArray.count; i++) {
        if (i == 0) {
             _dView.itemLabel.text = [NSString stringWithFormat:@" %@ ",labelArray[0]];
        } else if(i == 1){
            _dView.itemLabelTwo.text = [NSString stringWithFormat:@" %@ ",labelArray[1]];
        }else if(i == 2){
             _dView.itemLabelThree.text = [NSString stringWithFormat:@" %@ ",labelArray[2]];
        }
    }
    
    if ([realtorStatus isEqual:@"2"]) {
        [_dView.JoinButton setHidden:YES];
        [_dView.JoinButton setEnabled:NO];
        [_dView.Commission setHidden:NO];
        if([commissionFag isEqual:@"0"]){
             _dView.Commission.text = [NSString stringWithFormat:@"佣金：%@",[_houseDatils valueForKey:@"commission"]];
            _reportButton.enabled = YES;
        }else{
            _dView.Commission.text = @"佣金结给门店";
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
        [_dView.Commission setHidden:YES];
        [_dView.JoinButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
         _reportButton.enabled = YES;
        _dView.chargeMan.text = @"加入门店可见电话";
        _dView.phone.text = @"";
    }
    //地址
    _dView.address.text = [_houseDatils valueForKey:@"address"];
    //开发商
    _dView.developerName.text = [_houseDatils valueForKey:@"developer"];
    //公司名称
    _dView.companyName.text = [_houseDatils valueForKey:@"companyName"];

    //佣金规则
    NSString *rule = [_houseDatils valueForKey:@"commissionRule"];
    if ([rule isEqual:@""]||!rule) {
        _maidRule.text = @"佣金结给门店";
    }else{
        _maidRule.text = rule;
    }
    //楼盘动态
//    _dynamic.name = [_houseDatils valueForKey:@"dynamic"];
//    [_dynamic reloadData];
    NSString *dynames = [_houseDatils valueForKey:@"dynamic"];
    if ([dynames isEqual:@""]||!dynames) {
        _dyname.text = @"暂无动态";
    }else{
        _dyname.text = dynames;
    }
    
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
    [self setmaidHeight];
    //楼盘动态高度
    [self setDynamicHeight];
    
    [_reportButton setEnabled:YES];
}
#pragma mark -动态修改佣金规则高度
-(void)setmaidHeight{
    
    CGSize titleSize = [_maidRule.text sizeWithFont:_maidRule.font constrainedToSize:CGSizeMake(_maidRule.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat n = titleSize.height+75;
    if (n == _maidHeight) {
        return;
    }
    _maidHeight = n;
    
    if(n>110){
        _maidView.fHeight += n-110;
        _viewSix.fY +=n-110;
        _dynamicView.fY +=n-110;
        _houseIntroduce.fY += n-110;
        _viewFive.fY +=n-110;
        _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
    }else{
        _maidView.fHeight -= 110-n;
        _viewSix.fY -=110-n;
        _dynamicView.fY -=110-n;
        _houseIntroduce.fY -= 110-n;
        _viewFive.fY -= 110-n;
        _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
    }
}
#pragma mark -动态修改楼盘动态高度
-(void)setDynamicHeight{
    
    CGSize titleSize = [_dyname.text sizeWithFont:_dyname.font constrainedToSize:CGSizeMake(_dyname.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat n = titleSize.height+75;
    if (n == _dynameHeight) {
        return;
    }
    _dynameHeight = n;
    
    if(n>110){
        _dynamicView.fHeight +=n-110;
        _houseIntroduce.fY += n-110;
        _viewFive.fY +=n-110;
        _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
    }else{
        _dynamicView.fHeight -=110-n;
        _houseIntroduce.fY -= 110-n;
        _viewFive.fY -= 110-n;
        _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
    }
}

#pragma mark -设置背景色
-(void)setNavTitle{
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
}
#pragma mark -创建模块
-(void)getUpScreen{
    //下滑view
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
    tabView.backgroundColor = [UIColor whiteColor];
    self.tabView = tabView;
    [self.view addSubview:tabView];
    //创建导航条返回按钮
    [self getUpTabButton];
    
    //创建图片相册按钮
    UIButton *album = [[UIButton alloc] init];
    [album setBackgroundImage:[UIImage imageNamed:@"rounded-rectangle"] forState:UIControlStateNormal];
    [album addTarget:self action:@selector(albums) forControlEvents:UIControlEventTouchUpInside];
    [album setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    album.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    self.album = album;
    [scrollView addSubview:album];
    [album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-85);
        make.top.equalTo(scrollView.mas_top).offset(245);
        make.width.offset(50);
        make.height.offset(18);
    }];
    
    //创建第二个view
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, _cycleView.fHeight-kApplicationStatusBarHeight-24, scrollView.fWidth, 307)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewTwo.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = viewTwo.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    viewTwo.layer.mask = maskLayer;
    [scrollView addSubview:viewTwo];
    WZDetailsViewOne *dView = [WZDetailsViewOne detailViewTwo];
    dView.frame = viewTwo.bounds;
    _dView = dView;
    [viewTwo addSubview:dView];
    //设置收藏按钮的背景
    UIView *collenView = [[UIView alloc] init];
    collenView.backgroundColor = [UIColor whiteColor];
    collenView.layer.cornerRadius = 30.0;
    collenView.layer.shadowColor = [UIColor blackColor].CGColor;
    collenView.layer.shadowOffset = CGSizeMake(0, 1);
    collenView.layer.shadowOpacity = 0.05;
    collenView.layer.shadowRadius = 15;
    [scrollView addSubview:collenView];
    [collenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(viewTwo.mas_top).offset(30);
        make.width.offset(60);
        make.height.offset(60);
    }];
    //创建收藏按钮
    UIButton *likeButton = [[UIButton alloc] init];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"lpxq_icon4"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"lpxq_icon3"] forState:UIControlStateSelected];
    self.likeButton = likeButton;
    [likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setEnlargeEdge:44];
    [collenView addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collenView.mas_centerX);
        make.centerY.equalTo(collenView.mas_centerY);
        make.width.offset(22);
        make.height.offset(20);
    }];
    //结佣时间
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY +viewTwo.fHeight +10, scrollView.fWidth, 55)];
    viewFour.backgroundColor = [UIColor whiteColor];
    //创建第四个view中的控件
    [self getUpFour:viewFour];
    _viewFour = viewFour;
    [scrollView addSubview:viewFour];
    //结佣规则
    UIView *viewMaid = [[UIView alloc] initWithFrame:CGRectMake(0, viewFour.fY+viewFour.fHeight+10, scrollView.fWidth, 110)];
    viewMaid.backgroundColor = [UIColor whiteColor];
    _maidView = viewMaid;
    [self getMaidView:viewMaid];
    [scrollView addSubview:viewMaid];
    
    //主力户型
    UIView *viewSix = [[UIView alloc] initWithFrame:CGRectMake(0, viewMaid.fY +viewMaid.fHeight +10, scrollView.fWidth, 267)];
    viewSix.backgroundColor = [UIColor whiteColor];
    self.viewSix = viewSix;
    //创建第六个模块中的控件
    [self getUpSix:viewSix];
    [scrollView addSubview:viewSix];
    
    //楼盘动态
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewSix.fY +viewSix.fHeight +10, scrollView.fWidth, 110)];
    viewThree.backgroundColor = [UIColor whiteColor];
    _dynamicView = viewThree;
    [self getUpThree:viewThree];
    [scrollView addSubview:viewThree];
    
    //分销流程
    UIView *viewFive = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY +viewThree.fHeight +10, scrollView.fWidth, 323)];
    viewFive.backgroundColor = [UIColor whiteColor];
    self.viewFive = viewFive;
    //创建第五个view中的控件
    [self getUpFive:viewFive];
    [scrollView addSubview:viewFive];
    
    //楼盘简介
    UIView *houseIntroduce = [[UIView alloc] initWithFrame:CGRectMake(0, viewFive.fY +viewFive.fHeight +10, scrollView.fWidth, 208)];
    houseIntroduce.backgroundColor = [UIColor whiteColor];
    _houseIntroduce = houseIntroduce;
    [self houseIntroduce:houseIntroduce];
    [scrollView addSubview:houseIntroduce];
    
    scrollView.contentSize = CGSizeMake(0,houseIntroduce.fY + houseIntroduce.fHeight+10);
}

#pragma mark -图片
-(void)getUpCycle{
    
    UIView *imageView = [[UIView alloc] initWithFrame: CGRectMake(0, -kApplicationStatusBarHeight, SCREEN_WIDTH,317)];
    [_scrollView addSubview:imageView];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(imageView.fWidth, imageView.fHeight);
    layout.minimumLineSpacing = 0;
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView *LBCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, imageView.fWidth, imageView.fHeight) collectionViewLayout:layout];
    LBCV.backgroundColor = [UIColor whiteColor];
    LBCV.showsHorizontalScrollIndicator = NO;//隐藏滚动条
    LBCV.pagingEnabled = YES;
    LBCV.delegate = self;
    LBCV.dataSource = self;
    //注册cell
    [LBCV registerNib:[UINib nibWithNibName:@"WZLBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    self.cycleView = LBCV;
    [imageView addSubview:LBCV];
    //标签
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(14,244, 216, 20)];
    titleView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:titleView];
    
    UICollectionViewFlowLayout * layoutOne = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layoutOne.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layoutOne.itemSize = CGSizeMake(60, 18);
    layoutOne.minimumLineSpacing = 5;
    layoutOne.sectionInset = UIEdgeInsetsMake(1, 9, 1, 9);
    UICollectionView *titleCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, titleView.fWidth, titleView.fHeight) collectionViewLayout:layoutOne];
    titleCollect.showsHorizontalScrollIndicator = NO;//隐藏滚动条
    titleCollect.pagingEnabled = YES;
    titleCollect.delegate = self;
    titleCollect.dataSource = self;
    //注册cell
    [titleCollect registerNib:[UINib nibWithNibName:@"WZTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:IDS];
    titleCollect.backgroundColor = [UIColor clearColor];
    _titleView = titleCollect;
    [titleView addSubview:titleCollect];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (collectionView == _titleView) {
        return 1;
    }
    return self.titleArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==_titleView) {
        if(self.titleArray.count==1){
            return 0;
        }
        return self.titleArray.count;
    }
    WZHouseDetilItem *detilItem = _titleArray[section];
    return detilItem.pcd.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _titleView) {
        WZTitleCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:IDS forIndexPath:indexPath];
        cell.item = self.titleArray[indexPath.row];
        if (indexPath.row == 0) {
            _oldIndexPath = indexPath;
            cell.view.backgroundColor = UIColorRBG(255, 224, 0);
        }
        return cell;
    }
    else{
        WZLBCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        WZHouseDetilItem *item = self.titleArray[indexPath.section];
        WZLunBoItems *items = item.pcd[indexPath.row];
        cell.item = items;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击标题栏上的标题 实现切换效果
    if (collectionView == self.titleView) {
        WZTitleCollectionCell *cell1 = (WZTitleCollectionCell *) [collectionView cellForItemAtIndexPath:_oldIndexPath];
        cell1.view.backgroundColor = [UIColor whiteColor];
        
        WZTitleCollectionCell *cell = (WZTitleCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
        cell.view.backgroundColor = UIColorRBG(255, 224, 0);
        [_album setTitle:[NSString stringWithFormat:@"1/%@",cell.pcdNum] forState:UIControlStateNormal];
        _oldIndexPath = indexPath;
        //滑动被点击的标题 至中心 并设置状态为选中
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        //同时 根据点击的标题的indexPath.row 确定滑动至显示栏对应的section
        NSIndexPath *viewIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
        [self.cycleView scrollToItemAtIndexPath:viewIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
    }else{
        WZLBCollectionViewCell *cell = (WZLBCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        NSString *photoId = cell.ID;
        WZAlbumPhonesViewController *ap = [[WZAlbumPhonesViewController alloc] init];
        ap.type = @"0";
        ap.projectId = _ID;
        ap.photoId = photoId;
        [self.navigationController pushViewController:ap animated:YES];
    }
}
//分页效果
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView != _scrollView) {
        float pageWidth = _cycleView.fWidth; // width + space
        
        float currentOffset = scrollView.contentOffset.x;
        float targetOffset = targetContentOffset->x;
        float newTargetOffset = 0;
        
        if (targetOffset > currentOffset)
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
        else
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
        
        if (newTargetOffset < 0)
            newTargetOffset = 0;
        else if (newTargetOffset > scrollView.contentSize.width)
            newTargetOffset = scrollView.contentSize.width;
        
        targetContentOffset->x = currentOffset;
        
        [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
         NSIndexPath *indexPath = [_cycleView indexPathForItemAtPoint:CGPointMake(newTargetOffset, 0)];
         WZTitleCollectionCell *cell =(WZTitleCollectionCell *) [_titleView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.section inSection:0]];
        
        NSInteger num = newTargetOffset/pageWidth +1;
        if(indexPath.section == 0){
            [_album setTitle:[NSString stringWithFormat:@"%ld/%@",(long)num,cell.pcdNum] forState:UIControlStateNormal];
        }else if(indexPath.section == 1){
             WZTitleCollectionCell *cell2 =(WZTitleCollectionCell *) [_titleView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            num -= [cell2.pcdNum integerValue];
              [_album setTitle:[NSString stringWithFormat:@"%ld/%@",(long)num,cell.pcdNum] forState:UIControlStateNormal];
        }else{
            WZTitleCollectionCell *cell3 =(WZTitleCollectionCell *) [_titleView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            WZTitleCollectionCell *cell4 =(WZTitleCollectionCell *) [_titleView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
            num -= ([cell3.pcdNum integerValue]+[cell4.pcdNum integerValue]);
            [_album setTitle:[NSString stringWithFormat:@"%ld/%@",(long)num,cell.pcdNum] forState:UIControlStateNormal];
        }
        
        
        if (_titleArray.count > 1) {
            WZTitleCollectionCell *cell1 =(WZTitleCollectionCell *) [_titleView cellForItemAtIndexPath:_oldIndexPath];
            cell1.view.backgroundColor = [UIColor whiteColor];
            
            cell.view.backgroundColor = UIColorRBG(255, 224, 0);
            
            _oldIndexPath = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
        }
        
    }
    
}

#pragma mark -设置导航栏按钮
-(void)getUpTabButton{
    //按钮背景图
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha: 0.5];
    buttonView.layer.cornerRadius = 16.0;
    _navView = buttonView;
    [_tabView addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tabView.mas_left).offset(15);
        make.top.equalTo(_tabView.mas_top).offset(kApplicationStatusBarHeight+7);
        make.width.offset(92);
        make.height.offset(33);
    }];
    //创建返回按钮
    UIButton *popButton = [[UIButton alloc] init];
    [popButton setBackgroundImage:[UIImage imageNamed:@"lpxq_more_unfold"] forState:UIControlStateNormal];
    [popButton setEnlargeEdgeWithTop:10 right:18 bottom:10 left:18];
    self.popButton = popButton;
    [popButton addTarget:self action:@selector(black) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:popButton];
    [popButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonView.mas_left).offset(15);
        make.top.equalTo(buttonView.mas_top).offset(7);
        make.width.offset(11);
        make.height.offset(20);
    }];
    
    //创建分享按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"lpxq_share"] forState:UIControlStateNormal];
    self.shareButtons = shareButton;
    [shareButton setEnlargeEdgeWithTop:10 right:18 bottom:10 left:18];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonView.mas_right).offset(-15);
        make.top.equalTo(buttonView.mas_top).offset(8);
        make.width.offset(17);
        make.height.offset(17);
    }];
    
    UIView *ine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.fHeight, self.tabView.fWidth, 1)];
    ine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
    self.ineView = ine;
    [self.tabView addSubview:ine];
    UILabel *title= [[UILabel alloc] init];
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    title.textColor =[UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0];
    title.text = @"楼盘详情页";
    self.Bartitle = title;
    [self.tabView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tabView.mas_centerX);
        make.top.equalTo(self.tabView.mas_top).mas_offset(kApplicationStatusBarHeight+13);
        make.height.offset(17);
        
    }];
}
#pragma mark -状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    if (_offor >= 273) {
        
        return UIStatusBarStyleDefault;
    }
    
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
#pragma mark -导航栏滑动触发事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y - 273;
    _offor = scrollView.contentOffset.y;
     [self setNeedsStatusBarAppearanceUpdate];
    if(self.scrollView.contentOffset.y >= 273){
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.Bartitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        _navView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha: 0.5 - ((64 - offsetY) / 64)];
        [_popButton setBackgroundImage:[UIImage imageNamed:@"lpxq_more_unfold2"] forState:UIControlStateNormal];
        [_shareButtons setBackgroundImage:[UIImage imageNamed:@"lpxq_share2"] forState:UIControlStateNormal];
        
    }else{
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
        self.Bartitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 0];
        _navView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha: 0.5];
        [_popButton setBackgroundImage:[UIImage imageNamed:@"lpxq_more_unfold"] forState:UIControlStateNormal];
        [_shareButtons setBackgroundImage:[UIImage imageNamed:@"lpxq_share"] forState:UIControlStateNormal];
    }
}
#pragma mark -结佣时间
-(void)getUpFour:(UIView *)view{
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"结佣时间：";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    labelTwo.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(16);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(14);
    }];
    UILabel *CommissionTime = [[UILabel alloc] init];
    _settlement = CommissionTime;
    CommissionTime.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    CommissionTime.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:CommissionTime];
    [CommissionTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTwo.mas_right).offset(2);
        make.top.equalTo(view.mas_top).mas_offset(20);
        make.height.offset(14);
    }];
    
}
#pragma mark -佣金规则
-(void)getMaidView:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"佣金规则";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(15);
        make.height.offset(16);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(15);
        make.height.offset(1);
        make.width.offset(view.fWidth-15);
    }];
    //
    UILabel *maidRule = [[UILabel alloc] init];
    _maidRule = maidRule;
    maidRule.numberOfLines = 0;
    maidRule.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    maidRule.textColor =  UIColorRBG(102, 102, 102);
    [view addSubview:maidRule];
    [maidRule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ineView.mas_bottom).mas_offset(15);
        make.width.offset(view.fWidth-30);
    }];
  
}
#pragma mark -主力户型
-(void)getUpSix:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"主力户型";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(15);
        make.height.offset(16);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(14);
        make.height.offset(1);
        make.width.offset(view.fWidth-15);
    }];
    
    UIView *Unit = [[UIView alloc] initWithFrame:CGRectMake(0, 60, view.fWidth, 193)];
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


#pragma mark -楼盘动态
-(void)getUpThree:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"楼盘动态";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(15);
        make.height.offset(16);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(15);
        make.height.offset(1);
        make.width.offset(view.fWidth-15);
    }];
    
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
#pragma mark -楼盘简介
-(void)houseIntroduce:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"楼盘简介";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(15);
        make.height.offset(16);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(15);
        make.height.offset(1);
        make.width.offset(view.fWidth-15);
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
    [button setTitleColor:UIColorRBG(102, 221, 85) forState:UIControlStateNormal];
    [button setTitle:@"查看更多" forState:UIControlStateNormal];
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
#pragma mark -查看更多简介
-(void)MoreContents{
    _contents.numberOfLines = 0;
    
    [self performSelector:@selector(setContentHeight) withObject:self afterDelay:0.01];
}
-(void)setContentHeight{
    CGFloat n = _contents.fHeight-91;
    if (n>0) {
        [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        [_moreButton removeTarget:self action:@selector(MoreContents) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton addTarget:self action:@selector(takeUp) forControlEvents:UIControlEventTouchUpInside];
        _houseIntroduce.fHeight += n;
        _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
    }
}
#pragma mark -收起更多简介
-(void)takeUp{
    _contents.numberOfLines = 5;
    CGFloat n = _contents.fHeight-91;
    if (n>0) {
        [_moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreButton removeTarget:self action:@selector(takeUp) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton addTarget:self action:@selector(MoreContents) forControlEvents:UIControlEventTouchUpInside];
        _houseIntroduce.fHeight -= n;
        _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
    }
}

#pragma mark -分销流程
-(void)getUpFive:(UIView *)view{
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"分销流程";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    labelTitle.textColor =  UIColorRBG(68, 68, 68);
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(view.mas_top).mas_offset(15);
        make.height.offset(16);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).mas_offset(15);
        make.height.offset(1);
        make.width.offset(view.fWidth-15);
    }];
   
    UIButton *buttonOne = [[UIButton alloc] init];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [buttonOne setTitleColor:UIColorRBG(255, 192, 0) forState:UIControlStateNormal];
    buttonOne.layer.borderWidth = 1;
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:10];
    buttonOne.layer.cornerRadius =  7.5;
    buttonOne.layer.borderColor = UIColorRBG(255, 244, 160).CGColor;
    [view addSubview:buttonOne];
    [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ineView.mas_bottom).mas_offset(20);
        make.height.offset(15);
        make.width.offset(15);
    }];
    UILabel *ScLabelOne = [[UILabel alloc] init];
    ScLabelOne.text = @"报备客户";
    ScLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ScLabelOne.textColor =UIColorRBG(102, 102, 102);
    [view addSubview:ScLabelOne];
    [ScLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonOne.mas_right).mas_offset(15);
        make.top.equalTo(ineView.mas_bottom).mas_offset(20);
        make.height.offset(13);
    }];
    UILabel *ScLabelOnes = [[UILabel alloc] init];
    ScLabelOnes.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
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
    [buttonTwo setTitleColor:UIColorRBG(255, 192, 0) forState:UIControlStateNormal];
    buttonTwo.layer.borderWidth = 1;
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:10];
    buttonTwo.layer.cornerRadius =  7.5;
    buttonTwo.layer.borderColor = UIColorRBG(255, 244, 160).CGColor;
    [view addSubview:buttonTwo];
    [buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ScLabelOnes.mas_bottom).mas_offset(20);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //绘制连线
    UIView *buttonViewIneOne = [[UIView alloc] init];
    buttonViewIneOne.backgroundColor = UIColorRBG(255, 244, 160);
    [view addSubview:buttonViewIneOne];
    self.buttonViewIneOne = buttonViewIneOne;
    
    UIView *buttonViewIneTwo = [[UIView alloc] init];
    buttonViewIneTwo.backgroundColor = UIColorRBG(255, 244, 160);
    [view addSubview:buttonViewIneTwo];
    self.buttonViewIneTwo = buttonViewIneTwo;
    UILabel *ScLabelTwo = [[UILabel alloc] init];
    ScLabelTwo.text = @"上客";
    ScLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ScLabelTwo.textColor =UIColorRBG(102, 102, 102);
    [view addSubview:ScLabelTwo];
    [ScLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonTwo.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelOnes.mas_bottom).mas_offset(20);
        make.height.offset(13);
    }];
    UILabel *ScLabelTwos = [[UILabel alloc] init];
    ScLabelTwos.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
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
    [buttonThree setTitleColor:UIColorRBG(255, 192, 0) forState:UIControlStateNormal];
    buttonThree.layer.borderWidth = 1;
    buttonThree.titleLabel.font = [UIFont systemFontOfSize:10];
    buttonThree.layer.cornerRadius =  7.5;
    buttonThree.layer.borderColor = UIColorRBG(255, 244, 160).CGColor;
    [view addSubview:buttonThree];
    [buttonThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).mas_offset(15);
        make.top.equalTo(ScLabelTwos.mas_bottom).mas_offset(20);
        make.height.offset(15);
        make.width.offset(15);
    }];
    UILabel *ScLabelThree = [[UILabel alloc] init];
    ScLabelThree.text = @"成交";
    ScLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ScLabelThree.textColor =UIColorRBG(102, 102, 102);
    [view addSubview:ScLabelThree];
    [ScLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonThree.mas_right).mas_offset(15);
        make.top.equalTo(ScLabelTwos.mas_bottom).mas_offset(20);
        make.height.offset(13);
    }];
    UILabel *ScLabelThrees = [[UILabel alloc] init];
    ScLabelThrees.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
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
#pragma mark -分销流程动态修改模块的y值
-(void)viewDidLayoutSubviews{
    [self.view layoutIfNeeded];
    self.buttonViewIneOne.frame = CGRectMake(self.ScLabelOnes.fX-23, self.ScLabelOnes.fY-12, 1, self.ScLabelOnes.fHeight+32);
    self.buttonViewIneTwo.frame = CGRectMake(self.ScLabelTwos.fX-23, self.ScLabelTwos.fY-12, 1, self.ScLabelTwos.fHeight+32);
    _viewFive.fHeight = _ScLabelThrees.fHeight+_ScLabelThrees.fY + 20;
    _houseIntroduce.fY = _viewFive.fY+_viewFive.fHeight+10;
    _scrollView.contentSize = CGSizeMake(0,_houseIntroduce.fY + _houseIntroduce.fHeight+10);
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
#pragma mark -创建按钮
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
    playPhone.image = [UIImage imageNamed:@"lpxq_icon"];
    [buttonView addSubview:playPhone];

    UILabel *labelP = [[UILabel alloc] init];
    labelP.frame = CGRectMake(29,playPhone.fY+25,25,12);
    labelP.text = @"电话";
    labelP.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelP.textColor = UIColorRBG(49, 35, 6);
    [buttonView addSubview:labelP];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, buttonView.fHeight)];
    _playTelphoneButton = playButton;
    [playButton addTarget:self action:@selector(playPhones) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:playButton];
  
    //创建报备客户按钮
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, buttonView.fWidth-80, buttonView.fHeight)];
    [reportButton setTitle:@"报备客户" forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reportButton.backgroundColor = UIColorRBG(255, 224, 0);
    reportButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [reportButton setEnabled:NO];
    [reportButton addTarget:self action:@selector(resport) forControlEvents:UIControlEventTouchUpInside];
      _reportButton = reportButton;
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
            type.textColor = UIColorRBG(255, 202, 118);
            type.backgroundColor = UIColorRBG(255, 252, 238);
        }else{
            type.text = @" 报备对接人 ";
            type.textColor = UIColorRBG(204, 204, 204);
            type.backgroundColor = UIColorRBG(242, 242, 242);
        }
        type.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        [view addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(name.mas_right).offset(6);
            make.top.equalTo(view.mas_top).offset(50*i+17);
            make.height.offset(16);
        }];
        UIButton *pButton = [[UIButton alloc] init];
        [pButton setBackgroundImage:[UIImage imageNamed:@"lpxq_icon2"] forState:UIControlStateNormal];
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
    }else if([realtorStatus isEqual:@"1"]){
        [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
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
    
    NSString *phone = [_telphoneArray[0] valueForKey:@"linkTelphone"];
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
        [self hideViews];
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
    }else if([realtorStatus isEqual:@"1"]){
        [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
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
        [cancelAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
        [defaultAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hideViews];
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
  
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
