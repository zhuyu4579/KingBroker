//
//  WZNewReportController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  报备/批量报备2.0
#import "GKCover.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import "WZPickerView.h"
#import <SVProgressHUD.h>
#import "WZCustomerItem.h"
#import "NSString+LCExtension.h"
#import "UIBarButtonItem+Item.h"
#import "WZNewReportController.h"
#import "WZAddCustomerController.h"
#import "WZNavigationController.h"
#import "WZReportSuccessController.h"
#import "WZSelectProjectsController.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZNewReportController ()<UIScrollViewDelegate,UITextFieldDelegate>
//按钮View
@property (nonatomic, strong)UIView *buttonView;
//滑动页面
@property (nonatomic, strong)UIScrollView *scrollView;
//单个报备按钮
@property (nonatomic, strong)UILabel *reportLabel;
//批量报备按钮
@property (nonatomic, strong)UILabel *batchReportLabel;
//第-个客户view
@property (nonatomic, strong)UIView *viewOne;
//增加客户view
@property (nonatomic, strong)UIView *addCustomerView;
//其他view
@property (nonatomic, strong)UIView *otherView;
//上客时间
@property (nonatomic, strong)UILabel *loadTime;
//出行人数
@property (nonatomic, strong)UITextField *peopleSum;
//用餐人数
@property (nonatomic, strong)UITextField *eatPeople;
//出发城市
@property (nonatomic, strong)UITextField *setOutCity;
//时间数组
@property (nonatomic, strong)NSArray *timeArray;
//出行方式
@property(nonatomic,assign)NSInteger tags;
//报备方式
@property (nonatomic, strong)NSString *reportType;
//请求数据
@property(nonatomic,strong)NSString *uuid;
//参数
@property(nonatomic,strong)NSDictionary *paraments;
@end

