//
//  WZBatchReport.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZBatchReport.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "GKCover.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZReportSuccessController.h"
#import "WZPickerView.h"
#import "UIViewController+WZFindController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "WZSelectProjectsController.h"
@interface WZBatchReport ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UIView *telephoneView;
//第一个view
@property (nonatomic, strong)UIView *viewOne;

@property (nonatomic, strong)UIButton *addTelephone;

@property (nonatomic, strong)UIView *diyHideView;

//第三个view
@property (nonatomic, strong)UIView *viewThree;
@property (nonatomic, strong)UIView *viewFour;

@property (nonatomic, strong)UILabel *loadTime;
//出发城市
@property (nonatomic, strong)UITextField *setOutCity;
//用餐人数
@property (nonatomic, strong)UITextField *eatPeople;
//出行人数
@property (nonatomic, strong)UITextField *peopleSum;
//时间数组
@property (nonatomic, strong)NSArray *timeArray;
//出行方式
@property(nonatomic,assign)NSInteger tags;
//默认客户信息view
@property (nonatomic, strong)UIView *viewTwo;
@property (nonatomic, strong)UIView *customerView;
//增加客户按钮的view
@property (nonatomic, strong)UIView *addCustomerView;
//请求数据
@property(nonatomic,strong)NSString *uuid;

@property(nonatomic,strong)NSDictionary *paraments;
@end

