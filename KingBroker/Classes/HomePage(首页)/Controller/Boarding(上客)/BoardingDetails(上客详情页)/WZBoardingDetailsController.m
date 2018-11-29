//
//  WZBoardingDetailsController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZBoardingDetailsController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "GKCover.h"
#import "WZNewReportController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZVoucherDealController.h"
#import "WZVoucherBoardingController.h"
#import <UIImageView+WebCache.h>
#import "NSString+LCExtension.h"
#import "WZHouseDatisController.h"
#import "UIBarButtonItem+Item.h"
@interface WZBoardingDetailsController ()<UIScrollViewDelegate>
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)UIView *viewOne;
@property (nonatomic,weak)UILabel *name;
@property (nonatomic,weak)UILabel *telephone;
@property (nonatomic,weak)UILabel *ItemName;
@property (nonatomic,weak)UILabel *houseType;
@property (nonatomic,weak)UIView *ineView;
@property (nonatomic,weak)UIButton *telephoneButton;
@property (nonatomic,weak)NSString *codeimage;
//二维码按钮
@property (nonatomic,weak)UIButton *codeButton;
//分割线
@property (nonatomic,weak)UIView *codeIne;
//打电话按钮
@property (nonatomic,weak)UIButton *playTelphoneButton;
//项目按钮
@property (nonatomic,weak)UIButton *ItemButton;
//view2
@property (nonatomic,weak)UIView *viewTwo;
@property (nonatomic,weak)UIView *ineViewFour;
@property (nonatomic,weak)UIView *ineViewFive;
@property (nonatomic,weak)UIView *viewThree;
//记录
@property (nonatomic,weak)UILabel *stateTitle1;
@property (nonatomic,weak)UILabel *stateTitle2;
@property (nonatomic,weak)UILabel *stateTitle3;
@property (nonatomic,weak)UIImageView *imageView1;
@property (nonatomic,weak)UIImageView *imageView2;
@property (nonatomic,weak)UIImageView *imageView3;
@property (nonatomic,weak)UIView *imageIneOne;
@property (nonatomic,weak)UIView *imageIneTwo;
@property (nonatomic,weak)UILabel *recordTime;
@property (nonatomic,weak)UILabel *state;
@property (nonatomic,weak)UILabel *stateDescribe;
//viw3
@property (nonatomic,strong)NSString *boaringTimeLabel;
@property (nonatomic,strong)UILabel *ciryLabel;
@property (nonatomic,strong)UILabel *popelSumLable;
@property (nonatomic,strong)UILabel *modeLable;
@property (nonatomic,strong)UILabel *provideLunchLable;
@property (nonatomic,strong)UILabel *carCord;
//按钮
@property(nonatomic,strong)UIButton *boardingButton;
@property(nonatomic,strong)UIButton *comButton;
//订单记录
@property (nonatomic,strong)NSArray *list;
//其他数据
@property (nonatomic,strong)NSDictionary *order;
//二维码
@property (nonatomic,strong)UIImageView *codeImage;
@property (nonatomic,strong)UIView *codeView;
@property (nonatomic,weak)UILabel *names;
@property (nonatomic,weak)UILabel *telephones;
@property (nonatomic,weak)UILabel *ItemNames;
@property (nonatomic,weak)UILabel *titles;

//订单详情的条数
@property (nonatomic,assign) NSInteger n;
//预计上客时间
@property (nonatomic,weak)UILabel *label1;
//楼盘ID
@property(nonatomic,strong)NSString *itemId;
//楼盘签约状态
@property(nonatomic,strong)NSString *sginStatus;
//楼盘电话
@property(nonatomic,strong)NSString *proTelphone;
//报备手机号 是否为实号
@property(nonatomic,strong)NSString *orderTelFlag;
@end