@implementation WZNewReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    _reportType = @"0";
    //设置导航栏
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    //创建控件
    [self createControl];
}
#pragma mark -创建控件
-(void)createControl{
    //创建报备按钮view
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, kApplicationStatusBarHeight+76)];
    buttonView.backgroundColor = [UIColor whiteColor];
    _buttonView = buttonView;
    [self.view addSubview:buttonView];
    [self createButtonView];
    //创建一个UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0,kApplicationStatusBarHeight+76, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-125-JF_BOTTOM_SPACE);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.delegate =self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //创建报备view
    [self createView];
    //创建报备按钮
    UIButton *reportButton = [[UIButton alloc] init];
    [reportButton setTitle:@"确认报备" forState:UIControlStateNormal];
    [reportButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    reportButton.backgroundColor = UIColorRBG(255, 204, 0);
    reportButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [reportButton addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportButton];
    [reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.offset(self.view.fWidth);
        make.height.offset(49+JF_BOTTOM_SPACE);
    }];
}
#pragma mark -创建按钮
-(void)createButtonView{
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [backButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:15];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonView.mas_left).offset(15);
        make.top.equalTo(_buttonView.mas_top).offset(kApplicationStatusBarHeight+9);
        make.width.offset(11);
        make.height.offset(20);
    }];
    //创建选择客户按钮
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [selectButton setEnlargeEdgeWithTop:10 right:15 bottom:10 left:20];
    [selectButton addTarget:self action:@selector(selectCustomer) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_buttonView.mas_right).offset(-15);
        make.top.equalTo(_buttonView.mas_top).offset(kApplicationStatusBarHeight+9);
        make.width.offset(18);
        make.height.offset(20);
    }];
    //单个报备按钮
    UILabel *reportLabel = [[UILabel alloc] init];
    reportLabel.text = @"报备";
    reportLabel.textColor = UIColorRBG(51, 51, 51);
    reportLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];
    _reportLabel = reportLabel;
    [_buttonView addSubview:reportLabel];
    [reportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonView.mas_left).offset(17);
        make.bottom.equalTo(_buttonView.mas_bottom).offset(-13);
        make.height.offset(20);
        make.width.offset(40);
    }];
    UIButton *reportButton = [[UIButton alloc] init];
    [reportButton addTarget:self action:@selector(reportButtons) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:reportButton];
    [reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buttonView.mas_left);
        make.bottom.equalTo(_buttonView.mas_bottom);
        make.height.offset(33);
        make.width.offset(70);
    }];
    //批量报备按钮
    UILabel *batchReportLabel = [[UILabel alloc] init];
    batchReportLabel.text = @"批量报备";
    batchReportLabel.textColor = UIColorRBG(204, 204, 204);
    batchReportLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _batchReportLabel = batchReportLabel ;
    [_buttonView addSubview:batchReportLabel];
    [batchReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reportLabel.mas_right).offset(29);
        make.bottom.equalTo(_buttonView.mas_bottom).offset(-13);
        make.height.offset(20);
    }];
    UIButton *batchReportButton = [[UIButton alloc] init];
    [batchReportButton addTarget:self action:@selector(batchReportButtons) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:batchReportButton];
    [batchReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reportButton.mas_right);
        make.bottom.equalTo(_buttonView.mas_bottom);
        make.height.offset(33);
        make.width.offset(80);
    }];
}
#pragma mark -创建报备view
-(void)createView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 8, _scrollView.fWidth, 49)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    //选择楼盘
    UILabel *itemNameLabel = [[UILabel alloc] init];
    itemNameLabel.text = @"楼  盘 名";
    itemNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    itemNameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:itemNameLabel];
    [itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(15);
        make.top.equalTo(view.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //楼盘名称
    UILabel *itemName = [[UILabel alloc] init];
    itemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    itemName.textColor = UIColorRBG(204, 204, 204);
    if ([_ItemNames isEqual:@""]||!_ItemNames) {
        itemName.text = @"选择报备楼盘";
    }else{
        itemName.text = _ItemNames;
        itemName.textColor = UIColorRBG(51, 51, 51);
    }
    _ItemName = itemName;
    [view addSubview:itemName];
    [itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemNameLabel.mas_right).with.offset(40);
        make.top.equalTo(view.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //下划线
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.bottom.equalTo(itemName.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-80);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"bb_more_unfold"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(-29);
        make.top.equalTo(view.mas_top).with.offset(20);
        make.height.mas_offset(15);
        make.width.mas_offset(9);
    }];
    //下划线
    UIView  *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(255, 204, 0);
    [view addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.bottom.equalTo(itemName.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(36);
    }];
    //点击按钮选择楼盘
    UIButton *titemNameButton = [[UIButton alloc] init];
    [titemNameButton addTarget:self action:@selector(itemNameButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:titemNameButton];
    [titemNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(15);
        make.top.equalTo(view.mas_top);
        make.height.mas_offset(48);
        make.width.mas_offset(_scrollView.fWidth-30);
    }];
    if([_types isEqual:@"1"]){
        [titemNameButton setEnabled:NO];
    }else{
        [titemNameButton setEnabled:YES];
    }
    //创建默认客户
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0,view.fY+view.fHeight, _scrollView.fWidth, 118)];
     _viewOne = views;
    views.tag = 1000;
    views.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:views];
    //客户view
    UIView *cusNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, 48)];
    cusNameView.tag = 8;
    [views addSubview:cusNameView];
    //客户名称
    UILabel *customNameLabel = [[UILabel alloc] init];
    customNameLabel.text = @"客户姓名";
    customNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    customNameLabel.textColor = UIColorRBG(51, 51, 51);
    [cusNameView addSubview:customNameLabel];
    [customNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusNameView.mas_left).with.offset(15);
        make.top.equalTo(cusNameView.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //创建客户姓名的文本框
    UITextField *customerName = [[UITextField alloc] init];
    customerName.tag = 60;
    customerName.placeholder = @"必填";
    if (![_custormNames isEqual:@""]) {
        customerName.text = _custormNames;
    }
    customerName.delegate = self;
    customerName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    customerName.textColor = UIColorRBG(68, 68, 68);
    customerName.keyboardType = UIKeyboardTypeDefault;
    customerName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _custormName = customerName;
    [cusNameView addSubview:customerName];
    [customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customNameLabel.mas_right).with.offset(40);
        make.top.equalTo(cusNameView.mas_top).with.offset(5);
        make.height.mas_offset(43);
        make.width.mas_offset(view.fWidth-120);
    }];
    //下划线
    UIView  *ineOnes = [[UIView alloc] init];
    ineOnes.backgroundColor = UIColorRBG(240, 240, 240);
    [cusNameView addSubview:ineOnes];
    [ineOnes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusNameView.mas_left).offset(15);
        make.bottom.equalTo(customerName.mas_bottom);
        make.height.offset(1);
        make.width.offset(view.fWidth-30);
    }];
    //客户电话view
    UIView *cusTelphoneView = [[UIView alloc] initWithFrame:CGRectMake(0, cusNameView.fY+cusNameView.fHeight, view.fWidth, 48)];
    cusTelphoneView.tag = 9;
    [views addSubview:cusTelphoneView];
    
    //客户电话
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.text = @"客户电话";
    telphoneLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphoneLabel.textColor = UIColorRBG(51, 51, 51);
    [cusTelphoneView addSubview:telphoneLabel];
    [telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusTelphoneView.mas_left).with.offset(15);
        make.top.equalTo(cusTelphoneView.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //电话
    UITextField *telphone = [[UITextField alloc] init];
    telphone.tag = 61;
    telphone.placeholder = @"输入手机号";
    if (![_telphones isEqual:@""]) {
        telphone.text = _telphones;
    }
    telphone.delegate = self;
    telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphone.textColor = UIColorRBG(68, 68, 68);
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    _telphone = telphone;
    [cusTelphoneView addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(telphoneLabel.mas_right).with.offset(40);
        make.top.equalTo(cusTelphoneView.mas_top).with.offset(5);
        make.height.mas_offset(43);
        make.width.mas_offset(view.fWidth-170);
    }];
    //下划线
    UIView  *ineTwos = [[UIView alloc] init];
    ineTwos.backgroundColor = UIColorRBG(240, 240, 240);
    [cusTelphoneView addSubview:ineTwos];
    [ineTwos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusTelphoneView.mas_left).offset(15);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(view.fWidth-80);
    }];
    //创建增加号码按钮
    UIButton *addTelephone = [[UIButton alloc] init];
    [addTelephone setEnlargeEdge:44];
    [addTelephone setBackgroundImage:[UIImage imageNamed:@"bb_add-1"] forState:UIControlStateNormal];
    [addTelephone addTarget:self action:@selector(addTelephones:) forControlEvents:UIControlEventTouchUpInside];
    addTelephone.tag = 63;
    [cusTelphoneView addSubview:addTelephone];
    [addTelephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cusTelphoneView.mas_right).offset(-26);
        make.top.equalTo(cusTelphoneView.mas_top).offset(21);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //下划线
    UIView  *ineThree = [[UIView alloc] init];
    ineThree.backgroundColor = UIColorRBG(255, 204, 0);
    [cusTelphoneView addSubview:ineThree];
    [ineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cusTelphoneView.mas_right).offset(-15);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(36);
    }];
    
    //创建增加客户按钮
    UIView *addCustomerView = [[UIView alloc] initWithFrame:CGRectMake(0, views.fY+views.fHeight, _scrollView.fWidth, 47)];
    addCustomerView.backgroundColor = [UIColor whiteColor];
    _addCustomerView = addCustomerView;
    [addCustomerView setHidden:YES];
    [_scrollView addSubview:addCustomerView];
    //按钮
    UIButton *addCustomerButton = [[UIButton alloc] init];
    [addCustomerButton setImage:[UIImage imageNamed:@"bb_addition"] forState:UIControlStateNormal];
    [addCustomerButton setTitle:@" 添加客户" forState:UIControlStateNormal];
    [addCustomerButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    addCustomerButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    addCustomerButton.layer.borderWidth = 1.0;
    addCustomerButton.layer.borderColor = UIColorRBG(102, 221, 85).CGColor;
    addCustomerButton.layer.cornerRadius = 3.0;
    [addCustomerButton setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [addCustomerButton addTarget:self action:@selector(addCustomer) forControlEvents:UIControlEventTouchUpInside];
    [addCustomerView addSubview:addCustomerButton];
    [addCustomerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addCustomerView.mas_centerX);
        make.top.equalTo(addCustomerView.mas_top).offset(2);
        make.height.offset(24);
        make.width.offset(85);
    }];
    //其他view
    UIView *otherView = [[UIView alloc] initWithFrame:CGRectMake(0, views.fHeight+views.fY+8, _scrollView.fWidth, 261)];
    otherView.backgroundColor = [UIColor whiteColor];
    _otherView = otherView;
    [_scrollView addSubview:otherView];
    [self createOtherView];
    _scrollView.contentSize = CGSizeMake(0, otherView.fY+otherView.fHeight+20);
}
#pragma mark -创建其他
-(void)createOtherView{
    //创建上客时间
    UILabel *loadTimeLabel = [[UILabel alloc] init];
    loadTimeLabel.text = @"上客时间";
    loadTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    loadTimeLabel.textColor = UIColorRBG(51, 51, 51);
    [_otherView addSubview:loadTimeLabel];
    [loadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(_otherView.mas_top).with.offset(25);
        make.height.mas_offset(13);
    }];
    
    _loadTime = [[UILabel alloc] init];
    _loadTime.text = @"选择预计上客时间";
    _loadTime.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _loadTime.textColor = UIColorRBG(204, 204, 204);
    [_otherView addSubview:_loadTime];
    [_loadTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loadTimeLabel.mas_right).with.offset(40);
        make.top.equalTo(_otherView.mas_top).with.offset(25);
        make.height.mas_offset(13);
    }];
    //点击按钮选择时间
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"bb_more_unfold"];
    [_otherView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_otherView.mas_right).with.offset(-29);
        make.top.equalTo(_otherView.mas_top).with.offset(24);
        make.height.mas_offset(15);
        make.width.mas_offset(9);
    }];
    UIButton *loadTimeButton = [[UIButton alloc] init];
    [loadTimeButton addTarget:self action:@selector(loadTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_otherView addSubview:loadTimeButton];
    [loadTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(_otherView.mas_top);
        make.height.mas_offset(53);
        make.width.mas_offset(_otherView.fWidth-30);
    }];
    //绘制线
    UIView *ineView3 = [[UIView alloc] init];
    ineView3.backgroundColor = UIColorRBG(242, 242, 242);
    [_otherView addSubview:ineView3];
    [ineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(loadTimeLabel.mas_bottom).with.offset(15);
        make.height.mas_offset(1);
        make.width.mas_offset(_otherView.fWidth-30);
    }];
    //创建第二个view中的text
    UILabel  *peopleSumLabel = [[UILabel alloc] init];
    peopleSumLabel.text = @"出行人数";
    peopleSumLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    peopleSumLabel.textColor = UIColorRBG(51, 51, 51);
    [_otherView addSubview:peopleSumLabel];
    [peopleSumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(ineView3.mas_bottom).with.offset(20);
        make.height.mas_offset(13);
    }];
    UITextField *peopleSum = [[UITextField alloc] init];
    peopleSum.placeholder = @"必填";
    peopleSum.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    peopleSum.textColor = UIColorRBG(68, 68, 68);
    peopleSum.keyboardType = UIKeyboardTypeNumberPad;
    peopleSum.delegate = self;
    _peopleSum = peopleSum;
    [_otherView addSubview:peopleSum];
    [peopleSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleSumLabel.mas_right).with.offset(40);
        make.top.equalTo(ineView3.mas_bottom).with.offset(0);
        make.height.mas_offset(53);
        make.width.mas_offset(_otherView.fWidth-121);
    }];
    //绘制线
    UIView *ineView4 = [[UIView alloc] init];
    ineView4.backgroundColor =UIColorRBG(242, 242, 242);
    [_otherView addSubview:ineView4];
    [ineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(peopleSum.mas_bottom);
        make.height.mas_offset(1);
        make.width.mas_offset(_otherView.fWidth-30);
    }];
    //创建第二个view中的用餐人数
    UILabel *eatPeopleLabel = [[UILabel alloc] init];
    eatPeopleLabel.text = @"用餐人数";
    eatPeopleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    eatPeopleLabel.textColor = UIColorRBG(51, 51, 51);
    [_otherView addSubview:eatPeopleLabel];
    [eatPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(ineView4.mas_bottom).with.offset(20);
        make.height.mas_offset(13);
    }];
    UITextField *eatPeople = [[UITextField alloc] init];
    eatPeople.placeholder = @"可选填";
    eatPeople.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    eatPeople.textColor = UIColorRBG(68, 68, 68);
    eatPeople.delegate = self;
    //键盘设置
    eatPeople.keyboardType = UIKeyboardTypeNumberPad;
    _eatPeople = eatPeople;
    [_otherView addSubview:eatPeople];
    [eatPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(eatPeopleLabel.mas_right).with.offset(40);
        make.top.equalTo(ineView4.mas_bottom).with.offset(0);
        make.height.mas_offset(53);
        make.width.mas_offset(_otherView.fWidth-121);
    }];
    
    //绘制线
    UIView *ineView5 = [[UIView alloc] init];
    ineView5.backgroundColor =UIColorRBG(242, 242, 242);
    [_otherView addSubview:ineView5];
    [ineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(eatPeople.mas_bottom);
        make.height.mas_offset(1);
        make.width.mas_offset(_otherView.fWidth-30);
    }];
    
    UILabel *setOutCityLabel = [[UILabel alloc] init];
    setOutCityLabel.text = @"出发城市";
    setOutCityLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    setOutCityLabel.textColor = UIColorRBG(51, 51, 51);
    [_otherView addSubview:setOutCityLabel];
    [setOutCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(ineView5.mas_bottom).with.offset(20);
        make.height.mas_offset(13);
    }];
    
    //创建第三个view中出发城市
    _setOutCity = [[UITextField alloc] init];
    _setOutCity.placeholder = @"必填";
    _setOutCity.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _setOutCity.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    _setOutCity.keyboardType = UIKeyboardTypeDefault;
    _setOutCity.delegate = self;
    [_otherView addSubview:_setOutCity];
    [_setOutCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setOutCityLabel.mas_right).with.offset(40);
        make.top.equalTo(ineView5.mas_bottom);
        make.width.mas_offset(_otherView.fWidth-121);
        make.height.mas_offset(53);
    }];
    //绘制线
    UIView *ineView6 = [[UIView alloc] init];
    ineView6.backgroundColor =UIColorRBG(242, 242, 242);
    [_otherView addSubview:ineView6];
    [ineView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left).with.offset(15);
        make.top.equalTo(_setOutCity.mas_bottom);
        make.height.mas_offset(1);
        make.width.mas_offset(_otherView.fWidth-30);
    }];

    UIView *viewFour = [[UIView alloc] init];
    viewFour.backgroundColor = [UIColor whiteColor];
    [_otherView addSubview:viewFour];
    [viewFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_otherView.mas_left);
        make.top.equalTo(ineView6.mas_bottom);
        make.height.mas_offset(53);
        make.width.mas_offset(_otherView.fWidth);
    }];
    
    UILabel *modeLable = [[UILabel alloc] init];
    modeLable.text = @"到达方式";
    modeLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    modeLable.textColor = UIColorRBG(51, 51, 51);
    [viewFour addSubview:modeLable];
    [modeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewFour.mas_left).with.offset(15);
        make.top.equalTo(viewFour.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //方式按钮
    UIButton *modeButtonOne = [[UIButton alloc] init];
    [modeButtonOne setEnlargeEdge:30];
    [modeButtonOne setBackgroundImage:[UIImage imageNamed:@"choose_2"] forState:UIControlStateNormal];
    [modeButtonOne setBackgroundImage:[UIImage imageNamed:@"bb_choose-1"] forState:UIControlStateSelected];
    modeButtonOne.tag = 20;
    modeButtonOne.selected = YES;
    [modeButtonOne addTarget:self action:@selector(modeButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:modeButtonOne];
    [modeButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeLable.mas_right).with.offset(40);
        make.top.equalTo(viewFour.mas_top).with.offset(17);
        make.height.mas_offset(19);
        make.width.mas_offset(19);
    }];
    UILabel *modeOne = [[UILabel alloc] init];
    modeOne.text = @"自驾";
    modeOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    modeOne.textColor = UIColorRBG(68, 68, 68);
    [viewFour addSubview:modeOne];
    [modeOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeButtonOne.mas_right).with.offset(10);
        make.top.equalTo(viewFour.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    
    UIButton *modeButtonTwo = [[UIButton alloc] init];
    [modeButtonTwo setEnlargeEdge:30];
    [modeButtonTwo setBackgroundImage:[UIImage imageNamed:@"choose_2"] forState:UIControlStateNormal];
    [modeButtonTwo setBackgroundImage:[UIImage imageNamed:@"bb_choose-1"] forState:UIControlStateSelected];
    modeButtonTwo.tag = 21;
    [modeButtonTwo addTarget:self action:@selector(modeButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:modeButtonTwo];
    [modeButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeOne.mas_right).with.offset(23);
        make.top.equalTo(viewFour.mas_top).with.offset(17);
        make.height.mas_offset(19);
        make.width.mas_offset(19);
    }];
    UILabel *modeTwo = [[UILabel alloc] init];
    modeTwo.text = @"班车";
    modeTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    modeTwo.textColor = UIColorRBG(68, 68, 68);
    [viewFour addSubview:modeTwo];
    [modeTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeButtonTwo.mas_right).with.offset(10);
        make.top.equalTo(viewFour.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    
    UIButton *modeButtonThree = [[UIButton alloc] init];
    [modeButtonThree setEnlargeEdge:30];
    [modeButtonThree setBackgroundImage:[UIImage imageNamed:@"choose_2"] forState:UIControlStateNormal];
    [modeButtonThree setBackgroundImage:[UIImage imageNamed:@"bb_choose-1"] forState:UIControlStateSelected];
    modeButtonThree.tag = 22;
    [modeButtonThree addTarget:self action:@selector(modeButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:modeButtonThree];
    [modeButtonThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeTwo.mas_right).with.offset(24);
        make.top.equalTo(viewFour.mas_top).with.offset(17);
        make.height.mas_offset(19);
        make.width.mas_offset(19);
    }];
    UILabel *modeThree = [[UILabel alloc] init];
    modeThree.text = @"其他";
    modeThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    modeThree.textColor = UIColorRBG(68, 68, 68);
    [viewFour addSubview:modeThree];
    [modeThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeButtonThree.mas_right).with.offset(10);
        make.top.equalTo(viewFour.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
}