@implementation WZBatchReport

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    _tags = 20;
    //创建控件
    [self foundController];
}
#pragma mark -创建控件
-(void)foundController{
    //创建一个UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(self.view.fX, self.view.fY, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight - 93-JF_BOTTOM_SPACE);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.delegate =self;
    
    //创建第一个view
    _viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
    _viewOne.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_viewOne];
    //创建第一个view中的lable
    UILabel *itemNameLabel = [[UILabel alloc] init];
    itemNameLabel.text = @"项 目 名：";
    itemNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    itemNameLabel.textColor = UIColorRBG(153, 153, 153);
    [_viewOne addSubview:itemNameLabel];
    [itemNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewOne.mas_left).with.offset(15);
        make.top.equalTo(_viewOne.mas_top).with.offset(15);
        make.height.mas_offset(14);
    }];
    
    UILabel *itemName = [[UILabel alloc] init];
    _ItemName = itemName;
    itemName.text = @"请选择";
    itemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    itemName.textColor = UIColorRBG(68, 68, 68);
    [_viewOne addSubview:itemName];
    [itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemNameLabel.mas_right).with.offset(0);
        make.top.equalTo(_viewOne.mas_top).with.offset(15);
        make.height.mas_offset(15);
    }];
    //点击按钮选择项目
    UIButton *titemNameButton = [[UIButton alloc] init];
    [titemNameButton setEnlargeEdge:44];
    [titemNameButton setBackgroundImage:[UIImage imageNamed:@"more_unfold"] forState:UIControlStateNormal];
    [titemNameButton addTarget:self action:@selector(itemNameButton) forControlEvents:UIControlEventTouchUpInside];
    _titemNameButton = titemNameButton;
    [_viewOne addSubview:titemNameButton];
    [titemNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_viewOne.mas_right).with.offset(-15);
        make.top.equalTo(_viewOne.mas_top).with.offset(15);
        make.height.mas_offset(15);
        make.width.mas_offset(9);
    }];
    
    //默认可以添加一个客户
     UIView *viewTwo =  [self addCustomer:56 type:@"0"];
     [viewTwo setTag:1000];
     [scrollView addSubview:viewTwo];
     self.viewTwo = viewTwo;
    
     //创建增加客户按钮的view
     UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, 147, SCREEN_WIDTH, 65)];
     addView.backgroundColor = UIColorRBG(242, 242, 242);
    [scrollView addSubview:addView];
    self.addCustomerView = addView;
    //创建增加客户按钮
    UIButton *addCustomerButton = [[UIButton alloc] init];
    [addCustomerButton setImage:[UIImage imageNamed:@"addition"] forState:UIControlStateNormal];
    [addCustomerButton setTitle:@"添加客户" forState: UIControlStateNormal];
    [addCustomerButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    addCustomerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    addCustomerButton.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    addCustomerButton.layer.borderWidth = 1;
    addCustomerButton.layer.cornerRadius = 4.0;
    addCustomerButton.layer.masksToBounds = YES;
    [addCustomerButton addTarget:self action:@selector(addCustomerButton) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addCustomerButton];
    [addCustomerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addView.mas_centerX).mas_offset(0);
        make.top.equalTo(addView.mas_top).mas_offset(20);
        make.height.mas_offset(24);
        make.width.mas_offset(83);
    }];
    //确认按钮
    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确认报备" forState: UIControlStateNormal];
    [confirmButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
    confirmButton.backgroundColor = UIColorRBG(3, 133, 219);
    [confirmButton addTarget:self action:@selector(confrimButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49+JF_BOTTOM_SPACE);
    }];
    
    
    //创建自定义的view
    _viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, 212, SCREEN_WIDTH, 181)];
    _viewThree.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:_viewThree];
    //创建上客时间
    UILabel *loadTimeLabel = [[UILabel alloc] init];
    loadTimeLabel.text = @"上客时间:";
    loadTimeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    loadTimeLabel.textColor = UIColorRBG(153, 153, 153);
    [_viewThree addSubview:loadTimeLabel];
    [loadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewThree).with.offset(15);
        make.top.equalTo(_viewThree.mas_top).with.offset(16);
        make.height.mas_offset(14);
    }];
    
    _loadTime = [[UILabel alloc] init];
    _loadTime.text = @"请选择";
    _loadTime.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _loadTime.textColor = UIColorRBG(68, 68, 68);
    [_viewThree addSubview:_loadTime];
    [_loadTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loadTimeLabel.mas_right).with.offset(10);
        make.top.equalTo(_viewThree.mas_top).with.offset(16);
        make.height.mas_offset(15);
    }];
    //点击按钮选择时间
    UIButton *loadTimeButton = [[UIButton alloc] init];
    [loadTimeButton setEnlargeEdge:44];
    [loadTimeButton setBackgroundImage:[UIImage imageNamed:@"icon_more_unfold"] forState:UIControlStateNormal];
    [loadTimeButton addTarget:self action:@selector(loadTimeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_viewThree addSubview:loadTimeButton];
    [loadTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_viewThree.mas_right).with.offset(-15);
        make.top.equalTo(_viewThree.mas_top).with.offset(15);
        make.height.mas_offset(15);
        make.width.mas_offset(9);
    }];
    //绘制线
    UIView *ineView3 = [[UIView alloc] initWithFrame: CGRectMake(15,45, _viewThree.fWidth-15, 1)];
    ineView3.backgroundColor =UIColorRBG(242, 242, 242);
    [_viewThree addSubview:ineView3];
    
    //创建第二个view中的text
    UILabel  *peopleSumLabel = [[UILabel alloc] init];
    peopleSumLabel.text = @"出行人数：";
    peopleSumLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    peopleSumLabel.textColor = UIColorRBG(153, 153, 153);
    [_viewThree addSubview:peopleSumLabel];
    [peopleSumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewThree.mas_left).with.offset(15);
        make.top.equalTo(ineView3.mas_bottom).with.offset(16);
        make.height.mas_offset(14);
    }];
    UITextField *peopleSum = [[UITextField alloc] init];
    peopleSum.placeholder = @"必填";
    peopleSum.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    peopleSum.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    peopleSum.keyboardType = UIKeyboardTypeNumberPad;
    peopleSum.delegate = self;
    _peopleSum = peopleSum;
    [_viewThree addSubview:peopleSum];
    [peopleSum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleSumLabel.mas_right).with.offset(0);
        make.top.equalTo(ineView3.mas_bottom).with.offset(0);
        make.height.mas_offset(45);
        make.width.mas_offset(250);
    }];
    //绘制线
    UIView *ineView4 = [[UIView alloc] initWithFrame: CGRectMake(15,91, _viewThree.fWidth-15, 1)];
    ineView4.backgroundColor =UIColorRBG(242, 242, 242);
    [_viewThree addSubview:ineView4];
    //创建第二个view中的用餐人数
    UILabel *eatPeopleLabel = [[UILabel alloc] init];
    eatPeopleLabel.text = @"用餐人数：";
    eatPeopleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    eatPeopleLabel.textColor = UIColorRBG(153, 153, 153);
    [_viewThree addSubview:eatPeopleLabel];
    [eatPeopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewThree.mas_left).with.offset(15);
        make.top.equalTo(ineView4.mas_bottom).with.offset(16);
        make.height.mas_offset(14);
    }];
    UITextField *eatPeople = [[UITextField alloc] init];
    eatPeople.placeholder = @"必填";
    eatPeople.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    eatPeople.textColor = UIColorRBG(68, 68, 68);
    eatPeople.delegate = self;
    //键盘设置
    eatPeople.keyboardType = UIKeyboardTypeNumberPad;
    _eatPeople = eatPeople;
    [_viewThree addSubview:eatPeople];
    [eatPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(eatPeopleLabel.mas_right).with.offset(0);
        make.top.equalTo(ineView4.mas_bottom).with.offset(0);
        make.height.mas_offset(45);
        make.width.mas_offset(250);
    }];
    
    //绘制线
    UIView *ineView5 = [[UIView alloc] initWithFrame: CGRectMake(15,137, _viewThree.fWidth-15, 1)];
    ineView5.backgroundColor =UIColorRBG(242, 242, 242);
    [_viewThree addSubview:ineView5];
    UILabel *setOutCityLabel = [[UILabel alloc] init];
    setOutCityLabel.text = @"出发城市：";
    setOutCityLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    setOutCityLabel.textColor = UIColorRBG(153, 153, 153);
    [_viewThree addSubview:setOutCityLabel];
    [setOutCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewThree.mas_left).with.offset(15);
        make.top.equalTo(ineView5.mas_bottom).with.offset(16);
        make.height.mas_offset(14);
    }];
    
    //创建第三个view中出发城市
    _setOutCity = [[UITextField alloc] init];
    _setOutCity.placeholder = @"必填";
    _setOutCity.delegate = self;
    _setOutCity.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _setOutCity.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    _setOutCity.keyboardType = UIKeyboardTypeDefault;
    [_viewThree addSubview:_setOutCity];
    [_setOutCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setOutCityLabel.mas_right).with.offset(0);
        make.top.equalTo(ineView5.mas_bottom).with.offset(0);
        make.width.mas_offset(250);
        make.height.mas_offset(45);
    }];
    
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, _viewThree.fHeight+_viewThree.fY+10, scrollView.fWidth, 46)];
    viewFour.backgroundColor = [UIColor whiteColor];
    _viewFour = viewFour;
    [scrollView addSubview:viewFour];
    
    UILabel *modeLable = [[UILabel alloc] init];
    modeLable.text = @"到达方式:";
    modeLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    modeLable.textColor = UIColorRBG(153, 153, 153);
    [viewFour addSubview:modeLable];
    [modeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewFour.mas_left).with.offset(15);
        make.top.equalTo(viewFour.mas_top).with.offset(16);
        make.height.mas_offset(14);
    }];
    //方式按钮
    UIButton *modeButtonOne = [[UIButton alloc] init];
    [modeButtonOne setEnlargeEdge:30];
    [modeButtonOne setBackgroundImage:[UIImage imageNamed:@"choose_2"] forState:UIControlStateNormal];
    [modeButtonOne setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    modeButtonOne.tag = 20;
    modeButtonOne.selected = YES;
    [modeButtonOne addTarget:self action:@selector(modeButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:modeButtonOne];
    [modeButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeLable.mas_right).with.offset(77);
        make.top.equalTo(viewFour.mas_top).with.offset(14);
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
        make.top.equalTo(viewFour.mas_top).with.offset(16);
        make.height.mas_offset(13);
    }];
    
    UIButton *modeButtonTwo = [[UIButton alloc] init];
    [modeButtonTwo setEnlargeEdge:30];
    [modeButtonTwo setBackgroundImage:[UIImage imageNamed:@"choose_2"] forState:UIControlStateNormal];
    [modeButtonTwo setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    modeButtonTwo.tag = 21;
    [modeButtonTwo addTarget:self action:@selector(modeButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:modeButtonTwo];
    [modeButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeButtonOne.mas_right).with.offset(58);
        make.top.equalTo(viewFour.mas_top).with.offset(14);
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
        make.top.equalTo(viewFour.mas_top).with.offset(16);
        make.height.mas_offset(13);
    }];
    
    UIButton *modeButtonThree = [[UIButton alloc] init];
    [modeButtonThree setEnlargeEdge:30];
    [modeButtonThree setBackgroundImage:[UIImage imageNamed:@"choose_2"] forState:UIControlStateNormal];
    [modeButtonThree setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    modeButtonThree.tag = 22;
    [modeButtonThree addTarget:self action:@selector(modeButton:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:modeButtonThree];
    [modeButtonThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modeTwo.mas_right).with.offset(24);
        make.top.equalTo(viewFour.mas_top).with.offset(14);
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
        make.top.equalTo(viewFour.mas_top).with.offset(16);
        make.height.mas_offset(13);
    }];
    
    scrollView.contentSize = CGSizeMake(0,self.view.fHeight);
    
}

