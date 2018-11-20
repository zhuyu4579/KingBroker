//
//  WZGoodHouseController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "WZSlider.h"
#import "WZTypeItem.h"
#import <MJRefresh.h>
#import "WZCityItem.h"
#import "UIView+Frame.h"
#import <MJExtension.h>
#import "DropMenuView.h"
#import <AFNetworking.h>
#import "WZScreenItem.h"
#import <SVProgressHUD.h>
#import "WZTypeTableView.h"
#import "WZCollectionView.h"
#import "WZCollectTableView.h"
#import "NSString+LCExtension.h"
#import "WZCityCollectionCell.h"
#import "NSString+LCExtension.h"
#import <UIImageView+WebCache.h>
#import "WZGoodHouseController.h"
#import "LJCollectionViewFlowLayout.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZGoodHouseTableView.h"
#import "WZFindHouseListItem.h"
#import "WZFindGoodHouseController.h"
@interface WZGoodHouseController ()<DropMenuViewDelegate>{
    //页数
    NSInteger current;
}
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
//列表按钮
@property(nonatomic,weak)UIButton *previousClickButton;

@property(nonatomic,weak)UIButton *previousClickButtonTwo;
//按钮标识
@property(nonatomic,strong)NSString *buttonBype;

@property(nonatomic,weak)UIView *menu;
@property(nonatomic,weak)UIView *city;
@property (nonatomic, strong) DropMenuView *threeLinkageDropMenu;
@property (nonatomic, strong) NSArray *addressArr;

@property(nonatomic,weak)WZSlider *slider;
@property(nonatomic,weak)UIView *cityView;
@property(nonatomic,weak)UIView *priceView;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,weak)UIView *screenView;
@property(nonatomic,strong)UIView *framView;

@property(nonatomic,strong)UIView *viewTable;
//保存数据数组
@property (nonatomic, strong)WZGoodHouseTableView *tableView;
//找楼盘菜单城市数据
@property (nonatomic, strong)NSArray *cityArray;
@property (nonatomic, strong)NSIndexPath *indexPath;
//省ID
@property(nonatomic,strong)NSString *provinceId;
//区域ID
@property(nonatomic,strong)NSString *areaId;
//城市ID
@property(nonatomic,strong)NSString *cityId;
//UUID
@property(nonatomic,strong)NSString *uuid;

//最低价格
@property(nonatomic,strong)NSString *minPrice;
//最高价格
@property(nonatomic,strong)NSString *maxPrice;
//类型的数据模型
@property(nonatomic,strong)NSArray *typeArray;
//类型数据的tableView
@property(nonatomic,strong)WZTypeTableView *typeTable;
//选中类型的view值
@property(nonatomic,strong)NSString *typeValue;
//排序
@property(nonatomic,strong)NSMutableArray *sortArray;
//排序数据
@property(nonatomic,strong)WZTypeTableView *sortTable;
//选中排序的view值
@property(nonatomic,strong)NSString *sortValue;
//楼盘列表数据
@property(nonatomic,strong)NSMutableArray *projectListArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;
//定位坐标
@property(nonatomic,strong)NSString *lnglat;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
@end

static NSString * const ID = @"Citycell";
//查询条数
static NSString *size = @"20";

