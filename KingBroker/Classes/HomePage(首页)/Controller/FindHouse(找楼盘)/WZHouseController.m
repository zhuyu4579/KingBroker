//
//  WZHouseController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/3.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHouseController.h"
#import "WZFindHouseTableView.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZSlider.h"
#import "WZCityCollectionCell.h"
#import "NSString+LCExtension.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZCityItem.h"
#import "WZTypeTableView.h"
#import "WZCollectionView.h"
#import "LJCollectionViewFlowLayout.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "WZFindHouseListItem.h"
#import "WZTypeItem.h"
#import "WZScreenItem.h"
#import "NSString+LCExtension.h"
#import "WZCollectTableView.h"

static NSString * const ID = @"Citycell";
@interface WZHouseController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
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
@property(nonatomic,weak)UIView *cityMore;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)WZSlider *slider;
@property(nonatomic,weak)UIView *cityView;
@property(nonatomic,weak)UIView *priceView;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,weak)UIView *screenView;
@property(nonatomic,strong)UIView *framView;

@property(nonatomic,strong)UIView *viewTable;
//找楼盘菜单城市数据
@property (nonatomic, strong)NSArray *cityArray;
@property (nonatomic, strong)NSIndexPath *indexPath;
//保存数据数组
@property (nonatomic, strong)WZFindHouseTableView *tableView;
//保存数据数组
@property (nonatomic, strong)WZCollectTableView *tableViewC;
//城市ID
@property(nonatomic,strong)NSString *cityId;
//UUID
@property(nonatomic,strong)NSString *uuid;
//搜索城市ID
@property(nonatomic,strong)NSString *seachCityId;
//更多
@property(nonatomic,strong)WZCollectionView *colles;
//更多箭头
@property(nonatomic,strong)UIButton *collButton;
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
//筛选数组
@property(nonatomic,strong)NSMutableArray *SXArray;
//筛选中的户型
@property(nonatomic,strong)NSArray *room;
//楼盘特色
@property(nonatomic,strong)NSArray *buildingFeature;
//楼盘装修
@property(nonatomic,strong)NSArray *buildingRenovation;
//面积
@property(nonatomic,strong)NSArray *area;
//项目列表数据
@property(nonatomic,strong)NSMutableArray *projectListArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;
//定位坐标
@property(nonatomic,strong)NSString *lnglat;
@end
//查询条数
static NSString *size = @"20";