//创建用户模版
-(UIView *)addCustomer:(CGFloat)viewY type:(NSString *)type{
    //创建总的view
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, self.view.fWidth, 91)];
     view.backgroundColor = [UIColor clearColor];
    //创建第一个客户姓名view
    UIView *customerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, 45)];
    [view addSubview:customerView];
    customerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *customNameLabel = [[UILabel alloc] init];
    customNameLabel.text = @"客户姓名：";
    customNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    customNameLabel.textColor = UIColorRBG(153, 153, 153);
    
    [customerView addSubview:customNameLabel];
    [customNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customerView.mas_left).with.offset(15);
        make.top.equalTo(customerView.mas_top).with.offset(16);
        make.height.mas_offset(14);
    }];
    //创建客户姓名的文本框
    UITextField *customerName = [[UITextField alloc] init];
    [customerView addSubview:customerName];
    customerName.placeholder = @"必填";
    customerName.tag = 59;
    customerName.delegate = self;
    customerName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    customerName.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    customerName.keyboardType = UIKeyboardTypeDefault;
    [customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customNameLabel.mas_right).with.offset(0);
        make.top.equalTo(customerView.mas_top).with.offset(0);
        make.height.mas_offset(45);
        make.width.mas_offset(200);
    }];
    //创建删除按钮
    UIButton *delButton = [[UIButton alloc] init];
    [delButton setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [delButton setEnlargeEdge:10];
    [customerView addSubview:delButton];
    if ([type isEqual:@"0"]) {
        delButton.enabled = NO;
        [delButton setHidden:YES];
    }else{
         delButton.enabled = YES;
         [delButton setHidden:NO];
    }
    [delButton addTarget:self action:@selector(deleteCustom:) forControlEvents:UIControlEventTouchUpInside];
    [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(customerView.mas_right).with.offset(-15);
        make.top.equalTo(customerView.mas_top).with.offset(20);
        make.height.mas_offset(4);
        make.width.mas_offset(18);
    }];
    
    UIButton *delete = [[UIButton alloc] init];
    [delete setBackgroundImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    delete.tag = 200;
    [delete setEnlargeEdgeWithTop:10 right:5 bottom:10 left:30];
    [customerView addSubview:delete];
    [delete setHidden:YES];
    [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [delete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(delButton.mas_left).with.offset(-15);
        make.top.equalTo(customerView.mas_top).with.offset(15);
        make.height.mas_offset(17);
        make.width.mas_offset(13);
    }];
    
    //创建电话的View
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, view.fWidth, 45)];
    phoneView.tag = 9;
    [view addSubview:phoneView];
    phoneView.backgroundColor = [UIColor whiteColor];
    //创建电话的label
    UILabel *tLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 14)];
    tLable.text = @"客户电话";
    tLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    tLable.textColor = UIColorRBG(153, 153, 153);
    [phoneView addSubview:tLable];
    //分割线
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(88, 0, 1, phoneView.fHeight)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [phoneView addSubview:ineView];
    //创建隐藏号码的view
    UIView *telephoneHideView = [[UIView alloc] initWithFrame: CGRectMake(89,0,250,phoneView.fHeight)];
    [phoneView addSubview:telephoneHideView];
    self.telephoneView = telephoneHideView;
    //添加文本框前部分
    UITextField *topText = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 44, telephoneHideView.fHeight)];
    topText.placeholder = @"前三位";
    topText.tag = 60;
    topText.delegate = self;
    topText.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    topText.textAlignment = NSTextAlignmentRight;
    topText.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    topText.keyboardType = UIKeyboardTypeNumberPad;
    [telephoneHideView addSubview:topText];
    UILabel *hideLable = [[UILabel alloc] initWithFrame:CGRectMake(59, 17, 31, 15)];
    hideLable.text = @"****";
    hideLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    hideLable.textColor = UIColorRBG(68, 68, 68);
    [telephoneHideView addSubview:hideLable];
   
    //添加文本框后部分
     UITextField *bottomText = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 44, telephoneHideView.fHeight)];
     bottomText.placeholder = @"后四位";
     bottomText.tag = 61;
     bottomText.delegate = self;
     bottomText.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
     bottomText.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
     bottomText.keyboardType = UIKeyboardTypeNumberPad;
     [telephoneHideView addSubview:bottomText];
    
    //创建增加号码按钮
    UIButton *addTelephone = [[UIButton alloc] initWithFrame:CGRectMake(phoneView.fWidth-30, 15, 15, 15)];
    [addTelephone setEnlargeEdge:44];
    [addTelephone setTag:90];
    [addTelephone setBackgroundImage:[UIImage imageNamed:@"add_2"] forState:UIControlStateNormal];
    [addTelephone addTarget:self action:@selector(addTelephones:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:addTelephone];

    return view;
}