#pragma mark -创建客户
-(UIView *)createCustomer:(CGFloat)frame{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame, self.view.fWidth, 118)];
    view.backgroundColor = [UIColor whiteColor];
    //客户view
    UIView *cusNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, 48)];
    cusNameView.tag = 8;
    [view addSubview:cusNameView];
    //客户名称
    UILabel *customNameLabel = [[UILabel alloc] init];
    customNameLabel.text = @"客户姓名";
    customNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    customNameLabel.textColor = UIColorRBG(51, 51, 51);
    [cusNameView addSubview:customNameLabel];
    [customNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusNameView.mas_left).with.offset(15);
        make.top.equalTo(cusNameView.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //创建客户姓名的文本框
    UITextField *customerName = [[UITextField alloc] init];
    [cusNameView addSubview:customerName];
    customerName.placeholder = @"必填";
    customerName.tag = 60;
    customerName.delegate = self;
    customerName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    customerName.textColor = UIColorRBG(68, 68, 68);
    customerName.keyboardType = UIKeyboardTypeDefault;
    customerName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customNameLabel.mas_right).with.offset(40);
        make.top.equalTo(cusNameView.mas_top).with.offset(5);
        make.height.mas_offset(43);
        make.width.mas_offset(view.fWidth-120);
    }];
    //下划线
    UIView  *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(240, 240, 240);
    [cusNameView addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusNameView.mas_left).offset(15);
        make.bottom.equalTo(customerName.mas_bottom);
        make.height.offset(1);
        make.width.offset(view.fWidth-80);
    }];
    //创建删除号码按钮
    UIButton *delCustomer = [[UIButton alloc] init];
    [delCustomer setEnlargeEdge:44];
    [delCustomer setTag:62];
    [delCustomer setBackgroundImage:[UIImage imageNamed:@"bb_delete-1"] forState:UIControlStateNormal];
    [delCustomer addTarget:self action:@selector(delCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [cusNameView addSubview:delCustomer];
    [delCustomer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cusNameView.mas_right).offset(-26);
        make.top.equalTo(cusNameView.mas_top).offset(21);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //下划线
    UIView  *inedel = [[UIView alloc] init];
    inedel.backgroundColor = UIColorRBG(255, 204, 0);
    [cusNameView addSubview:inedel];
    [inedel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cusNameView.mas_right).offset(-15);
        make.top.equalTo(customerName.mas_bottom);
        make.height.offset(1);
        make.width.offset(36);
    }];
    //客户电话view
    UIView *cusTelphoneView = [[UIView alloc] initWithFrame:CGRectMake(0, cusNameView.fY+cusNameView.fHeight, view.fWidth, 48)];
    cusTelphoneView.tag = 9;
    [view addSubview:cusTelphoneView];
    //客户电话
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.text = @"客户电话";
    telphoneLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphoneLabel.textColor = UIColorRBG(51, 51, 51);
    [cusTelphoneView addSubview:telphoneLabel];
    [telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusTelphoneView.mas_left).with.offset(15);
        make.top.equalTo(cusTelphoneView.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //电话
    UITextField *telphone = [[UITextField alloc] init];
    telphone.placeholder = @"输入手机号";
    telphone.delegate = self;
    telphone.tag = 61;
    telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphone.textColor = UIColorRBG(68, 68, 68);
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    [cusTelphoneView addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(telphoneLabel.mas_right).with.offset(40);
        make.top.equalTo(cusTelphoneView.mas_top).with.offset(5);
        make.height.mas_offset(43);
        make.width.mas_offset(view.fWidth-170);
    }];
    //下划线
    UIView  *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [cusTelphoneView addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusTelphoneView.mas_left).offset(15);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(view.fWidth-80);
    }];
    //创建增加号码按钮
    UIButton *addTelephone = [[UIButton alloc] init];
    [addTelephone setEnlargeEdge:44];
    [addTelephone setTag:63];
    [addTelephone setBackgroundImage:[UIImage imageNamed:@"bb_add-1"] forState:UIControlStateNormal];
    [addTelephone addTarget:self action:@selector(addTelephones:) forControlEvents:UIControlEventTouchUpInside];
    [cusTelphoneView addSubview:addTelephone];
    [addTelephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cusTelphoneView.mas_right).offset(-26);
        make.top.equalTo(cusTelphoneView.mas_top).offset(21);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //下划线
    UIView  *ineThree = [[UIView alloc] init];
    ineThree.backgroundColor = UIColorRBG(255, 204, 0);
    [cusTelphoneView addSubview:ineThree];
    [ineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cusTelphoneView.mas_right).offset(-15);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(36);
    }];
    return view;
}
#pragma mark -创建客户电话
-(UIView *)createCustomerTelphone:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    //客户电话
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.text = @"客户电话";
    telphoneLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphoneLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:telphoneLabel];
    [telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).with.offset(15);
        make.top.equalTo(view.mas_top).with.offset(20);
        make.height.mas_offset(13);
    }];
    //电话
    UITextField *telphone = [[UITextField alloc] init];
    telphone.placeholder = @"输入手机号";
    telphone.delegate = self;
    telphone.tag = 70;
    telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphone.textColor = UIColorRBG(68, 68, 68);
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(telphoneLabel.mas_right).with.offset(40);
        make.top.equalTo(view.mas_top).with.offset(5);
        make.height.mas_offset(43);
        make.width.mas_offset(view.fWidth-170);
    }];
    //下划线
    UIView  *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(view.fWidth-80);
    }];
    //创建删除号码按钮
    UIButton *addTelephone = [[UIButton alloc] init];
    [addTelephone setEnlargeEdge:44];
    [addTelephone setTag:71];
    [addTelephone setBackgroundImage:[UIImage imageNamed:@"bb_delete-1"] forState:UIControlStateNormal];
    [addTelephone addTarget:self action:@selector(delTelephones:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addTelephone];
    [addTelephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-26);
        make.top.equalTo(view.mas_top).offset(21);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //下划线
    UIView  *ineThree = [[UIView alloc] init];
    ineThree.backgroundColor = UIColorRBG(255, 204, 0);
    [view addSubview:ineThree];
    [ineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(36);
    }];
    
    return view;
}