@implementation WZGoodHouseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    _isRequestFinish = YES;
    _projectListArray = [NSMutableArray array];
    current = 1;
    
    //设置导航栏
    [self setNavigation];
    //无数据
    [self setNoData];
    
    //创建菜单弹框
    [self getUpMenuAlert];
    
    //创建tableview
    [self getUpTableView];
    //读取数据字典
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"dictGroup.plist"];
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    
    for (NSDictionary *obj in result) {
        NSString *code = [obj valueForKey:@"code"];
        //类型
        if ([code isEqual:@"xmlx"]) {
            NSArray *itemArray = [obj valueForKey:@"dicts"];
            _typeArray =  [WZTypeItem mj_objectArrayWithKeyValuesArray:itemArray];
            _typeTable.array = _typeArray;
            _typeTable.type = @"0";
        }
        //特色看房服务
        if ([code isEqual:@"lppx"]) {
            NSArray *itemArray = [obj valueForKey:@"dicts"];
            _sortArray =  [WZTypeItem mj_objectArrayWithKeyValuesArray:itemArray];
            _sortTable.array = _sortArray;
            _sortTable.type = @"1";
        }
    }
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
    header.mj_h = 30;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    _tableView.mj_header = header;
    
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    _tableView.mj_footer = footer;
    
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [_tableView.mj_header beginRefreshing];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
    if(_cityArray.count == 0){
        //获取城市列表
        [self cityDatas];
    }
    
}
-(void)loadMoreTopic{
    
    [_tableView.mj_footer beginRefreshing];
    
    [self loadData];
}
//数据请求
-(void)loadData{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:_uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    
    paraments[@"provinceId"] = _provinceId;
    paraments[@"cityId"] = _cityId;
    paraments[@"areaId"] = _areaId;
    paraments[@"minPrice"] = _minPrice;
    paraments[@"maxPrice"] = _maxPrice;
    paraments[@"type"] = _typeValue;
    paraments[@"proSort"] = _sortValue;
    paraments[@"lableId"] = _ID;
    paraments[@"location"] = _lnglat;
    paraments[@"search"] = @"1";
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    paraments[@"keyword"] = @"";
    
    NSString *url = [NSString stringWithFormat:@"%@/proProject/projectListByLabelIdV2",HTTPURL];
    
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            //字典数组转换成模型数组
            NSDictionary *dacty = [responseObject valueForKey:@"data"];
            NSMutableArray *houseDatas = [dacty valueForKey:@"rows"];
            
            if (houseDatas.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                for (int i=0; i<houseDatas.count; i++) {
                    [_projectListArray addObject:houseDatas[i]];
                }
                current +=1;
                [_tableView.mj_footer endRefreshing];
            }
            if (_projectListArray.count != 0) {
                [_viewNo setHidden:YES];
            }else{
                [_viewNo setHidden:NO];
            }
            
            _tableView.houseItem = [WZFindHouseListItem mj_objectArrayWithKeyValuesArray:_projectListArray];
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            
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
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
        }
        _isRequestFinish = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        _isRequestFinish = YES;
    }];
    
}