#pragma mark -创建一个电话输入view
-(UIView *)addTelephoneView:(CGRect)rect{
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *tLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 14)];
    tLable.text = @"客户电话";
    tLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    tLable.textColor = UIColorRBG(153, 153, 153);
    [view addSubview:tLable];
    //绘制线
    UIView *ineViews= [[UIView alloc] initWithFrame:CGRectMake(89,0,1,45)];
    ineViews.backgroundColor =UIColorRBG(242, 242, 242);
    [view addSubview:ineViews];
    //创建隐藏号码的view
    _diyHideView = [[UIView alloc] initWithFrame: CGRectMake(90,0, 250,view.fHeight)];
    _diyHideView.backgroundColor = [UIColor whiteColor];
    [view addSubview:_diyHideView];
    
    //添加文本框前部分
    UITextField   *topF = [[UITextField alloc] init];
    topF.placeholder = @"前三位";
    topF.delegate = self;
    topF.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    topF.textAlignment = NSTextAlignmentRight;
    topF.textColor = UIColorRBG(68, 68, 68);
    topF.tag = 70;
    //键盘设置
    topF.keyboardType = UIKeyboardTypePhonePad;
    [_diyHideView addSubview:topF];
    [topF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_diyHideView.mas_left).with.offset(15);
        make.top.equalTo(_diyHideView.mas_top);
        make.height.equalTo(_diyHideView.mas_height);
        make.width.mas_offset(44);
    }];
    UILabel *hideLable = [[UILabel alloc] init];
    hideLable.text = @"****";
    hideLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    hideLable.textColor = UIColorRBG(68, 68, 68);
    [_diyHideView addSubview:hideLable];
    [hideLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topF.mas_right);
        make.top.equalTo(_diyHideView.mas_top).with.offset(17);
        make.height.mas_offset(15);
    }];
    //添加文本框后部分
    UITextField  *bottomF = [[UITextField alloc] init];
    bottomF.placeholder = @"后四位";
    bottomF.delegate = self;
    bottomF.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    bottomF.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    bottomF.keyboardType = UIKeyboardTypePhonePad;
    bottomF.tag = 71;
    [_diyHideView addSubview:bottomF];
    [bottomF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hideLable.mas_right);
        make.top.equalTo(_diyHideView.mas_top);
        make.height.equalTo(_diyHideView.mas_height);
        make.width.mas_offset(44);
    }];
    //创建减少号码按钮
    UIButton *CleanTelephone = [[UIButton alloc] init];
    [CleanTelephone setEnlargeEdge:44];
    [CleanTelephone setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [CleanTelephone addTarget:self action:@selector(delTelephone:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:CleanTelephone];
    [CleanTelephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(-15);
        make.top.equalTo(view.mas_top).with.offset(15);
        make.height.mas_offset(15);
        make.width.mas_offset(15);
    }];
    
    return view;
}