#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -选择客户
-(void)selectCustomer{
    //跳转选择客户页面
    WZAddCustomerController *addVC = [[WZAddCustomerController alloc] init];
    addVC.type = _reportType;
    addVC.cusBlock = ^(NSArray *cusArray) {
        if (cusArray.count == 0) {
            return;
        }
        for (int i=0; i<cusArray.count; i++) {
            NSString *name = [cusArray[i] valueForKey:@"name"];
            NSString *tel = [cusArray[i] valueForKey:@"telphone"];
            //判断是否实号显示
            if ([_orderTelFlag isEqual:@"0"] && tel.length == 11) {
                tel = [NSString stringWithFormat:@"%@****%@",[tel substringToIndex:3],[tel substringFromIndex:7]];
            }
            if (i==0) {
                _custormName.text = name;
                _telphone.text = tel;
            }else{
                NSUInteger n = _scrollView.subviews.count-3;
                _addCustomerView.fY += 128;
                _otherView.fY +=128;
                UIView *customerView = [self createCustomer:_addCustomerView.fY-118];
                [customerView setTag:1000 + n];
                [_scrollView addSubview:customerView];
                int height =  0;
                height += 128;
                _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);
                UITextField *cusName = [[customerView viewWithTag:8] viewWithTag:60];
                UITextField *telphone = [[customerView viewWithTag:9] viewWithTag:61];
                cusName.text = name;
                telphone.text = tel;
            }
        }
    };
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark -单个报备按钮
-(void)reportButtons{
    _reportType = @"0";
    [self findSubView:self.view];
    [_addCustomerView setHidden:YES];
    NSUInteger n = _scrollView.subviews.count-4;
    
    for (int i = 1; i<= n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        [view setHidden:YES];
    }
    
    _otherView.fY = _viewOne.fY+_viewOne.fHeight+8;
    _reportLabel.textColor = UIColorRBG(51, 51, 51);
    _reportLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];
    _batchReportLabel.textColor = UIColorRBG(204, 204, 204);
    _batchReportLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _scrollView.contentSize = CGSizeMake(0, _otherView.fY+_otherView.fHeight+20);
}
#pragma mark -批量报备按钮
-(void)batchReportButtons{
    _reportType = @"1";
    [self findSubView:self.view];
    [_addCustomerView setHidden:NO];
    NSUInteger n = _scrollView.subviews.count-4;
    
    for (int i = 1; i<= n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        [view setHidden:NO];
    }
    _otherView.fY = _addCustomerView.fY+_addCustomerView.fHeight+8;
    _batchReportLabel.textColor = UIColorRBG(51, 51, 51);
    _batchReportLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];
    _reportLabel.textColor = UIColorRBG(204, 204, 204);
    _reportLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _scrollView.contentSize = CGSizeMake(0, _otherView.fY+_otherView.fHeight+20);
}
#pragma mark -选择楼盘
-(void)itemNameButton{
    //跳转选择楼盘列表
    WZSelectProjectsController *projectVC = [[WZSelectProjectsController alloc] init];
    projectVC.projectBlock = ^(NSDictionary *dicty) {
        _itemId = [dicty valueForKey:@"projectId"];
        NSString *itemName = [dicty valueForKey:@"projectName"];
        if (![itemName isEqual:@""]) {
            _ItemName.textColor = UIColorRBG(51, 51, 51);
            _ItemName.text = itemName;
        }
        _sginStatu = [dicty valueForKey:@"signStatus"];
        _dutyTelphone = [dicty valueForKey:@"telphone"];
        _orderTelFlag = [dicty valueForKey:@"orderTelFlag"];
        //清除手机号
        [self setTelphoneType];
        //请求数据
        [self loadTimeData];
    };
    [self.navigationController pushViewController:projectVC animated:YES];
}
#pragma mark -设置电话号码是否为短号
-(void)setTelphoneType{
    NSInteger n = _scrollView.subviews.count - 3;
    for (int i = 0; i<n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        UITextField *telphoneOne = [[view viewWithTag:9] viewWithTag:61];
        if (![telphoneOne.text isEqual:@""]) {
            telphoneOne.text = @"";
            telphoneOne.placeholder = @"输入手机号";
        }
        UITextField *telphoneTwo = [[view viewWithTag:10] viewWithTag:70];
        if (![telphoneTwo.text isEqual:@""]) {
            telphoneTwo.text = @"";
            telphoneTwo.placeholder = @"输入手机号";
        }
        UITextField *telphoneThree = [[view viewWithTag:11] viewWithTag:70];
        if (![telphoneThree.text isEqual:@""]) {
            telphoneThree.text = @"";
            telphoneThree.placeholder = @"输入手机号";
        }
        UITextField *telphoneFour = [[view viewWithTag:12] viewWithTag:70];
        if (![telphoneFour.text isEqual:@""]) {
            telphoneFour.text = @"";
            telphoneFour.placeholder = @"输入手机号";
        }
        
    }
}