#pragma mark -设置导航栏
-(void)setNavigation{
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, kApplicationStatusBarHeight+93)];
    navView.backgroundColor = [UIColor whiteColor];
    
    navView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    navView.layer.shadowOffset = CGSizeMake(0, 1);
    //3.设置阴影颜色的透明度
    navView.layer.shadowOpacity = 0.1;
    //4.设置阴影半径
    navView.layer.shadowRadius = 3;
    [self.view addSubview:navView];
    
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setBackgroundImage:[UIImage imageNamed:@"dh_more_unfold"] forState:UIControlStateNormal];
    [backButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:15];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).offset(15);
        make.top.equalTo(navView.mas_top).offset(kApplicationStatusBarHeight+12);
        make.width.offset(11);
        make.height.offset(20);
    }];
    //搜索按钮
    UIButton *findButton = [[UIButton alloc] init];
    [findButton setBackgroundImage:[UIImage imageNamed:@"search_1"] forState:UIControlStateNormal];
    [findButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:15];
    [findButton addTarget:self action:@selector(findGoodHouse) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:findButton];
    [findButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(navView.mas_right).offset(-15);
        make.top.equalTo(navView.mas_top).offset(kApplicationStatusBarHeight+10);
        make.width.offset(20);
        make.height.offset(21);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.text = _name;
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    title.textColor = UIColorRBG(51, 51, 51);
    [navView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView.mas_centerX);
        make.top.equalTo(navView.mas_top).offset(kApplicationStatusBarHeight+12);
        make.height.offset(18);
    }];
    //设置选择栏
    [self getUpMenu:navView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+93, SCREEN_WIDTH, SCREEN_HEIGHT -93-JF_BOTTOM_SPACE-kApplicationStatusBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    _viewTable = view;
}
#pragma mark -选择栏
-(void)getUpMenu:(UIView *)view{
    
    UIView *menuV = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+44, SCREEN_WIDTH, 49)];
    menuV.backgroundColor = [UIColor whiteColor];
    _menu = menuV;
    [view addSubview:menuV];
    NSArray *titles =@[@"城市 ",@"总价 ",@"类型 ",@"排序 "];
    CGFloat titleViewW = menuV.fWidth / 4;
    CGFloat titleViewH = menuV.fHeight;
    for (int i = 0; i < 4; i++) {
        UIButton *title = [[UIButton alloc] init];
        [title setImage:[UIImage imageNamed:@"lp_icon1"] forState:UIControlStateNormal];
        [title setImage:[UIImage imageNamed:@"lp_icon"] forState:UIControlStateSelected];
        title.frame= CGRectMake(titleViewW*i, 0, titleViewW, titleViewH);
        if (@available(iOS 9.0, *)) {
            title.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft ;
        }
        [title setTitle:titles[i] forState:UIControlStateNormal];
        title.tag = 10 + i;
        title.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        [title setTitleColor:UIColorRBG(119, 119, 119) forState:UIControlStateNormal];
        [title setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateSelected];
        
        [title addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        title.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        [menuV addSubview:title];
        
    }
    for (int i=1; i<4; i++) {
        UIButton *ineOne = [[UIButton alloc] init];
        ineOne.frame = CGRectMake(menuV.fWidth/4*i, 12, 1, 25);
        ineOne.backgroundColor = UIColorRBG(221, 221, 221);
        [menuV addSubview:ineOne];
    }
}
//楼盘列表
-(void)getUpTableView{
    
    WZGoodHouseTableView *tableView = [[WZGoodHouseTableView alloc] initWithFrame:CGRectMake(0,0, _viewTable.fWidth, _viewTable.fHeight)];
    tableView.backgroundColor = [UIColor clearColor];
    _tableView = tableView;
    [_viewTable addSubview:tableView];
    
}
//创建无图表
-(void)setNoData{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, kApplicationStatusBarHeight+93, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-93);
    [view setHidden:NO];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"lp_kIcon"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(120   );
        make.width.offset(181);
        make.height.offset(150);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有任何楼盘哦~";
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
#pragma mark  -菜单弹窗
-(void)getUpMenuAlert{
    UIView *framView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+94, self.view.fWidth, self.view.fHeight - kApplicationStatusBarHeight-94)];
    [self.view addSubview:framView];
    _framView = framView;
    [self getUpCover];
    [self cityMenu];
    [self priceMenu];
    [self typeMenu];
    [self screenMenu];
    [self hideView];
}
#pragma mark -标题按钮点击事件
-(void)titleButtonClick:(UIButton *)button{
    if((button.tag == _previousClickButton.tag)&&[_buttonBype isEqual:@"1"]){
        _buttonBype = @"0";
        [_framView setHidden:YES];
        //取消所有按钮的选择状态
        for (id obj in _menu.subviews) {
            UIButton *but = (UIButton*)obj;
            but.selected = NO;
        }
        return;
    }
    [self hideView];
    
    UIButton *but =(UIButton *) [self.view viewWithTag:(button.tag+10)];
    button.selected = YES;
    but.selected = YES;
    self.previousClickButton = button;
    self.previousClickButtonTwo = but;
    _buttonBype = @"1";
    [_framView setHidden:NO];
    switch (button.tag) {
        case 10:
            [_cityView setHidden:NO];
            break;
        case 11:
            [_priceView setHidden:NO];
            break;
        case 12:
            [_typeView setHidden:NO];
            [self getUpTypeButton:button];
            break;
        case 13:
            [_screenView setHidden:NO];
            [self getUpSortButton:button];
            break;
    }
    
}


-(void)getUpCover{
    //创建遮罩
    UIView *cover = [[UIView alloc] init];
    cover.frame = CGRectMake(0, 0, self.framView.fWidth, self.framView.fHeight);
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
    cover.userInteractionEnabled = YES;
    // 添加遮罩
    [self.framView addSubview:cover];
    
}