@implementation WZBoardingDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条
    [self setNarItems];
    //创建模块控件
    [self setupController];
    //数据请求
    [self loadData];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
}
//请求数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"orderId"] = _ID;
    
    NSString *url = [NSString stringWithFormat:@"%@/order/detail",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSMutableDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *list = [data valueForKey:@"list"];
            _list = list;
            NSDictionary *order = [data valueForKey:@"order"];
            _order = order;
            //二维码
            NSString *url = [data valueForKey:@"url"];
            if (url) {
                [_codeImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"OR-code_2"]];
            }
            //设置参数
            [self setValueData];
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
//设置参数
-(void)setValueData{
    _sginStatus = [_order valueForKey:@"sginStatus"];
    _orderTelFlag  = [_order valueForKey:@"orderTelFlag"];
    _proTelphone = [_order valueForKey:@"proTelphone"];
    //客户姓名
    _name.text = [_order valueForKey:@"clientName"];
    _names.text = [_order valueForKey:@"clientName"];
    //客户电话
    _telephone.text = [_order valueForKey:@"missContacto"];
    _telephones.text = [_order valueForKey:@"missContacto"];
    NSString *status = [_order valueForKey:@"dealStatus"];
    //楼盘名
    _ItemName.text = [_order valueForKey:@"projectName"];
    _ItemNames.text = [_order valueForKey:@"projectName"];
    //楼盘ID
    _itemId = [_order valueForKey:@"projectId"];
    //设置按钮
    NSString *verify = [_order valueForKey:@"verify"];
    NSString *selfEmployed = [_order valueForKey:@"selfEmployed"];
    [_boardingButton setHidden:YES];
    [_boardingButton setEnabled:NO];
    //NSString *selfEmployed = @"2";
    if ([selfEmployed isEqual:@"2"]) {
        [_houseType setHidden:NO];
    } else {
        [_houseType setHidden:YES];
        
        [_ItemName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewOne.mas_left).with.offset(15);
        }];
    }
    _imageView1.backgroundColor = [UIColor whiteColor];
    _stateTitle1.textColor = UIColorRBG(153, 153, 153);
    _imageView2.backgroundColor = [UIColor whiteColor];
    _stateTitle2.textColor = UIColorRBG(153, 153, 153);
    _imageView3.backgroundColor = [UIColor whiteColor];
    _stateTitle3.textColor = UIColorRBG(153, 153, 153);

    //订单状态
    NSInteger statu = [status integerValue];
    NSInteger ver = [verify integerValue];
    if (statu == 1) {
        if (ver == 3) {
            _imageView1.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle1.textColor = UIColorRBG(49, 35, 6);
            _codeButton.enabled = YES;
            [_codeButton setHidden:NO];
            if ([_orderTelFlag isEqual:@"1"]) {
                [_codeIne setHidden:NO];
            }
            if ([selfEmployed isEqual:@"2"]) {
                [_boardingButton setHidden:NO];
                [_boardingButton setEnabled:YES];
                [_comButton mas_updateConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.view.mas_left).offset(self.view.fWidth/2.0);
                }];
               [_comButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                [_comButton addTarget:self action:@selector(voucherBoarding) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    } else if (statu == 2){
        _imageView1.backgroundColor = UIColorRBG(255, 224, 0);
        _stateTitle1.textColor = UIColorRBG(49, 35, 6);
        _imageView2.backgroundColor = UIColorRBG(255, 224, 0);
        _stateTitle2.textColor = UIColorRBG(49, 35, 6);
        _codeButton.enabled = NO;
        [_codeButton setHidden:YES];
        if (ver == 2) {
            [_boardingButton setHidden:YES];
            [_boardingButton setEnabled:NO];
            [_comButton setHidden:YES];
            [_comButton setEnabled:NO];
            _scrollView.fHeight = self.view.fHeight;
        }else if(ver == 3){
            [_comButton setHidden:NO];
            [_comButton setEnabled:YES];
            [_comButton setTitle:@"发起成交" forState: UIControlStateNormal];
             [_comButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            if ([selfEmployed isEqual:@"2"]) {
                [_comButton addTarget:self action:@selector(voucherDealCilck) forControlEvents:UIControlEventTouchUpInside];
            } else {
                
                [_comButton addTarget:self action:@selector(LaunchDealCilck) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    } else if (statu == 3){
        if (ver == 2) {
            _imageView1.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle1.textColor = UIColorRBG(49, 35, 6);
            _imageView2.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle2.textColor = UIColorRBG(49, 35, 6);
            _codeButton.enabled = NO;
            [_codeButton setHidden:YES];
            _comButton.enabled = NO;
            _comButton.backgroundColor = UIColorRBG(158, 158, 158);
            [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_comButton setTitle:@"成交审核中" forState:UIControlStateNormal];
        }else if(ver == 3){
            _imageView1.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle1.textColor = UIColorRBG(49, 35, 6);
            _imageView2.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle2.textColor = UIColorRBG(49, 35, 6);
            _imageView3.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle3.textColor = UIColorRBG(49, 35, 6);
            _comButton.enabled = NO;
            _comButton.hidden = YES;
            _scrollView.fHeight = self.view.fHeight;
            
        }else if([verify isEqual:@"4"]){
            _imageView1.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle1.textColor = UIColorRBG(49, 35, 6);
            _imageView2.backgroundColor = UIColorRBG(255, 224, 0);
            _stateTitle2.textColor = UIColorRBG(49, 35, 6);
            _imageView3.backgroundColor = [UIColor whiteColor];
            _stateTitle3.textColor = UIColorRBG(153, 153, 153);
            _comButton.backgroundColor = UIColorRBG(255, 224, 0);
           
            [_comButton setHidden:NO];
            [_comButton setEnabled:YES];
            [_comButton setTitle:@"发起成交" forState: UIControlStateNormal];
             [_comButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            if ([selfEmployed isEqual:@"2"]) {
                [_comButton addTarget:self action:@selector(voucherDealCilck) forControlEvents:UIControlEventTouchUpInside];
            } else {
                
                [_comButton addTarget:self action:@selector(LaunchDealCilck) forControlEvents:UIControlEventTouchUpInside];
            }
            
           
        }
        
    } else if (statu == 4){
        [_comButton setHidden:NO];
        [_comButton setEnabled:YES];
        [_comButton setTitle:@"重新报备" forState: UIControlStateNormal];
        [_comButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [_comButton addTarget:self action:@selector(NewReportCilck) forControlEvents:UIControlEventTouchUpInside];
    }
   
    //设置条数
    _n = _list.count;
    //删除所有子控件
    [[_viewTwo viewWithTag:80] removeFromSuperview];
    _viewTwo.fHeight = 106;
    _ineViewFive.fHeight = 0;
    _viewTwo.fHeight += _n*79;
    _ineViewFive.fHeight += 79*(_n-1);
    _viewThree.fY = 141+_viewTwo.fHeight+10;
    if ((_viewThree.fY+192)>(self.view.fHeight-93)) {
         _scrollView.contentSize = CGSizeMake(0, _viewThree.fY+192);
    }
    //根据数据条数绘制记录
    UIView *view = [[UIView alloc] init];
    view.frame = _viewTwo.bounds;
    view.tag = 80;
    [_viewTwo addSubview:view];
    NSArray *stateArray = @[@"已报备",@"上客审核中", @"已上客", @"发起成交"    ,@"已成交",@"成交审核未通过",@"已失效"];
    for (int i = 0; i < _n; i++) {
        //绘制记录时间
        UILabel *recordTime = [[UILabel alloc] init];
        recordTime.text = [[_list[i] valueForKey:@"time"] substringFromIndex:5];
        recordTime.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
        recordTime.textColor = UIColorRBG(153, 153, 153);
        [view addSubview:recordTime];
        self.recordTime = recordTime;
        [recordTime setNumberOfLines:0];
        [recordTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTwo.mas_left).with.offset(15);
            make.top.equalTo(_ineViewFour.mas_bottom).with.offset(23+79*(i));
            make.width.mas_offset(40);
        }];
        UIImageView *imagePoint = [[UIImageView alloc] init];
        imagePoint.backgroundColor = UIColorRBG(255, 244, 160);
        imagePoint.layer.masksToBounds =YES;
        imagePoint.layer.cornerRadius = 10.0/2;
        [view addSubview:imagePoint];
        [imagePoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTwo.mas_left).with.offset(76);
            make.top.equalTo(_ineViewFour.mas_bottom).with.offset(25+79*i);
            make.width.mas_offset(10);
            make.height.mas_offset(10);
        }];
      
        NSString *state1 = [_list[i] valueForKey:@"dealStatus"];
        NSString *verify = [_list[i] valueForKey:@"verify"];
        int states = [state1 intValue];
        int verifys = [verify intValue];
        
        UILabel *state = [[UILabel alloc] init];
        if(states == 1){
            if (verifys == 3) {
                state.text = stateArray[0];
            }
        }else if (states == 2){
             if (verifys == 2) {
                state.text = stateArray[1];
            }else if(verifys == 3){
                state.text = stateArray[2];
            }
        }else if (states == 3){
            if (verifys == 2) {
                state.text = stateArray[3];
            }else if(verifys == 3){
                state.text = stateArray[4];
            }else if(verifys == 4){
                state.text = stateArray[5];
            }
        }else if(states == 4){
            state.text = stateArray[6];
        }
        state.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        state.textColor = UIColorRBG(49, 35, 6);
        [view addSubview:state];
        self.state = state;
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imagePoint.mas_right).with.offset(7);
            make.top.equalTo(_ineViewFour.mas_bottom).with.offset(24+79*i);
            make.height.mas_offset(13);
        }];
        UILabel *stateDescribe = [[UILabel alloc] init];
        stateDescribe.text = [_list[i] valueForKey:@"examineLog"];
        stateDescribe.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        stateDescribe.textColor = UIColorRBG(153, 153, 153);
        [view addSubview:stateDescribe];
        self.stateDescribe = stateDescribe;
        [stateDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imagePoint.mas_right).with.offset(7);
            make.top.equalTo(state.mas_bottom).with.offset(10);
            make.height.mas_offset(13);
        }];
        
    }
    
    //预计上客时间
    _label1.text =  [NSString stringWithFormat:@"预计上客：%@",[_order valueForKey:@"boardingPlanes"]];
    //出发城市
    _ciryLabel.text = [NSString stringWithFormat:@"出发城市：%@",[_order valueForKey:@"departureCity"]];
    _popelSumLable.text = [NSString stringWithFormat:@"出行人数：%@",[_order valueForKey:@"partPersonNum"]];
    
    NSString *par = [_order valueForKey:@"partWay"];
    if ([par isEqual:@"1"]) {
        _modeLable.text = [NSString stringWithFormat:@"到访方式：驾车"];
    }else if([par isEqual:@"2"]){
        _modeLable.text = [NSString stringWithFormat:@"到访方式：班车"];
    }else{
        _modeLable.text = [NSString stringWithFormat:@"到访方式：其他"];
    }
    
    NSString *lunchNum = [_order valueForKey:@"lunchNum"];
    
    _provideLunchLable.text = [NSString stringWithFormat:@"用餐人数：%@",lunchNum];
    NSString *licensePlate = [_order valueForKey:@"licensePlate"];
    _carCord.text = [NSString stringWithFormat:@"车 牌 号： %@",licensePlate];
    
}
#pragma mark -创建控件
-(void)setupController{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(15, self.view.fY, self.view.fWidth-30, self.view.fHeight-49);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.layer.shadowColor = UIColorRBG(0, 0, 0).CGColor;
    scrollView.layer.shadowOpacity = 0.05f;
    scrollView.layer.shadowRadius = 15.0f;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //创建第一个view
    UIView *viewOne = [[UIView alloc] init];
    viewOne.frame = CGRectMake(0,0,scrollView.fWidth,190);
    viewOne.backgroundColor = UIColorRBG(246, 246, 246);
    _viewOne = viewOne;
    [scrollView addSubview:viewOne];
    //背景
    UIImageView *imageViewOne = [[UIImageView alloc] initWithFrame:viewOne.bounds];
    imageViewOne.image = [UIImage imageNamed:@"dd_bg"];
    [viewOne addSubview:imageViewOne];
    
    //创建第一个view中的控件
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    name.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:name];
    self.name = name;
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).with.offset(15);
        make.top.equalTo(viewOne.mas_top).with.offset(35);
        make.height.mas_offset(16);
    }];
    
    UILabel *telephone = [[UILabel alloc] init];
    telephone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telephone.textColor = UIColorRBG(204, 204, 204);
    [viewOne addSubview:telephone];
    self.telephone = telephone;
    [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).with.offset(15);
        make.top.equalTo(name.mas_bottom).with.offset(16);
        make.height.mas_offset(12);
    }];
    
    //二维码
    UIButton *codeButton = [[UIButton alloc] init];
    [codeButton setEnlargeEdge:20];
    [codeButton setBackgroundImage:[UIImage imageNamed:@"ORcode"] forState:UIControlStateNormal];
    codeButton.enabled = NO;
    [codeButton setHidden:YES];
    [codeButton addTarget:self action:@selector(codeButtons) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:codeButton];
    self.codeButton = codeButton;
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right).with.offset(-15);
        make.top.equalTo(viewOne.mas_top).with.offset(32);
        make.height.mas_offset(23);
        make.width.mas_offset(23);
    }];
    
    UILabel *houseType = [[UILabel alloc] init];
    houseType.text = @"  喜喜直推  ";
    houseType.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    houseType.textColor = UIColorRBG(68, 68, 68);
    houseType.backgroundColor = UIColorRBG(255, 224, 0);
    houseType.layer.cornerRadius = 8;
    houseType.layer.masksToBounds = YES;
    [viewOne addSubview:houseType];
    self.houseType = houseType;
    [houseType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).with.offset(15);
        make.top.equalTo(telephone.mas_bottom).with.offset(24);
        make.height.offset(16);
    }];
    
    UILabel *ItemName = [[UILabel alloc] init];
    ItemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    ItemName.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:ItemName];
    self.ItemName = ItemName;
    [ItemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).with.offset(80);
        make.top.equalTo(telephone.mas_bottom).with.offset(25);
        make.width.mas_offset(240);
        make.height.offset(14);
    }];
    
    UIButton *ItemButton = [[UIButton alloc] init];
    [ItemButton setEnlargeEdge:44];
    [ItemButton setBackgroundImage:[UIImage imageNamed:@"bb_more_unfold"] forState:UIControlStateNormal];
    [ItemButton addTarget:self action:@selector(ItemButtons:) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:ItemButton];
    self.ItemButton = ItemButton;
    [ItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right).with.offset(-15);
        make.top.equalTo(telephone.mas_bottom).with.offset(24);
        make.height.mas_offset(15);
        make.width.mas_offset(9);
    }];
    
    //创建第二个view的高由状态改变每次整加77
    UIView *viewTwo = [[UIView alloc] init];
    viewTwo.backgroundColor = [UIColor whiteColor];
    viewTwo.frame = CGRectMake(0,viewOne.fHeight-45,scrollView.fWidth,106);
    _viewTwo = viewTwo;
    [scrollView addSubview:viewTwo];
    
    UILabel *OrderLabel = [[UILabel alloc] init];
    OrderLabel.text = @"订单记录";
    OrderLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    OrderLabel.textColor = UIColorRBG(68, 68, 68);
    [viewTwo addSubview:OrderLabel];
    [OrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).with.offset(15);
        make.top.equalTo(viewTwo.mas_top).with.offset(16);
        make.height.mas_offset(15);
    }];
    //绘制线
    UIView *ineViewThree = [[UIView alloc] initWithFrame: CGRectMake(0,44, SCREEN_WIDTH, 1)];
    ineViewThree.backgroundColor =UIColorRBG(242, 242, 242);
    [viewTwo addSubview:ineViewThree];
    //圆形图片
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(32,58, 13, 13)];
    
    imageView1.layer.borderColor = UIColorRBG(255, 224, 0).CGColor;
    
    imageView1.layer.borderWidth = 1.0;
    
    _imageView1 = imageView1;
    
    imageView1.layer.masksToBounds =YES;
    
    imageView1.layer.cornerRadius = 13.0/2;
    
    [viewTwo addSubview:imageView1];
    //状态文字
    UILabel *stateTitle = [[UILabel alloc] init];
    
    stateTitle.text = @"报备";
    
    stateTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    stateTitle.textColor = UIColorRBG(153, 153, 153);
    
    _stateTitle1 = stateTitle;
    
    [viewTwo addSubview:stateTitle];
    
    [stateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(viewTwo.mas_left).with.offset(26);
        
        make.top.equalTo(imageView1.mas_bottom).with.offset(10);
        
        make.height.mas_offset(13);
        
    }];
    
    
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((viewTwo.fWidth-13)/2.0,58, 13, 13)];
    
    imageView2.layer.borderColor = UIColorRBG(255, 224, 0).CGColor;
    
    imageView2.layer.borderWidth = 1.0;
    
    imageView2.layer.masksToBounds =YES;
    
    imageView2.layer.cornerRadius = 13.0/2;
    
    self.imageView2 = imageView2;
    
    [viewTwo addSubview:imageView2];
    
    //绘制线
    UIView *imageIneOne = [[UIView alloc] initWithFrame: CGRectMake(imageView1.fX+imageView1.fWidth,64, imageView2.fX-imageView1.fX-imageView1.fWidth, 1)];
    
    imageIneOne.backgroundColor =UIColorRBG(255, 224, 0);
    
    self.imageIneOne = imageIneOne;
    
    [viewTwo addSubview:imageIneOne];
    
    
    UILabel *stateTitle2 = [[UILabel alloc] init];
    
    stateTitle2.text = @"上客";
    
    stateTitle2.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    stateTitle2.textColor = UIColorRBG(153, 153, 153);
    
    [viewTwo addSubview:stateTitle2];
    
    self.stateTitle2 = stateTitle2;
    
    [stateTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView2.mas_centerX);
        
        make.top.equalTo(imageView2.mas_bottom).with.offset(10);
        
        make.height.mas_offset(13);
        
    }];
    
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(viewTwo.fWidth-45,58, 13, 13)];
    
    imageView3.layer.borderColor = UIColorRBG(255, 224, 0).CGColor;
    
    imageView3.layer.borderWidth = 1.0;
    
    imageView3.layer.masksToBounds =YES;
    
    imageView3.layer.cornerRadius = 13.0/2;
    
    self.imageView3 = imageView3;
    
    [viewTwo addSubview:imageView3];
    
    //绘制线
    UIView *imageIneTwo = [[UIView alloc] initWithFrame: CGRectMake(imageView2.fX+imageView2.fWidth,64, imageView3.fX-(imageView2.fX+imageView2.fWidth), 1)];
    
    imageIneTwo.backgroundColor =UIColorRBG(255, 224, 0);
    
    self.imageIneTwo = imageIneTwo;
    
    [viewTwo addSubview:imageIneTwo];
    
    UILabel *stateTitle3 = [[UILabel alloc] init];
    
    stateTitle3.text = @"成交";
    
    stateTitle3.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    
    stateTitle3.textColor = UIColorRBG(153, 153, 153);
    
    [viewTwo addSubview:stateTitle3];
    
    self.stateTitle3 = stateTitle3;
    
    [stateTitle3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView3.mas_centerX);
        
        make.top.equalTo(imageView3.mas_bottom).with.offset(10);
        
        make.height.mas_offset(13);
        
    }];
    
    //绘制线
    UIView *ineViewFour = [[UIView alloc] initWithFrame: CGRectMake(0,105, SCREEN_WIDTH, 1)];
    ineViewFour.backgroundColor = UIColorRBG(242, 242, 242);
    _ineViewFour = ineViewFour;
    [viewTwo addSubview:ineViewFour];
    
    //绘制线
    UIView *ineViewFive = [[UIView alloc] initWithFrame: CGRectMake(80.5,141, 1, 0)];
    ineViewFive.backgroundColor = UIColorRBG(255, 244, 160);
    [viewTwo addSubview:ineViewFive];
    _ineViewFive = ineViewFive;
    
    //按钮一
    UIButton *boardingButton = [[UIButton alloc] init];
    [boardingButton setTitle:@"扫码上客" forState: UIControlStateNormal];
    _boardingButton = boardingButton;
    [boardingButton setTitleColor: UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    boardingButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    boardingButton.backgroundColor = UIColorRBG(255, 209, 49);
    
    boardingButton.layer.shadowColor = [UIColor blackColor].CGColor;
    //2.设置阴影偏移范围
    boardingButton.layer.shadowOffset = CGSizeMake(0, 1);
    //3.设置阴影颜色的透明度
    boardingButton.layer.shadowOpacity = 0.05;
    //4.设置阴影半径
    boardingButton.layer.shadowRadius = 20;
    [boardingButton addTarget:self action:@selector(BoardingCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boardingButton];
    [boardingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.offset(self.view.fWidth/2.0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49+JF_BOTTOM_SPACE);
    }];
    //按钮二
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"上客" forState: UIControlStateNormal];
    _comButton = confirmButton;
    [confirmButton setTitleColor: UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    confirmButton.backgroundColor = UIColorRBG(255, 224, 0);
    
    confirmButton.layer.shadowColor = [UIColor blackColor].CGColor;
    //2.设置阴影偏移范围
    confirmButton.layer.shadowOffset = CGSizeMake(0, 1);
    //3.设置阴影颜色的透明度
    confirmButton.layer.shadowOpacity = 0.05;
    //4.设置阴影半径
    confirmButton.layer.shadowRadius = 20;
    [confirmButton addTarget:self action:@selector(BoardingCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49+JF_BOTTOM_SPACE);
    }];
    
   
    //创建第三个view
    UIView *viewThree = [[UIView alloc] init];
    viewThree.backgroundColor = [UIColor whiteColor];
    viewThree.frame = CGRectMake(0,141+viewTwo.fHeight+10,scrollView.fWidth,182);
    _viewThree = viewThree;
    [scrollView addSubview:viewThree];
    UIView *ineViews =  [[UIView alloc] init];
    ineViews.backgroundColor =UIColorRBG(242, 242, 242);
    [viewThree addSubview:ineViews];
    [ineViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(10);
        make.right.equalTo(viewThree.mas_right).with.offset(-10);
        make.top.equalTo(viewThree.mas_top);
        make.height.mas_offset(1);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = [NSString stringWithFormat:@"预计上客时间：%@",_boaringTimeLabel];
    label1.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _label1 = label1;
    label1.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(viewThree.mas_top).with.offset(20);
        make.height.mas_offset(12);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _ciryLabel = label2;
    label2.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label1.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    _popelSumLable = label3;
    label3.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label3.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label2.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    _modeLable = label4;
    label4.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label4.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label3.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label5 = [[UILabel alloc] init];
    _provideLunchLable = label5;
    label5.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label5.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label4.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    
    UILabel *label6 = [[UILabel alloc] init];
    _carCord = label6;
    label6.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label6.textColor = UIColorRBG(170, 170, 170);
    [viewThree addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).with.offset(15);
        make.top.equalTo(label5.mas_bottom).with.offset(15);
        make.height.mas_offset(12);
    }];
    scrollView.contentSize = CGSizeMake(0, self.view.fHeight-93-kApplicationStatusBarHeight);
    
    [self setCodeViews];
}
#pragma mark -上客按钮
-(void)BoardingCilck{
    if ([_sginStatus isEqual:@"2"]) {
        [_titles setHidden:YES];
    }else{
        [_titles setHidden:NO];
        if([_sginStatus isEqual:@"1"]){
            _titles.text = @"楼盘须与门店签约，未签约可能会影响佣金结算，请及时签约";
        }else{
            _titles.text = @"楼盘须与门店签约，签约过期可能影响佣金结算，请及时续约";
        }
    }
    int boardingLimitTime = [[_order valueForKey:@"boardingLimitTime"] intValue];
    
    long orderCreateTime = [[_order valueForKey:@"orderCreateTime"] longLongValue];
    if (orderCreateTime != 0 ) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970]*1000;
        long time1 = time - orderCreateTime;
        if (time1 >boardingLimitTime*60*1000) {
            [GKCover translucentWindowCenterCoverContent:_codeView animated:YES notClick:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"报备%d分钟后才能上客",boardingLimitTime]];
        }
    }
}
//创建二维码的view
-(void)setCodeViews{
    //创建一个view
    UIView *codeView = [[UIView alloc] init];
    codeView.fSize = CGSizeMake(314, 480);
    codeView.backgroundColor = [UIColor clearColor];
    _codeView = codeView;
    
    UIView *codeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 314, 419)];
    codeView1.backgroundColor = [UIColor whiteColor];
    [codeView addSubview:codeView1];
    UILabel *name = [[UILabel alloc] init];
    _names = name;
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    name.textColor = UIColorRBG(68, 68, 68);
    [codeView1 addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(codeView1.mas_top).with.offset(15);
        make.height.mas_offset(17);
    }];
    UILabel *telephone = [[UILabel alloc] init];
    _telephones = telephone;
    telephone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telephone.textColor = UIColorRBG(153, 153, 153);
    [codeView1 addSubview:telephone];
    [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(name.mas_bottom).with.offset(16);
        make.height.mas_offset(12);
    }];
    UILabel *ItemName = [[UILabel alloc] init];
    _ItemNames = ItemName;
    ItemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ItemName.textColor = UIColorRBG(153, 153, 153);
    ItemName.textAlignment = NSTextAlignmentCenter;
    [codeView1 addSubview:ItemName];
    [ItemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(telephone.mas_bottom).with.offset(9);
        make.height.mas_offset(13);
        make.width.offset(222);
    }];
    
    UIView *codeView2 = [[UIView alloc] initWithFrame:CGRectMake(46, 113, 222, 222)];
    codeView2.backgroundColor = UIColorRBG(255, 224, 0);
    [codeView addSubview:codeView2];
    UIImageView *codeImage = [[UIImageView alloc] init];
    codeImage.image = [UIImage imageNamed:@"OR-code_2"];
    [codeView2 addSubview:codeImage];
    _codeImage = codeImage;
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView2.mas_left).with.offset(14);
        make.top.equalTo(codeView2.mas_top).with.offset(14);
        make.width.mas_offset(196);
        make.height.mas_offset(196);
    }];
    
    UILabel *Titles = [[UILabel alloc] init];
    Titles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [Titles setHidden:YES];
    Titles.numberOfLines = 0;
    Titles.textColor = UIColorRBG(255, 108, 0);
    _titles = Titles;
    [codeView1 addSubview:Titles];
    [Titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(codeView2.mas_bottom).with.offset(18);
        make.width.offset(222);
    }];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(156, 461, 19, 19)];
    [closeButton setEnlargeEdge:44];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"icon_shut"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:closeButton];
}
#pragma mark -二维码
-(void)codeButtons{
    if ([_sginStatus isEqual:@"2"]) {
        [_titles setHidden:YES];
    }else{
        [_titles setHidden:NO];
        if([_sginStatus isEqual:@"1"]){
            _titles.text = @"楼盘须与门店签约，未签约可能会影响佣金结算，请及时签约";
        }else{
            _titles.text = @"楼盘须与门店签约，签约过期可能影响佣金结算，请及时续约";
        }
    }
    int boardingLimitTime = [[_order valueForKey:@"boardingLimitTime"] intValue];
    
    long orderCreateTime = [[_order valueForKey:@"orderCreateTime"] longLongValue];
    if (orderCreateTime != 0 ) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970]*1000;
        long time1 = time - orderCreateTime;
        if (time1 >boardingLimitTime*60*1000) {
            [GKCover translucentWindowCenterCoverContent:_codeView animated:YES notClick:YES];
            //创造通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAlerts) name:@"BoaringVC" object:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"报备%d分钟后才能上客",boardingLimitTime]];
        }
    }
    
}
#pragma mark -关闭二维码弹窗
-(void)closeAlert{
    [self loadData];
    [GKCover hide];
}
-(void)closeAlerts{
    [SVProgressHUD showInfoWithStatus:@"您好,您报备的订单已上客成功"];
    [self loadData];
    [GKCover hide];
}
#pragma mark -凭证上客
-(void)voucherBoarding{
    WZVoucherBoardingController *vb = [[WZVoucherBoardingController alloc] init];
    vb.ID = _ID;
    vb.boardingSuccess = ^(NSString * _Nonnull str) {
        if ([str isEqual:@"1"]) {
            [self loadData];
        }
    };
   [self.navigationController pushViewController:vb animated:YES];
}
#pragma mark -楼盘按钮
-(void)ItemButtons:(UIButton *)button{
    WZHouseDatisController *datis = [[WZHouseDatisController alloc] init];
    datis.ID = _itemId;
    [self.navigationController pushViewController:datis animated:YES];
}
#pragma mark -凭证发起成交
-(void)voucherDealCilck{
    WZVoucherDealController *vb = [[WZVoucherDealController alloc] init];
    vb.ID = _ID;
    vb.dealSuccess = ^(NSString * _Nonnull str) {
        if ([str isEqual:@"1"]) {
            [self loadData];
        }
    };
    [self.navigationController pushViewController:vb animated:YES];
}
#pragma mark -发起成交
-(void)LaunchDealCilck{
    NSString *boaringId = _ID;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = boaringId;
    NSString *url = [NSString stringWithFormat:@"%@/order/dealOrder",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"发起成交成功"];
            
            [self loadData];
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
#pragma mark -重新报备
-(void)NewReportCilck{
    WZNewReportController *report = [[WZNewReportController alloc] init];
    report.ItemNames = self.ItemName.text;
    report.itemId = _itemId;
    report.sginStatu = _sginStatus;
    report.dutyTelphone = _proTelphone;
    report.types = @"1";
    report.custormNames = _name.text;
    report.telphones = _telephone.text;
    report.orderTelFlag = _orderTelFlag;
    report.loadTimes = [_order valueForKey:@"boardingPlanes"];
    report.peopleSums = [_order valueForKey:@"partPersonNum"];
    report.setOutCitys = [_order valueForKey:@"departureCity"];
    report.eatPeoples = [_order valueForKey:@"lunchNum"];
    report.tags = [[_order valueForKey:@"partWay"] integerValue];
    report.houseType = [_order valueForKey:@"selfEmployed"];
    [self.navigationController pushViewController:report animated:YES];
}
#pragma mark -打电话
-(void)playTelphone{
    NSString *phone = _telephone.text;
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}
#pragma mark -设置导航条
-(void)setNarItems{
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor whiteColor].CGColor;
    //2.设置阴影偏移范围
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    //3.设置阴影颜色的透明度
    self.navigationController.navigationBar.layer.shadowOpacity = 0.05;
    //4.设置阴影半径
    self.navigationController.navigationBar.layer.shadowRadius = 20;
  

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

@end