@implementation WZHouseController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];

    _projectListArray = [NSMutableArray array];
    current = 1;
    [super viewDidLoad];
    [self setNoData];
    [self setNarItem];
    
    //创建tableview
    [self getUpTableView];
   
     //遍历数组
      NSMutableArray *screenArray = [NSMutableArray array];
     _SXArray = screenArray;
    //创建菜单弹框
    [self getUpMenuAlert];
  
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
        }
        //特色看房服务
        if ([code isEqual:@"lpzx"]||[code isEqual:@"lpts"]||[code isEqual: @"hxshi"]||[code isEqual:@"hxmj"]) {
            WZScreenItem *item = [[WZScreenItem alloc] init];
            item.code = [obj valueForKey:@"code"];
            item.name = [obj valueForKey:@"name"];
            item.dicts = [SubCategoryModel mj_objectArrayWithKeyValuesArray:[obj valueForKey:@"dicts"]];
            [screenArray addObject:item];
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
    _tableViewC.mj_header = header;
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    _tableView.mj_footer = footer;
    _tableViewC.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
 
 [_tableView.mj_header beginRefreshing];
 [_tableViewC.mj_header beginRefreshing];
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
    [_tableViewC.mj_footer beginRefreshing];
    [self loadData];
}
//数据请求
-(void)loadData{

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
        if ((!_seachCityId||[_seachCityId isEqual:@""])&&[_type isEqual:@"0"]) {
             paraments[@"cityId"] = _cityId;
        }
        paraments[@"seachCityId"] = _seachCityId;
        paraments[@"minPrice"] = _minPrice;
        paraments[@"maxPrice"] = _maxPrice;
        paraments[@"type"] = _typeValue;
        paraments[@"room"] = _room;
        paraments[@"area"] = _area;
        paraments[@"buildingFeature"] = _buildingFeature;
        paraments[@"buildingRenovation"] = _buildingRenovation;
        paraments[@"location"] = _lnglat;
        paraments[@"current"] = [NSString stringWithFormat:@"%zd",current];
        paraments[@"size"] = size;
      
        NSString *url = [NSString stringWithFormat:@"%@/proProject/projectList",URL];
        if ([_type isEqual:@"1"]) {
            url =  [NSString stringWithFormat:@"%@/proProject/collectProList",URL];
        }
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            
            if ([code isEqual:@"200"]) {
                //字典数组转换成模型数组
                NSDictionary *dacty = [responseObject valueForKey:@"data"];
                NSMutableArray *houseDatas = [dacty valueForKey:@"rows"];
               
                if (houseDatas.count == 0) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    [_tableViewC.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (int i=0; i<houseDatas.count; i++) {
                        [_projectListArray addObject:houseDatas[i]];
                    }
                    current +=1;
                    [_tableView.mj_footer endRefreshing];
                    [_tableViewC.mj_footer endRefreshing];
                }
                if (_projectListArray.count != 0) {
                    [_viewNo setHidden:YES];
                }else{
                    [_viewNo setHidden:NO];
                }
                 
                if ([_type isEqual:@"0"]) {
                    _tableView.houseItem = [WZFindHouseListItem mj_objectArrayWithKeyValuesArray:_projectListArray];
                    [_tableView reloadData];
                    [_tableView.mj_header endRefreshing];
                }else{
                    _tableViewC.houseItem = [WZFindHouseListItem mj_objectArrayWithKeyValuesArray:_projectListArray];
                    [_tableViewC reloadData];
                    [_tableViewC.mj_header endRefreshing];
                }
               
            }else{
                
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
                if ([_type isEqual:@"0"]) {
                    [_tableView.mj_header endRefreshing];
                    [_tableView.mj_footer endRefreshing];
                }else{
                    [_tableViewC.mj_header endRefreshing];
                    [_tableViewC.mj_footer endRefreshing];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            if ([_type isEqual:@"0"]) {
                [_tableView.mj_header endRefreshing];
                 [_tableView.mj_footer endRefreshing];
            }else{
                 [_tableViewC.mj_header endRefreshing];
                 [_tableViewC.mj_footer endRefreshing];
            }
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
    label.text = @"还没有任何项目哦~";
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
#pragma mark -设置导航栏
-(void)setNarItem{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    //创建菜单
    [self getUpMenu];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _menu.fY+_menu.fHeight+1, SCREEN_WIDTH, SCREEN_HEIGHT - _menu.fY-_menu.fHeight-1)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    _viewTable = view;
}
-(void)getUpMenu{
    UIView *menuV = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, SCREEN_WIDTH, 44)];
    menuV.backgroundColor = [UIColor whiteColor];
    _menu = menuV;
    [self.view addSubview:menuV];
    NSArray *titles =@[@"城市",@"总价",@"类型",@"筛选"];
    
    CGFloat titleViewW = menuV.fWidth / 4;
    CGFloat titleViewH = menuV.fHeight;
    for (int i = 0; i < 4; i++) {
        
        UIButton *title = [[UIButton alloc] init];
        if (i == 0) {
            title.frame= CGRectMake(10+titleViewW*i, 0, 45, titleViewH);
        }else{
            title.frame= CGRectMake(20+titleViewW*i, 0, 45, titleViewH);
        }
        
        [title setTitle:titles[i] forState:UIControlStateNormal];
        title.tag = 10 + i;
        [title setEnlargeEdge:40];
        title.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [title setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
        [title setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
        [title addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         title.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
        [menuV addSubview:title];
       
        UIButton *titleButton = [[UIButton alloc] init];
        
        titleButton.frame= CGRectMake(title.fX+title.fWidth+5, 20, 10, 6);
        [titleButton setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
        [titleButton setBackgroundImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateSelected];
        titleButton.tag = i + 20;
        [menuV addSubview:titleButton];
    }
}
//项目列表
-(void)getUpTableView{

    if ([_type isEqual:@"0"]) {
        WZFindHouseTableView *tableView = [[WZFindHouseTableView alloc] initWithFrame:CGRectMake(0,0, _viewTable.fWidth, _viewTable.fHeight)];
        tableView.backgroundColor = [UIColor clearColor];
        _tableView = tableView;
        [_viewTable addSubview:tableView];
    }else{
        WZCollectTableView *tableView = [[WZCollectTableView alloc] initWithFrame:CGRectMake(0,0, _viewTable.fWidth, _viewTable.fHeight)];
        tableView.backgroundColor = [UIColor clearColor];
        _tableViewC = tableView;
        [_viewTable addSubview:tableView];
    }
}
-(void)getUpMenuAlert{
    UIView *framView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, self.view.fWidth, self.view.fHeight - 110)];
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
            [_cityMore setHidden:NO];
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
    [_cityMore setHidden:YES];
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
    UIView *viewMore = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
     _cityView = view;
    viewMore.frame = CGRectMake(0, 120, SCREEN_WIDTH, 30);
    viewMore.backgroundColor = [UIColor whiteColor];
    [_framView addSubview:viewMore];
    [self getUpMoreButton:viewMore];
    [self getUpCityItem:view];
    _city = view;
    _cityMore = viewMore;
    view.backgroundColor = [UIColor whiteColor];
    [_framView addSubview:view];
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
        NSString *url = @"";
        if ([_type isEqual:@"0"]) {
             paraments[@"location"] = _lnglat;
             url = [NSString stringWithFormat:@"%@/proProject/cityList",URL];
        }else{
             url =  [NSString stringWithFormat:@"%@/proProject/collectCityList",URL];
        }
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *cityArray = [data valueForKey:@"rows"];
                _cityArray = [WZCityItem mj_objectArrayWithKeyValuesArray:cityArray];
                [_collectionView reloadData];
             
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
}

#pragma mark -创建城市列表
-(void)getUpCityItem:(UIView *)view{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 5;
    //layout.estimatedItemSize = CGSizeMake(80, 25);
    layout.itemSize = CGSizeMake(110, 30);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(view.fX, view.fY, view.fWidth, view.fHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    //禁止滑动
    collectionView.scrollEnabled = NO;
    [view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"WZCityCollectionCell" bundle:nil] forCellWithReuseIdentifier:ID];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cityArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZCityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.cityButton.textColor = [UIColor whiteColor];
        cell.cityButton.backgroundColor = UIColorRBG(3, 133, 219);
        _indexPath = indexPath;
    }
    WZCityItem *item = self.cityArray[indexPath.row];
    cell.item = item;
    return cell;
}
#pragma mark -点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WZCityCollectionCell *cell1 =(WZCityCollectionCell *) [collectionView cellForItemAtIndexPath:_indexPath];
    cell1.cityButton.textColor = UIColorRBG(102, 102, 102);
    cell1.cityButton.backgroundColor = UIColorRBG(242, 242, 242);
    
    WZCityCollectionCell *cell =(WZCityCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    cell.cityButton.textColor = [UIColor whiteColor];
    cell.cityButton.backgroundColor = UIColorRBG(3, 133, 219);
    UIButton *but =  [_menu viewWithTag:10];
    [but setTitle:cell.cityButton.text forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    UIButton *but1 =  [_menu viewWithTag:20];
    [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_3"] forState:UIControlStateNormal];
    [self hideView];
    _seachCityId = cell.cityId;
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
#pragma mark -创建城市更多按钮
-(void)getUpMoreButton:(UIView *)view{
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(view.fWidth/2-20, 2, 26, 15)];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton setEnlargeEdgeWithTop:5 right:view.fWidth/2 bottom:5 left:view.fWidth/2];
    [moreButton setTitleColor:UIColorRBG(204, 204, 204) forState:UIControlStateNormal];
    [moreButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
    moreButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [moreButton addTarget:self action:@selector(moreCity:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreButton];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(moreButton.fX+moreButton.fWidth+8, 6, 12, 7)];
    [button setBackgroundImage:[UIImage imageNamed:@"more_unfold-1"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"more_unfold-(3)"] forState:UIControlStateSelected];
    _collButton = button;
    moreButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [view addSubview:button];
}
#pragma mark -点击更多城市按钮
-(void)moreCity:(UIButton *)button{
    button.selected = !button.selected;
    _collButton.selected = !_collButton.selected;
    if (button.selected) {
        _city.fHeight += 120;
        _cityMore.fY +=120;
        _collectionView.scrollEnabled = YES;
        _collectionView.fHeight +=120;
    }else{
        _city.fHeight -= 120;
        _cityMore.fY -=120;
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        _collectionView.scrollEnabled = NO;
        _collectionView.fHeight -=120;
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
    WZSlider *slider = [[WZSlider alloc]initWithFrame:CGRectMake((view.fWidth -300)/2, 40, 300, 40)];
    slider.minTintColor = UIColorRBG(204, 204, 204);
    slider.maxTintColor = UIColorRBG(204, 204, 204);
    slider.mainTintColor = UIColorRBG(3, 133, 219);
    _slider = slider;
    [view addSubview:slider];
    
    UIButton *cleanButton = [[UIButton alloc] init];
    cleanButton.frame = CGRectMake(0, view.fHeight - 44, 100, 44);
    [cleanButton setTitle:@"清空条件" forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [cleanButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    cleanButton.layer.borderColor = UIColorRBG(242, 242, 242).CGColor;
    cleanButton.layer.borderWidth = 1.0;
    [cleanButton addTarget:self action:@selector(cleanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cleanButton];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100, view.fHeight - 44, view.fWidth-100, 44);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    [button addTarget:self action:@selector(priceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
}
//清空条件
-(void)cleanButtonClick{
    //重置数据
    [_slider removeFromSuperview];
    WZSlider *slider = [[WZSlider alloc]initWithFrame:CGRectMake((_priceView.fWidth -300)/2, 40, 300, 40)];
    slider.minTintColor = UIColorRBG(204, 204, 204);
    slider.maxTintColor = UIColorRBG(204, 204, 204);
    slider.mainTintColor = UIColorRBG(3, 133, 219);
    _slider = slider;
    [_priceView addSubview:slider];
    UIButton *but =  [_menu viewWithTag:11];
    [but setTitle:@"总价" forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    UIButton *but1 =  [_menu viewWithTag:21];
    [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
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
    [but setTitle:[NSString stringWithFormat:(@"%@-%@"),min,max] forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    UIButton *but1 =  [_menu viewWithTag:21];
    [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_3"] forState:UIControlStateNormal];
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
    cleanButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [cleanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cleanButton.backgroundColor = UIColorRBG(3, 133, 219);
    [cleanButton addTarget:self action:@selector(cleanButtonType) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cleanButton];
   
}
//点击类型按钮回调数据
-(void)getUpTypeButton:(UIButton *)button{
    __weak typeof(self) weakSelf = self;
    UIButton *but1 =  [self.menu viewWithTag:22];
    _typeTable.typeBlock = ^(NSMutableDictionary *typeDic) {
         [button setTitle:[NSString stringWithFormat:(@"%@"),[typeDic valueForKey:@"labels"]] forState:UIControlStateNormal];
         _typeValue = [typeDic valueForKey:@"value"];
        [button setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
        [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_3"] forState:UIControlStateNormal];
        but1.selected = NO;
        _projectListArray = [NSMutableArray array];
        current = 1;
        [weakSelf loadData];
    };
}
//清除类型
-(void)cleanButtonType{
    UIButton *but =  [_menu viewWithTag:12];
    [but setTitle:@"类型" forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    UIButton *but1 =  [_menu viewWithTag:22];
    [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
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
    view.frame = CGRectMake(SCREEN_WIDTH - 360, 0, 360, _framView.fHeight);
    view.backgroundColor =UIColorRBG(242, 242, 242);
    [_framView addSubview:view];
      _screenView = view;
    //创建多选的view
    UIView *screenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, view.fHeight -41)];
    screenView.backgroundColor = [UIColor whiteColor];
    WZCollectionView *coll = [[WZCollectionView alloc] initWithFrame:screenView.bounds collectionViewLayout:self.flowLayout];
     coll.screenArray = _SXArray;
    [coll reloadData];
    _colles = coll;
    [screenView addSubview:coll];
    [view addSubview:screenView];
    //创建按钮的view
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, screenView.fHeight+1, view.fWidth, 40)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [view addSubview:buttonView];
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonView.fWidth/2, buttonView.fHeight)];
    [cleanButton setTitle:@"清空条件" forState:UIControlStateNormal];
    [cleanButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [cleanButton addTarget:self action:@selector(cleanMore) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:cleanButton];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonView.fWidth/2, 0, buttonView.fWidth/2, buttonView.fHeight)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    [button addTarget:self action:@selector(buttonCilck) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button];
    
    _colles.selectBlock = ^(NSMutableDictionary *dicty) {
        _room = [dicty valueForKey:@"hxshi"];
        _buildingFeature = [dicty valueForKey:@"lpts"];
        _buildingRenovation = [dicty valueForKey:@"lpzx"];
        _area = [dicty valueForKey:@"hxmj"];
       
    };
}
- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.sectionInset = UIEdgeInsetsMake(20, 15 ,20,15);
         _flowLayout.minimumLineSpacing = 20;
         _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(100, 25);
    }
    return _flowLayout;
}
//更多中清除条件
-(void)cleanMore{
    [_colles clean];
    UIButton *button =  [_menu viewWithTag:13];
    [button setTitle:@"筛选" forState: UIControlStateNormal];
    [button setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    UIButton *button1 =  [_menu viewWithTag:23];
    [button1 setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
    [self hideView];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//更多确认选择
-(void)buttonCilck{
    UIButton *but =  [_menu viewWithTag:13];
    [but setTitle:[NSString stringWithFormat:(@"多选")] forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    UIButton *but1 =  [_menu viewWithTag:23];
    [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_3"] forState:UIControlStateNormal];
    [self hideView];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    _uuid = uuid;
    NSString *cityId = [ user objectForKey:@"cityId"];
    _cityId = cityId;
    _lnglat = [user objectForKey:@"lnglat"];
    UIButton *but =  [_menu viewWithTag:10];
    [but setTitle:@"城市" forState:UIControlStateNormal];
    [but setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    UIButton *but1 =  [_menu viewWithTag:20];
    [but1 setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
    _seachCityId = @"";
    _projectListArray = [NSMutableArray array];
    current = 1;
    //获取城市列表
    [self cityDatas];
    //数据请求
    [self loadData];
}
@end