#pragma mark -上客时间
-(void)loadTimeData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _itemId;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/planBoardingDate",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSArray *array = [[responseObject valueForKey:@"data"] valueForKey:@"rows"];
            
            NSMutableArray *mArray = [NSMutableArray array];
            for (NSString *time in array) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"name"] = time;
                [mArray addObject:dic];
            }
            _timeArray = mArray;
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
#pragma mark -增加客户
-(void)addCustomer{
    //默认有一个 从第一个下面开始添加
    NSUInteger n = _scrollView.subviews.count-3;
    _addCustomerView.fY += 128;
    _otherView.fY +=128;
    UIView *customerView = [self createCustomer:_addCustomerView.fY-118];
    [customerView setTag:1000 + n];
    [_scrollView addSubview:customerView];
    int height =  0;
    height += 128;
    _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);
}
#pragma mark -删除客户
-(void)delCustomer:(UIButton *)button{
    NSInteger tag = button.superview.superview.tag;
    
    NSUInteger n = _scrollView.subviews.count-4;

    UIView *view = button.superview.superview;
    NSInteger h = view.frame.size.height;
    NSInteger m = n - (tag-1000);
    for (int i = 1; i<= m; i++) {
        UIView *view = [_scrollView viewWithTag:(tag+i)];
        [view setTag:(tag+i -1)];
        view.fY -= h+10;
    }
    [view removeFromSuperview];
    _addCustomerView.fY -= h+10;
    _otherView.fY -= h+10;
    int height =  0;
    height -= h+10;
    _scrollView.contentSize = CGSizeMake(0, _scrollView.contentSize.height + height);

}
#pragma mark -增加电话号码
-(void)addTelephones:(UIButton *)button{
    UIView *customerView = button.superview.superview;
    NSUInteger n = customerView.subviews.count - 2;
    NSInteger tag = customerView.tag;
    NSInteger i = _scrollView.subviews.count-4;
    NSInteger m = i - (tag - 1000);
    customerView.fHeight += 49;
    UIView *view = [self createCustomerTelphone:CGRectMake(0,98+n*49, customerView.fWidth, 49)];
    [view setTag:10+n];
    [customerView addSubview:view];
    
    for (int a = 1; a <= m; a++) {
        UIView *view = [_scrollView viewWithTag:tag+a];
        view.fY +=49;
    }
    _addCustomerView.fY +=49;
    _otherView.fY +=49;
    int height =  0;
    height += 49;
    _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);
    
    if (n >= 2) {
        button.enabled = NO;
    }
}
#pragma mark -删除电话号码
-(void)delTelephones:(UIButton *)button{
    UIView *customerV = button.superview.superview;
    NSUInteger n = customerV.subviews.count - 2;
    //当前view父view的tag
    NSInteger tag = customerV.tag;
    //根view的子view增加个数
    NSUInteger m = _scrollView.subviews.count - 4;
    NSInteger x = m - (tag - 1000);
    [button.superview removeFromSuperview];
    customerV.fHeight -=49;
    for (int a = 1; a <= x; a++) {
        UIView *cV = [_scrollView viewWithTag:tag+a];
        cV.fY -=49;
    }
    //当前view的tag
    NSInteger tagV = button.superview.tag;
    //遍历更改当前view下面的view的tag
    NSInteger s = n - (tagV - 10);
    for (int a=0; a<s; a++) {
        UIView *bView = [customerV viewWithTag:tagV+1+a];
        [bView setTag:tagV+a];
        bView.fY -=49;
    }
    _addCustomerView.fY -= 49;
    _otherView.fY -=49;
    if (n <= 3) {
        UIButton *addButton = [customerV viewWithTag:63];
        addButton.enabled = YES;
    }
    int height =  0;
    height -= 49;
    _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);

}
#pragma mark -报备
-(void)report:(UIButton *)button{
    //楼盘ID
    NSString *projectId = _itemId;
    //楼盘名称
    NSString *projectName = _ItemName.text;
    if ([projectId isEqual:@""]||[projectName isEqual:@""]||[projectName isEqual:@"选择报备楼盘"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择楼盘"];
        return;
    }
    //客户姓名/客户电话
    NSInteger n = _scrollView.subviews.count - 3;
    if([_reportType isEqual:@"0"]){
        n = 1;
    }
    NSMutableArray *customerArrays = [NSMutableArray array];
    for (int i = 0; i<n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        UITextField *name = [[view viewWithTag:8] viewWithTag:60];
        UITextField *telphoneOne = [[view viewWithTag:9] viewWithTag:61];
        UITextField *telphoneTwo = [[view viewWithTag:10] viewWithTag:70];
        UITextField *telphoneThree = [[view viewWithTag:11] viewWithTag:70];
        UITextField *telphoneFour = [[view viewWithTag:12] viewWithTag:70];
        if ([name isEqual:@""]) {
            [SVProgressHUD showInfoWithStatus:@"请填写客户姓名"];
            return;
        }
        if(telphoneOne.text.length != 11){
            [SVProgressHUD showInfoWithStatus:@"客户电话格式不正确"];
            return;
        }
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[@"name"] = name.text;
        dictionary[@"missContacto"] = telphoneOne.text;
        dictionary[@"missContacttw"] = telphoneTwo.text;
        dictionary[@"missContactth"] = telphoneThree.text;
        dictionary[@"missContactf"] = telphoneFour.text;
        [customerArrays addObject:dictionary];
    }
    //预计上客时间
    NSString *boardingPlane = _loadTime.text;
    if ([boardingPlane isEqual:@"选择预计上客时间"]||[boardingPlane isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请选择预计上客时间"];
        return;
    }
    //出行人数
    NSString *partPersonNum = _peopleSum.text;
    if ([partPersonNum isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"出行人数不能为空"];
        return;
    }
    //用餐人数
    NSString *lunchNum = _eatPeople.text;
    //出发城市
    NSString *departureCity = _setOutCity.text;
    if ([departureCity isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"出发城市不能为空"];
        return;
    }
    NSString *partWay = [NSString stringWithFormat:@"%ld",(long)_tags];
    if ([partWay isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请选择到达方式"];
        return;
    }
    //参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *userId = [ user objectForKey:@"userId"];
    _uuid = uuid;
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    order[@"projectName"] = projectName;
    order[@"projectId"] = projectId;
    order[@"appUserId"] = userId;
    order[@"boardingPlane"] = boardingPlane;
    order[@"departureCity"] = departureCity;
    order[@"partPersonNum"] = partPersonNum;
    order[@"partWay"] = partWay;
    order[@"lunchNum"] = lunchNum;
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"order"] = order;
    paraments[@"list"] = customerArrays;
    _paraments = paraments;
    
    //添加遮罩
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"添加中"];
    
    //延迟请求数据
    [self performSelector:@selector(loadData) withObject:self afterDelay:0.5];
    
}
-(void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:_uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/order/order",HTTPURL];
    [mgr POST:url  parameters:_paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            WZReportSuccessController *successVC = [[WZReportSuccessController alloc] init];
            successVC.reportData = data;
            successVC.status = _sginStatu;
            successVC.telphone = _dutyTelphone;
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:successVC];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
#pragma mark -预计上客时间
-(void)loadTimeButton:(UIButton *)button{
    [self findSubView:self.view];
    if ([_ItemName.text isEqual:@"选择报备楼盘"]||[_ItemName.text isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择楼盘"];
        return;
    }
    if ([_itemId isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择楼盘"];
        return;
    }
    if (_timeArray.count==0) {
        [SVProgressHUD showInfoWithStatus:@"上客时间为空"];
        return;
    }
    WZPickerView *picker1 = [[WZPickerView alloc] init];
    picker1.array = _timeArray;
    picker1.title = @"上客时间";
    [picker1 show];
    picker1.pickerBlock = ^(NSDictionary *names) {
        NSString *time = [names valueForKey:@"name"];
        if (![time isEqual:@""]) {
            _loadTime.text = time;
            _loadTime.textColor = UIColorRBG(51, 51, 51);
        }
        
    };
    
}
#pragma mark -到达方式
-(void)modeButton:(UIButton *)button{
    for (int i = 0; i<3; i++) {
        if (button.tag == 20+i) {
            button.selected = YES;
            _tags = button.tag;
            continue;
        }
        UIButton *but = (UIButton *)[self.view viewWithTag:20+i];
        but.selected = NO;
    }
}

#pragma mark -点击键盘return收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _scrollView.contentSize=CGSizeMake(0,  _otherView.fY+_otherView.fHeight+20);
    return YES;
}
#pragma mark -获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    _scrollView.contentSize=CGSizeMake(0, _otherView.fY+_otherView.fHeight+220);
}
#pragma mark -文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     NSInteger n = _scrollView.subviews.count - 3;
    for (int i = 0; i<n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        UITextField *telphoneOne = [[view viewWithTag:9] viewWithTag:61];
        UITextField *telphoneTwo = [[view viewWithTag:10] viewWithTag:70];
        UITextField *telphoneThree = [[view viewWithTag:11] viewWithTag:70];
        UITextField *telphoneFour = [[view viewWithTag:12] viewWithTag:70];
        if (telphoneOne == textField ||telphoneTwo == textField||telphoneThree == textField||telphoneFour == textField) {
            if (toBeString.length>11) {
                return NO;
            }
        }
    }
    if (toBeString.length>15) {
        return NO;
    }
    return YES;
}
#pragma mark -失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger n = _scrollView.subviews.count - 3;
    for (int i = 0; i<n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        UITextField *telphoneOne = [[view viewWithTag:9] viewWithTag:61];
        UITextField *telphoneTwo = [[view viewWithTag:10] viewWithTag:70];
        UITextField *telphoneThree = [[view viewWithTag:11] viewWithTag:70];
        UITextField *telphoneFour = [[view viewWithTag:12] viewWithTag:70];
        if (telphoneOne == textField ||telphoneTwo == textField||telphoneThree == textField||telphoneFour == textField) {
            NSString *telphone = textField.text;
            if (telphone.length == 11) {
                if ([_orderTelFlag isEqual:@"0"]) {
                    textField.text = [NSString stringWithFormat:@"%@****%@",[telphone substringToIndex:3],[telphone substringFromIndex:7]];
                }
            }
        }
    }
}
#pragma mark-显示导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self findSubView:self.view];
}
-(void)findSubView:(UIView*)view
{
    _scrollView.contentSize=CGSizeMake(0,  _otherView.fY+_otherView.fHeight+20);
    for (id object in [view subviews]) {
        if ([object isKindOfClass:[UIView class]]) {
            UIView * view = (UIView *)object;
            [self findSubView:view];
        }
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField * view = (UITextField *)object;
            [view resignFirstResponder];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