-(void)hideView{
    [_framView setHidden:YES];
    [_cityView setHidden:YES];
    [_priceView setHidden:YES];
    [_typeView setHidden:YES];
    [_screenView setHidden:YES];
    //取消所有按钮的选择状态
    for (id obj in _menu.subviews) {
        UIButton *but = (UIButton*)obj;
        but.selected = NO;
    }
    _buttonBype = @"0";
}
#pragma mark -城市菜单
-(void)cityMenu{
    //创建城市view
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _framView.fHeight);
    _cityView = view;
    view.backgroundColor = [UIColor whiteColor];
    [_framView addSubview:view];
    self.threeLinkageDropMenu = [[DropMenuView alloc] init];
    self.threeLinkageDropMenu.delegate = self;
}
//查询城市列表
-(void)cityDatas{
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:_uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/addressLink",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *cityArray = [data valueForKey:@"rows"];
            _addressArr = cityArray;
            
            if (_cityView.subviews>0) {
                [_cityView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
            [self.threeLinkageDropMenu creatDropView:_cityView withShowTableNum:3 withData:self.addressArr];
            [_cityView addSubview:_threeLinkageDropMenu];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - 协议实现
-(void)dropMenuView:(DropMenuView *)view didSelectName:(NSDictionary *)dicty{
    
    if (view == self.threeLinkageDropMenu){
        
        //        [self.threeLinkageButton setTitle:str forState:UIControlStateNormal];
        //        [self buttonEdgeInsets:self.threeLinkageButton];
        _provinceId = [dicty valueForKey:@"provinceId"];
        _cityId = [dicty valueForKey:@"cityId"];
        _areaId = [dicty valueForKey:@"areaId"];
        NSString *areaName = [dicty valueForKey:@"areaName"];
        if ([areaName isEqual:@""]) {
            areaName = @"城市";
        }
        if ([_provinceId isEqual:@"0"]||[_cityId isEqual:@"0"]||![_areaId isEqual:@""]) {
            [self hideView];
            
            if ([areaName isEqual:@""]||[areaName isEqual:@"城市"]) {
                areaName = @"不限";
            }
        }
        if ([_provinceId isEqual:@"0"]) {
            _provinceId = @"";
        }
        if ([_cityId isEqual:@"0"]) {
            _cityId = @"";
        }
        if ([_areaId isEqual:@"0"]) {
            _areaId = @"";
        }
        UIButton *but =  [_menu viewWithTag:10];
        [but setTitle:[NSString stringWithFormat:@"%@ ",areaName] forState:UIControlStateNormal];
        [but setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"lp_icon5"] forState:UIControlStateNormal];
        _projectListArray = [NSMutableArray array];
        current = 1;
        [self loadData];
    }
}

#pragma mark -总价格菜单
-(void)priceMenu{
    //创建城市view
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    _priceView = view;
    [self getUpSumPrice:view];
    view.backgroundColor = [UIColor whiteColor];
    [_framView addSubview:view];
}
#pragma mark -创建总价下拉框
-(void)getUpSumPrice:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 17, 150, 14);
    label.text = @"自定义价格区间(万元)";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    label.textColor = UIColorRBG(102, 102, 102);
    [view addSubview:label];
    WZSlider *slider = [[WZSlider alloc]initWithFrame:CGRectMake(30, 40, view.fWidth-60, 40)];
    slider.minTintColor = UIColorRBG(204, 204, 204);
    slider.maxTintColor = UIColorRBG(204, 204, 204);
    slider.mainTintColor = UIColorRBG(255, 168, 66);
    _slider = slider;
    [view addSubview:slider];
    
    UIButton *cleanButton = [[UIButton alloc] init];
    cleanButton.frame = CGRectMake(0, view.fHeight - 44, 100, 44);
    [cleanButton setTitle:@"清空条件" forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [cleanButton setTitleColor:UIColorRBG(255, 216, 0) forState:UIControlStateNormal];
    cleanButton.backgroundColor = [UIColor blackColor];
    [cleanButton addTarget:self action:@selector(cleanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cleanButton];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100, view.fHeight - 44, view.fWidth-100, 44);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [button setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    button.backgroundColor = UIColorRBG(255, 216, 0);
    [button addTarget:self action:@selector(priceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}
//清空条件
-(void)cleanButtonClick{
    //重置数据
    [_slider removeFromSuperview];
    WZSlider *slider = [[WZSlider alloc]initWithFrame:CGRectMake(30, 40, _priceView.fWidth-60, 40)];
    slider.minTintColor = UIColorRBG(204, 204, 204);
    slider.maxTintColor = UIColorRBG(204, 204, 204);
    slider.mainTintColor = UIColorRBG(244, 197, 79);
    _slider = slider;
    [_priceView addSubview:slider];
    UIButton *but =  [_menu viewWithTag:11];
    [but setTitle:@"总价 " forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"lp_icon1"] forState:UIControlStateNormal];
    [self hideView];
    _minPrice = @"";
    _maxPrice = @"";
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
#pragma mark -点击总价的确认按钮
-(void)priceButtonClick{
    NSString *min = _slider.minLabel.text;
    if ([min isEqual:@"0"]) {
        _minPrice = @"";
    }else{
        _minPrice = min;
    }
    
    NSString *max = _slider.maxLabel.text;
    if ([max isEqual:@"不限"]) {
        _maxPrice = @"";
    }else{
        _maxPrice = max;
    }
    UIButton *but =  [_menu viewWithTag:11];
    [but setTitle:[NSString stringWithFormat:(@"%@-%@ "),min,max] forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"lp_icon5"] forState:UIControlStateNormal];
    [self hideView];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
#pragma mark -类型菜单
-(void)typeMenu{
    //创建城市view
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 294);
    _typeView = view;
    [_framView addSubview:view];
    WZTypeTableView *typeTable = [[WZTypeTableView alloc] init];
    typeTable.frame = CGRectMake(view.fX, view.fY, view.fWidth, view.fHeight - 44);
    _typeTable = typeTable;
    typeTable.backgroundColor = [UIColor clearColor];
    [view addSubview:typeTable];
    view.backgroundColor =UIColorRBG(242, 242, 242);
    
    UIButton *cleanButton = [[UIButton alloc] init];
    cleanButton.frame = CGRectMake(0, view.fHeight - 44, view.fWidth, 44);
    [cleanButton setTitle:@"清空条件" forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [cleanButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    cleanButton.backgroundColor = UIColorRBG(255, 216, 0);
    [cleanButton addTarget:self action:@selector(cleanButtonType) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cleanButton];
    
}
//点击类型按钮回调数据
-(void)getUpTypeButton:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    _typeTable.typeBlock = ^(NSMutableDictionary *typeDic) {
        [button setTitle:[NSString stringWithFormat:@"%@ ",[typeDic valueForKey:@"labels"]] forState:UIControlStateNormal];
        _typeValue = [typeDic valueForKey:@"value"];
        button.selected = NO;
        [button setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"lp_icon5"] forState:UIControlStateNormal];
        _projectListArray = [NSMutableArray array];
        current = 1;
        [weakSelf loadData];
    };
}
//清除类型
-(void)cleanButtonType{
    UIButton *but =  [_menu viewWithTag:12];
    [but setTitle:@"类型 " forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"lp_icon1"] forState:UIControlStateNormal];
    _typeValue = @"";
    [self hideView];
    _typeTable.array = _typeArray;
    [_typeTable reloadData];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
#pragma mark -筛选菜单
-(void)screenMenu{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0 , 0, SCREEN_WIDTH, 151);
    view.backgroundColor =UIColorRBG(245, 245, 245);
    [_framView addSubview:view];
    _screenView = view;
    //创建排序的view
    WZTypeTableView *typeTable = [[WZTypeTableView alloc] init];
    typeTable.frame = view.bounds;
    _sortTable = typeTable;
    typeTable.backgroundColor = [UIColor clearColor];
    [view addSubview:typeTable];
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [typeTable selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
//点击排序按钮回调数据
-(void)getUpSortButton:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    _sortTable.typeBlock = ^(NSMutableDictionary *typeDic) {
        [button setTitle:[NSString stringWithFormat:(@"%@ "),[typeDic valueForKey:@"labels"]] forState:UIControlStateNormal];
        _sortValue = [typeDic valueForKey:@"value"];
        button.selected = NO;
        [button setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"lp_icon5"] forState:UIControlStateNormal];
        _projectListArray = [NSMutableArray array];
        current = 1;
        [weakSelf loadData];
    };
}
#pragma mark -搜索楼盘
-(void)findGoodHouse{
    WZFindGoodHouseController *findHouse = [[WZFindGoodHouseController alloc] init];
    findHouse.ID = _ID;
    [self.navigationController pushViewController:findHouse animated:YES];
}
#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadRefreshs{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    _uuid = uuid;
    _lnglat = [user objectForKey:@"lnglat"];
//    UIButton *but =  [_menu viewWithTag:10];
//    [but setTitle:@"城市" forState:UIControlStateNormal];
//    [but setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
//    [but setImage:[UIImage imageNamed:@"lp_icon1"] forState:UIControlStateNormal];
    _projectListArray = [NSMutableArray array];
    current = 1;
    _isRequestFinish = YES;
    [self loadData];
    //获取城市列表
    [self cityDatas];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadRefreshs];
}
@end