-(void)addName:(NSNotification *)userInfo{
    
    if (userInfo) {
        NSMutableDictionary *dm = [userInfo valueForKey:@"userInfo"];
        NSString *name =  [dm objectForKey:@"name"];
        NSString *telephone = [dm objectForKey:@"telephone"];
        _customerName.text = name;
        _topText.text = [telephone substringToIndex:3];
        _bottomText.text = [telephone substringFromIndex:7];
    }
    
}
#pragma mark -选择项目
-(void)itemNameButton{
    //跳转选择项目列表
    WZSelectProjectsController *projectVC = [[WZSelectProjectsController alloc] init];
    UIViewController *Vc = [UIViewController viewController:self.view.superview];
    projectVC.projectBlock = ^(NSDictionary *dicty) {
        _itemId = [dicty valueForKey:@"projectId"];
        _ItemName.text = [dicty valueForKey:@"projectName"];
        _sginStatu = [dicty valueForKey:@"signStatus"];
        _telphone = [dicty valueForKey:@"telphone"];
        //请求数据
        [self loadTimeData];
    };
    [Vc.navigationController pushViewController:projectVC animated:YES];
}
#pragma mark -预计上客时间
-(void)loadTimeButton:(UIButton *)button{
    [self findSubView:self.view];
    if ([_ItemName.text isEqual:@"请选择"]) {
        [SVProgressHUD showInfoWithStatus:@"请先选择项目"];
        return;
    }
    if (!_itemId) {
        [SVProgressHUD showInfoWithStatus:@"请先选择项目"];
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
        _loadTime.text = [names valueForKey:@"name"];
    };
  
    
}
//确认添加数据请求
-(void)loadTimeData{
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 30;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _itemId;
        NSString *url = [NSString stringWithFormat:@"%@/proProject/planBoardingDate",URL];
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
//增加客户
-(void)addCustomerButton{
    //默认有一个 从第一个下面开始添加
    NSUInteger n = _scrollView.subviews.count-6;
    _addCustomerView.fY += 96;
    _viewThree.fY +=96;
    _viewFour.fY +=96;
    UIView *customerView = [self addCustomer:_addCustomerView.fY-91 type:@"1"];
    [customerView setTag:1000 + n];
    _customerView = customerView;
    [_scrollView addSubview:customerView];
    int height =  0;
    height += 96;
    _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);
    
}
//删除客户
-(void)deleteCustom:(UIButton *)button{
    UIButton *del = [button.superview viewWithTag:200];
    button.selected = !button.selected;
    if (button.selected) {
        [del setHidden:NO];
    }else{
        [del setHidden:YES];
    }
   
}
//删除客户
-(void)delete:(UIButton *)button{
    NSInteger tag = button.superview.superview.tag;
    
    NSUInteger n = _scrollView.subviews.count-7;
    
    UIView *view = button.superview.superview;
    NSInteger h = view.frame.size.height;
    NSInteger m = n - (tag-1000);
    for (int i = 1; i<= m; i++) {
        UIView *view = [_scrollView viewWithTag:(tag+i)];
        [view setTag:(tag+i -1)];
        view.fY -= h+5;
    }
    [view removeFromSuperview];
    _addCustomerView.fY -= h+5;
    _viewThree.fY -= h+5;
    _viewFour.fY -= h+5;
    int height =  0;
    height -= h+5;
    _scrollView.contentSize = CGSizeMake(0, _scrollView.contentSize.height + height);
    
}
#pragma mark -增加手机号码
-(void)addTelephones:(UIButton *)button{
    UIView *customerV = button.superview.superview;
    NSUInteger n = customerV.subviews.count - 2;
    NSInteger tag = customerV.tag;
    NSInteger i = _scrollView.subviews.count-4;
    NSInteger m = i - (tag - 1000);
    customerV.fHeight += 46;
    UIView *view = [self addTelephoneView:CGRectMake(0,92+n*46, SCREEN_WIDTH, 45)];
    
    [view setTag:10+n];
    [customerV addSubview:view];
  
    for (int a = 1; a <= m; a++) {
        UIView *cV = [_scrollView viewWithTag:tag+a];
        cV.fY +=46;
    }
    
    _viewThree.fY +=46;
    _addCustomerView.fY += 46;
    _viewFour.fY +=46;
    int height =  0;
    height += 46;
    _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);
    if (n >= 2) {
        button.hidden = YES;
        button.enabled = NO;
    }
}
#pragma mark -删除手机号码
-(void)delTelephone:(UIButton *)button{
    
    UIView *customerV = button.superview.superview;
    NSUInteger n = customerV.subviews.count - 2;
    //当前view父view的tag
    NSInteger tag = customerV.tag;
    //根view的子view增加个数
    NSUInteger m = _scrollView.subviews.count - 4;
    NSInteger x = m - (tag - 1000);
    [button.superview removeFromSuperview];
    customerV.fHeight -=46;
    for (int a = 1; a <= x; a++) {
        UIView *cV = [_scrollView viewWithTag:tag+a];
        cV.fY -=46;
    }
   //当前view的tag
    NSInteger tagV = button.superview.tag;
    //遍历更改当前view下面的view的tag
    NSInteger s = n - (tagV - 10);
    for (int a=0; a<s; a++) {
        UIView *bView = [customerV viewWithTag:tagV+1+a];
        [bView setTag:tagV+a];
        bView.fY -=46;
    }
    _viewThree.fY -=46;
    _addCustomerView.fY -= 46;
    _viewFour.fY -=46;
    if (n <= 3) {
        UIButton *addButton = [customerV viewWithTag:90];
        addButton.hidden = NO;
        addButton.enabled = YES;
    }
    int height =  0;
    height -= 46;
    _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);

}

#pragma mark -获取项目名
-(void)getItemName:(NSNotification *)notification{
    
    NSMutableDictionary *item = [notification object];
    
    _ItemName.text = [item valueForKey:@"name"];
    _itemId = [item valueForKey:@"itemId"];
}
#pragma mark -确认添加
-(void)confrimButton{
    //项目名称
    NSString *projectName = _ItemName.text;
    if ([projectName isEqual:@"请选择"]||!projectName) {
        [SVProgressHUD showInfoWithStatus:@"项目名称未选择"];
        return;
    }
    //预计上客时间
    NSString *boardingPlane = _loadTime.text;
    if ([boardingPlane isEqual:@"请选择"]||!boardingPlane) {
        [SVProgressHUD showInfoWithStatus:@"上客时间未选择"];
        return;
    }
    //项目ID
    NSString *projectId = _itemId;
    //出发城市
    NSString *departureCity = _setOutCity.text;
    //出行人数
    NSString *partPersonNum = _peopleSum.text;
    //用餐人数
    NSString *lunch_flag = _eatPeople.text;
    NSString *partWay = [NSString stringWithFormat:@"%ld",(_tags-19)];
    if ([projectId isEqual:@""] || [departureCity isEqual:@""] || [partPersonNum isEqual:@""]|| [partWay isEqual:@""]||[lunch_flag isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写完整数据"];
        return;
    }
     NSInteger n = _scrollView.subviews.count - 6;
     NSMutableArray *phoneArrays = [NSMutableArray array];
    for (int i = 0; i< n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        //客户姓名
        UITextField *customerName = [view viewWithTag:59];
        NSString *name = customerName.text;
        
        if (!name) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"第%i个客户姓名为空！",(i+1)]];
            return;
        }
        //第一个号码
        UITextField *tops =  [[view viewWithTag:9] viewWithTag:60];
        UITextField *bots =  [[view viewWithTag:9] viewWithTag:61];
        NSString *topText = tops.text;
        NSString *bottomText = bots.text;
        if (topText.length != 3 || [topText isEqual:@""]||!topText) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"第%i个手机号码前三位为空！",(i+1)]];
            return;
        }
        if(bottomText.length != 4 || [bottomText isEqual:@""]||!bottomText){
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"第%i个手机号码后四位为空！",(i+1)]];
            return;
        }
        NSString *missContacto = [NSString stringWithFormat:@"%@****%@",topText,bottomText];
        
        //第二个号码
        UITextField *top =  [[view viewWithTag:10] viewWithTag:70];
        UITextField *bot =  [[view viewWithTag:10] viewWithTag:71];
        NSString *missContacttw = [NSString stringWithFormat:@"%@****%@",top.text,bot.text];
        if ([top.text isEqual:@""] || [bot.text isEqual:@""] ||!top||!bot) {
            missContacttw = @"";
        }
        //第三个号码
        UITextField *top1 =  [[view viewWithTag:11] viewWithTag:70];
        UITextField *bot1 =  [[view viewWithTag:11] viewWithTag:71];
        NSString *missContactth = [NSString stringWithFormat:@"%@****%@",top1.text,bot1.text];
        if ([top1.text isEqual:@""] || [bot1.text isEqual:@""] ||!top1||!bot1 ) {
            missContactth = @"";
        }
        //第四个号码
        UITextField *top2=  [[view viewWithTag:12] viewWithTag:70];
        UITextField *bot2 =  [[view viewWithTag:12] viewWithTag:71];
        NSString *missContactf = [NSString stringWithFormat:@"%@****%@",top2.text,bot2.text];
        if ([top2.text isEqual:@""] || [bot2.text isEqual:@""] ||!top2||!bot2 ) {
            missContactf = @"";
        }
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[@"name"] = name;
        dictionary[@"missContacto"] = missContacto;
        dictionary[@"missContacttw"] = missContacttw;
        dictionary[@"missContactth"] = missContactth;
        dictionary[@"missContactf"] = missContactf;
        [phoneArrays addObject:dictionary];
    }
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
    order[@"lunchNum"] = lunch_flag;
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"order"] = order;
    paraments[@"list"] = phoneArrays;
    _paraments = paraments;
    //添加遮罩
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"添加中"];
    
    [self performSelector:@selector(loadData) withObject:self afterDelay:1];
    
}
-(void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:_uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/order/order",URL];
    [mgr POST:url  parameters:_paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            WZReportSuccessController *successVC = [[WZReportSuccessController alloc] init];
            UIViewController *Vc = [UIViewController viewController:self.view.superview];
            successVC.reportData = data;
            successVC.status = _sginStatu;
            successVC.telphone = _telphone;
            [Vc.navigationController pushViewController:successVC animated:YES];
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

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.customerName resignFirstResponder];
    [self.topText resignFirstResponder];
    [self.bottomText resignFirstResponder];
    [_eatPeople resignFirstResponder];
    [self.setOutCity resignFirstResponder];
    [self.peopleSum resignFirstResponder];
    [self findSubView:self.view];
}
-(void)findSubView:(UIView*)view
{
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
//点击键盘return收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_peopleSum == textField || _eatPeople == textField) {
        if (toBeString.length>5) {
            return NO;
        }
    }
    if (toBeString.length>25) {
        return NO;
    }
    
    NSInteger n = _scrollView.subviews.count - 6;
    for (int i = 0; i< n; i++) {
        UIView *view = [_scrollView viewWithTag:(1000+i)];
        //第一个号码
        UITextField *tops =  [[view viewWithTag:9] viewWithTag:60];
        UITextField *bots =  [[view viewWithTag:9] viewWithTag:61];
        if (tops == textField) {
            if (toBeString.length>3) {
                [bots becomeFirstResponder];
                return NO;
            }
        }
        if (bots == textField) {
            if (toBeString.length>4) {
                return NO;
            }
        }
        //第二个号码
        UITextField *top =  [[view viewWithTag:10] viewWithTag:70];
        UITextField *bot =  [[view viewWithTag:10] viewWithTag:71];
        if (top == textField) {
            if (toBeString.length>3) {
                [bot becomeFirstResponder];
                return NO;
            }
        }
        if (bot == textField) {
            if (toBeString.length>4) {
                return NO;
            }
        }
        //第三个号码
        UITextField *top1 =  [[view viewWithTag:11] viewWithTag:70];
        UITextField *bot1 =  [[view viewWithTag:11] viewWithTag:71];
        if (top1 == textField) {
            if (toBeString.length>3) {
                [bot1 becomeFirstResponder];
                return NO;
            }
        }
        if (bot1 == textField) {
            if (toBeString.length>4) {
                return NO;
            }
        }
        //第四个号码
        UITextField *top2=  [[view viewWithTag:12] viewWithTag:70];
        UITextField *bot2 =  [[view viewWithTag:12] viewWithTag:71];
        if (top2 == textField) {
            if (toBeString.length>3) {
                [bot2 becomeFirstResponder];
                return NO;
            }
        }
        if (bot2 == textField) {
            if (toBeString.length>4) {
                return NO;
            }
        }
        
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//选择客户创建客户
-(void)selectCustorms:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    for (int i = 0; i<array.count; i++) {
        NSDictionary *data = array[i];
        NSUInteger n = _scrollView.subviews.count-6;
        _addCustomerView.fY += 96;
        _viewThree.fY +=96;
        _viewFour.fY +=96;
        UIView *customerView = [self addCustomer:_addCustomerView.fY-91 type:@"1"];
        [customerView setTag:1000 + n];
        _customerView = customerView;
        [_scrollView addSubview:customerView];
        
        int height =  0;
        height += 96;
        _scrollView.contentSize =  CGSizeMake(0, _scrollView.contentSize.height + height);
         UITextField *customerName = [customerView viewWithTag:59];
        customerName.text = [data valueForKey:@"name"];
         NSString *telphone = [data valueForKey:@"telphone"];
        UITextField *tops =  [[customerView viewWithTag:9] viewWithTag:60];
        UITextField *bots =  [[customerView viewWithTag:9] viewWithTag:61];
        tops.text = [telphone substringToIndex:3];
        bots.text = [telphone substringFromIndex:7];
    }
}


@end
