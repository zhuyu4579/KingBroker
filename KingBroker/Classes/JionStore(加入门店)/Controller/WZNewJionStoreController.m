//
//  WZNewJionStoreController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//


#import <Masonry.h>
#import "GKCover.h"
#import "WZAlertView.h"
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "ZDMapController.h"
#import "WZTabBarController.h"
#import "WZExamineController.h"
#import "WZNavigationController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"

@interface WZNewJionStoreController()<UITextFieldDelegate,UIScrollViewDelegate>
//滑动页面
@property(nonatomic,strong)UIScrollView *scrollView;
//导航栏view
@property(nonatomic,strong)UIView *tabView;
@property(nonatomic,strong)UIView *ineView;
@property(nonatomic,strong)UILabel *Bartitle;
//文字一
@property(nonatomic,strong)UILabel *labelOne;
//文字二
@property(nonatomic,strong)UILabel *labelTwo;
//第一个view
@property(nonatomic,strong)UIView *viewOne;
//第二个view
@property(nonatomic,strong)UIView *viewTwo;
//第三个view
@property(nonatomic,strong)UIView *viewThree;
//经纪人按钮
@property(nonatomic,strong)UIButton *agentButton;
@property(nonatomic,strong)UIView *ineAgent;
//门店负责人按钮
@property(nonatomic,strong)UIButton *headButton;
@property(nonatomic,strong)UIView *ineHead;
//名字
@property(nonatomic,strong)UITextField *name;
//提交按钮
@property(nonatomic,strong)UIButton *button;
//有编码无编码
@property(nonatomic,strong)NSString *codeType;
//有编码无编码背景
@property(nonatomic,strong)UIImageView *codeImageView;
//有编码按钮
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UIView *ineCode;
//无编码按钮
@property(nonatomic,strong)UIButton *noCodeButton;
@property(nonatomic,strong)UIView *ineNoCode;
//有编码模块
@property(nonatomic,strong)UIView *codeViews;
//无编码模块
@property(nonatomic,strong)UIView *noCodeViews;
//有编码-编码
@property(nonatomic,strong)UITextField *code;
//有编码名片正面
@property(nonatomic,strong)UIImage *cardImages;
//有编码名片反面
@property(nonatomic,strong)UIImage *cardSideImages;
//有编码-邀请码
@property(nonatomic,strong)UITextField *inviteCode;
//无编码-门店名称
@property(nonatomic,strong)UITextField *storeName;
//无编码-门店位置
@property(nonatomic,strong)UILabel *storePosition;
@property(nonatomic,strong)NSString *lnglat;
@property(nonatomic,strong)NSString *adCode;
//无编码-门店地址
@property(nonatomic,strong)UITextField *storeAddress;
//无编码名片正面
@property(nonatomic,strong)UIImage *cardImage;
//无编码名片反面
@property(nonatomic,strong)UIImage *cardSideImage;
//无编码-邀请码
@property(nonatomic,strong)UITextField *inviteNOCode;
//门店负责人-门店名称
@property(nonatomic,strong)UITextField *headStoreName;
//门店负责人-门店位置
@property(nonatomic,strong)UILabel  *headStorePosition;
@property(nonatomic,strong)NSString *headLnglat;
@property(nonatomic,strong)NSString *headAdCode;
//门店负责人-门店地址
@property(nonatomic,strong)UITextField *headStoreAddress;
//门店负责人名片正面
@property(nonatomic,strong)UIImage *headCardImage;
//门店负责人营业执照
@property(nonatomic,strong)UIImage *headStoreImage;
//门店负责人-邀请码
@property(nonatomic,strong)UITextField *inviteHeadCode;
@end

@implementation WZNewJionStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    _codeType = @"0";
    //创建控件
    [self createControl];
}
#pragma mark - 创建控件
-(void)createControl{
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    //创建UISrceenView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-JF_BOTTOM_SPACE-49)];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    //设置导航条
    UIView *tabView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kApplicationStatusBarHeight+44)];
    tabView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    self.tabView = tabView;
    [self.view addSubview:tabView];
    //创建背景图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_background"];
    [imageView sizeToFit];
    [_scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left);
        make.top.equalTo(_scrollView.mas_top).offset(-kApplicationStatusBarHeight);
        make.width.offset(self.view.fWidth);
        make.height.offset(304*n);
    }];
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15,kApplicationStatusBarHeight+14, 15, 15)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setEnlargeEdge:44];
    [tabView addSubview:closeButton];
    
    UIView *ine = [[UIView alloc] initWithFrame:CGRectMake(0, self.tabView.fHeight, self.tabView.fWidth, 1)];
    ine.backgroundColor =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
    self.ineView = ine;
    [self.tabView addSubview:ine];
    
    UILabel *titles= [[UILabel alloc] init];
    titles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    titles.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:0];
    titles.text = @"加入门店";
    self.Bartitle = titles;
    [tabView addSubview:titles];
    [titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tabView.mas_centerX);
        make.top.equalTo(self.tabView.mas_top).mas_offset(kApplicationStatusBarHeight+14);
        make.height.offset(17);
        
    }];
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight+30,200, 18)];
    title.text = @"加入门店";
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    title.textColor = UIColorRBG(255, 168, 66);
    [_scrollView addSubview:title];
    
    //文字一
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"1.门店编码是经喜APP合作门店的唯一标识，你可咨询你的店长或者同事";
    labelOne.numberOfLines = 2;
    labelOne.textColor = UIColorRBG(159, 129, 79);
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _labelOne = labelOne;
    [_scrollView addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(title.mas_bottom).offset(13);
        make.width.offset(210*n);
    }];
    //文字二
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"2.加入门店后报备客户，成交后可赚取佣金；APP内做任 务赚取现金奖励";
    labelTwo.numberOfLines = 2;
    labelTwo.textColor = UIColorRBG(159, 129, 79);
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _labelTwo = labelTwo;
    [_scrollView addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(labelOne.mas_bottom).offset(9);
        make.width.offset(210*n);
    }];
    //创建名字
    [self createName];
    //创建按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = UIColorRBG(255, 204, 0);
    _button = button;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(JF_BOTTOM_SPACE+49);
        make.width.offset(self.view.fWidth);
    }];
    if ([_jionType isEqual:@"1"]) {
        [button setTitle:@"加入门店" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(jionStore:) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(0,740);
    }else{
        //门店负责人
        [button setTitle:@"提交审核" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(storeHeads:) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(0,_viewThree.fHeight+kApplicationStatusBarHeight+_viewThree.fY);
    }
}

#pragma mark -创建名字
-(void)createName{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(13, kApplicationStatusBarHeight+160, self.view.fWidth-26, 139)];
    _viewOne = view;
    [_scrollView addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_background_2"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.height.offset(139);
        make.width.offset(self.view.fWidth-26);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(view.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //经纪人
    UIButton *agentButton = [[UIButton alloc] init];
    [agentButton setTitle:@"经纪人" forState:UIControlStateNormal];
    [agentButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    agentButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [agentButton addTarget:self action:@selector(agentButton:) forControlEvents:UIControlEventTouchUpInside];
    _agentButton = agentButton;
    [view addSubview:agentButton];
    [agentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    //划线
    UIView *ineAgent = [[UIView alloc] init];
    ineAgent.backgroundColor = [UIColor clearColor];
    _ineAgent = ineAgent;
    [view addSubview:ineAgent];
    [ineAgent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(17);
        make.top.equalTo(agentButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    //门店负责人
    UIButton *headButton = [[UIButton alloc] init];
    [headButton setTitle:@"门店负责人" forState:UIControlStateNormal];
    [headButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    headButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [headButton addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
    _headButton = headButton;
    [view addSubview:headButton];
    [headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agentButton.mas_right).offset(40);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(80);
    }];
    //划线
    UIView *ineHead = [[UIView alloc] init];
    ineHead.backgroundColor = [UIColor clearColor];
    _ineHead = ineHead;
    [view addSubview:ineHead];
    [ineHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agentButton.mas_right).offset(40);
        make.top.equalTo(headButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(80);
    }];
    //经纪人模块
    [self agrentView];
    //门店负责人模块
    [self headView];
    if ([_jionType isEqual:@"1"]) {
        [agentButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineAgent.backgroundColor = UIColorRBG(255, 204, 0);
        [_viewThree setHidden:YES];
        [_viewTwo setHidden:NO];
    }else{
        [headButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineHead.backgroundColor = UIColorRBG(255, 204, 0);
        [_viewTwo setHidden:YES];
        [_viewThree setHidden:NO];
    }
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"名字";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(ine.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *name = [[UITextField alloc] init];
    name.placeholder = @"填写个人姓名";
    name.textColor = UIColorRBG(68, 68, 68);
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    name.delegate = self;
    name.keyboardType = UIKeyboardTypeDefault;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _name = name;
    [view addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(name.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    
}
#pragma mark -经纪人模块
-(void)agrentView{
    UIView *view = [[UIView alloc] init];
    _viewTwo = view;
    [_scrollView addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([_codeType isEqual:@"0"]) {
        imageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 139);
        imageView.image = [UIImage imageNamed:@"rz_background_3"];
    }else{
        imageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 286);
        imageView.image = [UIImage imageNamed:@"rz_wbm_pic_2"];
    }
    _codeImageView = imageView;
    [view addSubview:imageView];
    
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(view.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //有编码
    UIButton *codeButton = [[UIButton alloc] init];
    [codeButton setTitle:@"有编码" forState:UIControlStateNormal];
    [codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [codeButton addTarget:self action:@selector(codeButton:) forControlEvents:UIControlEventTouchUpInside];
    _codeButton = codeButton;
    [view addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    //划线
    UIView *ineCode = [[UIView alloc] init];
    ineCode.backgroundColor = [UIColor clearColor];
    _ineCode = ineCode;
    [view addSubview:ineCode];
    [ineCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(codeButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    //无编码
    UIButton *noCodeButton = [[UIButton alloc] init];
    [noCodeButton setTitle:@"无编码" forState:UIControlStateNormal];
    [noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    noCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [noCodeButton addTarget:self action:@selector(noCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    _noCodeButton = noCodeButton;
    [view addSubview:noCodeButton];
    [noCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeButton.mas_right).offset(40);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    //划线
    UIView *ineNoCode = [[UIView alloc] init];
    ineNoCode.backgroundColor = [UIColor clearColor];
    _ineNoCode = ineNoCode;
    [view addSubview:ineNoCode];
    [ineNoCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeButton.mas_right).offset(40);
        make.top.equalTo(noCodeButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    [self codeView];
    [self noCodeView];
    if ([_codeType isEqual:@"0"]) {
        [noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        ineNoCode.backgroundColor = [UIColor clearColor];
        [codeButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineCode.backgroundColor = UIColorRBG(255, 204, 0);
        [_codeViews setHidden:NO];
        [_noCodeViews setHidden:YES];
    }else{
        [codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        ineCode.backgroundColor = [UIColor clearColor];
        [noCodeButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineNoCode.backgroundColor = UIColorRBG(255, 204, 0);
        [_codeViews setHidden:YES];
        [_noCodeViews setHidden:NO];
    }
}
#pragma mark -门店负责人模块
-(void)headView{
    UIView *view = [[UIView alloc] init];
    _viewThree = view;
    [_scrollView addSubview:view];
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"rz_mdfzr_pic_2"];
    [view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(self.view.fWidth-26);
        make.height.offset(240);
    }];
    //门店名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"门店名称";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *headStoreName = [[UITextField alloc] init];
    headStoreName.placeholder = @"必填";
    headStoreName.textColor = UIColorRBG(68, 68, 68);
    headStoreName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    headStoreName.delegate = self;
    headStoreName.keyboardType = UIKeyboardTypeDefault;
    headStoreName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _headStoreName = headStoreName;
    [view addSubview:headStoreName];
    [headStoreName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(headStoreName.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    //门店位置
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = @"门店位置";
    positionLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    positionLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameIne.mas_top).offset(15);
        make.height.offset(13);
    }];
    UILabel *headStorePosition = [[UILabel alloc] init];
    headStorePosition.text = @"点击选择";
    headStorePosition.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    headStorePosition.textColor = UIColorRBG(204, 204, 204);
    _headStorePosition = headStorePosition;
    [view addSubview:headStorePosition];
    [headStorePosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom).offset(18);
        make.height.offset(13);
        make.width.offset(273);
    }];
    //下划线
    UIView  *positionIne = [[UIView alloc] init];
    positionIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:positionIne];
    [positionIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(headStorePosition.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-97);
    }];
    UIImageView *poImage = [[UIImageView alloc] init];
    poImage.image = [UIImage imageNamed:@"zc_map"];
    [view addSubview:poImage];
    [poImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headStorePosition.mas_right).offset(14);
        make.top.equalTo(positionLabel.mas_bottom).offset(11);
        make.height.offset(26);
        make.width.offset(20);
    }];
    UIButton *position = [[UIButton alloc] init];
    [position addTarget:self action:@selector(headPositionButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:position];
    [position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *positionInes = [[UIView alloc] init];
    positionInes.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:positionInes];
    [positionInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headStorePosition.mas_right).offset(14);
        make.top.equalTo(poImage.mas_bottom).offset(9);
        make.height.offset(1);
        make.width.offset(21);
    }];
    //门店地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"门店地址";
    addressLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    addressLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionIne.mas_bottom).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeAddress = [[UITextField alloc] init];
    storeAddress.placeholder = @"必填";
    storeAddress.textColor = UIColorRBG(68, 68, 68);
    storeAddress.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeAddress.delegate = self;
    storeAddress.keyboardType = UIKeyboardTypeDefault;
    storeAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    _headStoreAddress = storeAddress;
    [view addSubview:storeAddress];
    [storeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(addressLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *addressIne = [[UIView alloc] init];
    addressIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:addressIne];
    [addressIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeAddress.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    UIImageView *imageViews = [[UIImageView alloc] init];
    imageViews.image = [UIImage imageNamed:@"rz_wbm_pic_3"];
    [view addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(imageview.mas_bottom).offset(10);
        make.height.offset(183);
        make.width.offset(self.view.fWidth-26);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(imageViews.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //名片
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"上传相关证件";
    cardLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    cardLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(imageview.mas_bottom).offset(25);
        make.height.offset(16);
    }];
    //名片正面
    UIButton *cardButton = [[UIButton alloc] init];
    [cardButton setBackgroundImage:[UIImage imageNamed:@"camera_zm"] forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(headCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardButton];
    [cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_centerX).offset(-36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    //营业执照
    UIButton *cardSideButton = [[UIButton alloc] init];
    [cardSideButton setBackgroundImage:[UIImage imageNamed:@"camera_yyzz"] forState:UIControlStateNormal];
    [cardSideButton addTarget:self action:@selector(cardStoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardSideButton];
    [cardSideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).offset(36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    
//    UIView *inviteView = [[UIView alloc] init];
//    inviteView.backgroundColor = [UIColor whiteColor];
//    inviteView.layer.cornerRadius = 5.0;
//    inviteView.layer.shadowColor = UIColorRBG(60, 48, 0).CGColor;
//    inviteView.layer.shadowOpacity = 0.05;
//    inviteView.layer.shadowRadius = 10.0;
//    [view addSubview:inviteView];
//    [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left);
//        make.top.equalTo(imageViews.mas_bottom).offset(10);
//        make.width.offset(self.view.fWidth-26);
//        make.height.offset(50);
//    }];
//    UILabel *inviteLabel = [[UILabel alloc] init];
//    inviteLabel.text = @"邀请码";
//    inviteLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    inviteLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    [inviteView addSubview:inviteLabel];
//    [inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inviteView.mas_left).offset(15);
//        make.centerY.equalTo(inviteView.mas_centerY);
//        make.height.offset(13);
//    }];
//    UITextField *inviteCode = [[UITextField alloc] init];
//    inviteCode.placeholder = @"输入邀请码";
//    inviteCode.textColor = UIColorRBG(68, 68, 68);
//    inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    inviteCode.delegate = self;
//    inviteCode.keyboardType = UIKeyboardTypeNumberPad;
//    inviteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _inviteHeadCode = inviteCode;
//    [inviteView addSubview:inviteCode];
//    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inviteLabel.mas_right).offset(36);
//        make.centerY.equalTo(inviteView.mas_centerY);
//        make.right.equalTo(inviteView.mas_right);
//        make.height.offset(50);
//    }];
}
#pragma mark -有编码模块
-(void)codeView{
    UIView *view = [[UIView alloc] init];
    _codeViews = view;
    [_viewTwo addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewTwo.mas_left);
        make.top.equalTo(_ineCode.mas_bottom);
        make.height.offset(353);
        make.width.offset(self.view.fWidth-26);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"门店编码";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *code = [[UITextField alloc] init];
    code.placeholder = @"填写门店编码";
    code.textColor = UIColorRBG(68, 68, 68);
    code.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    code.delegate = self;
    code.keyboardType = UIKeyboardTypeNumberPad;
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    _code = code;
    [view addSubview:code];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(code.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_wbm_pic_3"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(_codeImageView.mas_bottom).offset(10);
        make.height.offset(183);
        make.width.offset(self.view.fWidth-26);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(imageView.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //名片
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"上传名片";
    cardLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    cardLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(_codeImageView.mas_bottom).offset(25);
        make.height.offset(16);
    }];
    UILabel *cardLabels = [[UILabel alloc] init];
    cardLabels.text = @"（上传名片正面和反面可获得现金红包）";
    cardLabels.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    cardLabels.textColor = UIColorRBG(204, 204, 204);
    [view addSubview:cardLabels];
    [cardLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardLabel.mas_right).offset(12);
        make.top.equalTo(_codeImageView.mas_bottom).offset(28);
        make.height.offset(13);
    }];
    //名片正面
    UIButton *cardButton = [[UIButton alloc] init];
    [cardButton setBackgroundImage:[UIImage imageNamed:@"camera_zm"] forState:UIControlStateNormal];
    cardButton.tag = 155;
    [cardButton addTarget:self action:@selector(cardButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardButton];
    [cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_centerX).offset(-36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    //名片反面
    UIButton *cardSideButton = [[UIButton alloc] init];
    [cardSideButton setBackgroundImage:[UIImage imageNamed:@"camera_fm"] forState:UIControlStateNormal];
    cardSideButton.tag = 156;
    [cardSideButton addTarget:self action:@selector(cardSideButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardSideButton];
    [cardSideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).offset(36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    UILabel *titleLabelThree = [[UILabel alloc] init];
    titleLabelThree.text = @"";
    titleLabelThree.textColor = UIColorRBG(153, 153, 153);
    titleLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    NSString *strs = @"3.请上传名片正反面照片，拍摄时确保各项信息清晰可见，亮度均匀，易于识别\n4.照片必须真实拍摄，不得使用复印件和扫描件";
    NSMutableAttributedString *attributedString =  [self changeSomeText:@"清晰可见，亮度均匀，易于识别" inText:strs withColor:UIColorRBG(255, 108, 0)];
    titleLabelThree.attributedText = attributedString;
    titleLabelThree.numberOfLines = 0;
    [view addSubview:titleLabelThree];
    [titleLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(2);
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.width.offset(self.view.fWidth-30);
    }];
    
//    UIView *inviteView = [[UIView alloc] init];
//    inviteView.backgroundColor = [UIColor whiteColor];
//    inviteView.layer.cornerRadius = 5.0;
//    inviteView.layer.shadowColor = UIColorRBG(60, 48, 0).CGColor;
//    inviteView.layer.shadowOpacity = 0.05;
//    inviteView.layer.shadowRadius = 10.0;
//    [view addSubview:inviteView];
//    [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left);
//        make.top.equalTo(titleLabelThree.mas_bottom).offset(18);
//        make.width.offset(self.view.fWidth-26);
//        make.height.offset(50);
//    }];
//    UILabel *inviteLabel = [[UILabel alloc] init];
//    inviteLabel.text = @"邀请码";
//    inviteLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    inviteLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    [inviteView addSubview:inviteLabel];
//    [inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inviteView.mas_left).offset(15);
//        make.centerY.equalTo(inviteView.mas_centerY);
//        make.height.offset(13);
//    }];
//    UITextField *inviteCode = [[UITextField alloc] init];
//    inviteCode.placeholder = @"输入邀请码";
//    inviteCode.textColor = UIColorRBG(68, 68, 68);
//    inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    inviteCode.delegate = self;
//    inviteCode.keyboardType = UIKeyboardTypeNumberPad;
//    inviteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _inviteCode = inviteCode;
//    [inviteView addSubview:inviteCode];
//    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inviteLabel.mas_right).offset(36);
//        make.centerY.equalTo(inviteView.mas_centerY);
//        make.right.equalTo(inviteView.mas_right);
//        make.height.offset(50);
//    }];
}
#pragma mark -无编码模块
-(void)noCodeView{
    UIView *view = [[UIView alloc] init];
    _noCodeViews = view;
    [_viewTwo addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewTwo.mas_left);
        make.top.equalTo(_ineCode.mas_bottom);
        make.height.offset(430);
        make.width.offset(self.view.fWidth-26);
    }];
    //门店名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"门店名称";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeName = [[UITextField alloc] init];
    storeName.placeholder = @"必填";
    storeName.textColor = UIColorRBG(68, 68, 68);
    storeName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeName.delegate = self;
    storeName.keyboardType = UIKeyboardTypeDefault;
    storeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _storeName = storeName;
    [view addSubview:storeName];
    [storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeName.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    //门店位置
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = @"门店位置";
    positionLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    positionLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameIne.mas_top).offset(15);
        make.height.offset(13);
    }];
    UILabel *storePosition = [[UILabel alloc] init];
    storePosition.text = @"点击选择";
    storePosition.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storePosition.textColor = UIColorRBG(204, 204, 204);
    _storePosition = storePosition;
    [view addSubview:storePosition];
    [storePosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom).offset(18);
        make.height.offset(13);
        make.width.offset(273);
    }];
    //下划线
    UIView  *positionIne = [[UIView alloc] init];
    positionIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:positionIne];
    [positionIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storePosition.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-97);
    }];
    UIImageView *poImage = [[UIImageView alloc] init];
    poImage.image = [UIImage imageNamed:@"zc_map"];
    [view addSubview:poImage];
    [poImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storePosition.mas_right).offset(14);
        make.top.equalTo(positionLabel.mas_bottom).offset(11);
        make.height.offset(26);
        make.width.offset(20);
    }];
    UIButton *position = [[UIButton alloc] init];
    [position addTarget:self action:@selector(positionButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:position];
    [position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *positionInes = [[UIView alloc] init];
    positionInes.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:positionInes];
    [positionInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storePosition.mas_right).offset(14);
        make.top.equalTo(poImage.mas_bottom).offset(9);
        make.height.offset(1);
        make.width.offset(21);
    }];
    //门店地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"门店地址";
    addressLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    addressLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionIne.mas_bottom).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeAddress = [[UITextField alloc] init];
    storeAddress.placeholder = @"必填";
    storeAddress.textColor = UIColorRBG(68, 68, 68);
    storeAddress.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeAddress.delegate = self;
    storeAddress.keyboardType = UIKeyboardTypeDefault;
    storeAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    _storeAddress = storeAddress;
    [view addSubview:storeAddress];
    [storeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(addressLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *addressIne = [[UIView alloc] init];
    addressIne.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:addressIne];
    [addressIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeAddress.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_wbm_pic_3"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(_codeImageView.mas_bottom).offset(10);
        make.height.offset(183);
        make.width.offset(self.view.fWidth-26);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(imageView.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //名片
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"上传名片";
    cardLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    cardLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(_codeImageView.mas_bottom).offset(25);
        make.height.offset(16);
    }];
    //名片正面
    UIButton *cardButton = [[UIButton alloc] init];
    [cardButton setBackgroundImage:[UIImage imageNamed:@"camera_zm"] forState:UIControlStateNormal];
    cardButton.tag = 150;
    [cardButton addTarget:self action:@selector(cardButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardButton];
    [cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_centerX).offset(-36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    //名片反面
    UIButton *cardSideButton = [[UIButton alloc] init];
    [cardSideButton setBackgroundImage:[UIImage imageNamed:@"camera_fm"] forState:UIControlStateNormal];
    cardSideButton.tag = 151;
    [cardSideButton addTarget:self action:@selector(cardSideButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardSideButton];
    [cardSideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).offset(36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    
//    UIView *inviteView = [[UIView alloc] init];
//    inviteView.backgroundColor = [UIColor whiteColor];
//    inviteView.layer.cornerRadius = 5.0;
//    inviteView.layer.shadowColor = UIColorRBG(60, 48, 0).CGColor;
//    inviteView.layer.shadowOpacity = 0.05;
//    inviteView.layer.shadowRadius = 10.0;
//    [view addSubview:inviteView];
//    [inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left);
//        make.top.equalTo(imageView.mas_bottom).offset(10);
//        make.width.offset(self.view.fWidth-26);
//        make.height.offset(50);
//    }];
//    UILabel *inviteLabel = [[UILabel alloc] init];
//    inviteLabel.text = @"邀请码";
//    inviteLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    inviteLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    [inviteView addSubview:inviteLabel];
//    [inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inviteView.mas_left).offset(15);
//        make.centerY.equalTo(inviteView.mas_centerY);
//        make.height.offset(13);
//    }];
//    UITextField *inviteCode = [[UITextField alloc] init];
//    inviteCode.placeholder = @"输入邀请码";
//    inviteCode.textColor = UIColorRBG(68, 68, 68);
//    inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//    inviteCode.delegate = self;
//    inviteCode.keyboardType = UIKeyboardTypeNumberPad;
//    inviteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _inviteNOCode = inviteCode;
//    [inviteView addSubview:inviteCode];
//    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(inviteLabel.mas_right).offset(36);
//        make.centerY.equalTo(inviteView.mas_centerY);
//        make.right.equalTo(inviteView.mas_right);
//        make.height.offset(50);
//    }];
}
#pragma mark -设置滑动值
-(void)viewDidLayoutSubviews{
    _viewOne.frame = CGRectMake(13, kApplicationStatusBarHeight+160, self.view.fWidth-26, 139);
    _viewTwo.frame = CGRectMake(13, _viewOne.fY+_viewOne.fHeight+10, self.view.fWidth-26, 476);
    _viewThree.frame = CGRectMake(13, _viewOne.fY+_viewOne.fHeight+10, self.view.fWidth-26, 430);
}
#pragma mark -经纪人按钮
-(void)agentButton:(UIButton *)button{
    [self touches];
    [_headButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineHead.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineAgent.backgroundColor = UIColorRBG(255, 204, 0);
    [_viewThree setHidden:YES];
    [_viewTwo setHidden:NO];
    if([_codeType isEqual:@"0"]){
        [_button setTitle:@"加入门店" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(jionStore:) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(0,_viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY-76);
        //设置文字
        _labelOne.attributedText = [[NSAttributedString alloc] initWithString:@"1.门店编码是经喜APP合作门店的唯一标识，你可咨询你的店长或者同事"];
        _labelTwo.text = @"2.加入门店后报备客户，成交后可赚取佣金；APP内做任 务赚取现金奖励";
    }else{
        [_button setTitle:@"提交审核" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(jionStoreNoCode:) forControlEvents:UIControlEventTouchUpInside];
        _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY);
        //设置文字
        NSString *strs = @"1.上传名片正反面照片，拍摄时确保名片边缘完整，字体清晰，亮度均匀";
        NSMutableAttributedString *attributedString =  [self changeSomeText:@"边缘完整，字体清晰，亮度均匀" inText:strs withColor:UIColorRBG(255, 168, 66)];
        _labelOne.text = @"";
        _labelOne.attributedText = attributedString;
        _labelTwo.text = @"2.照片必须真实拍摄，不得使用复印件和扫描件";
    }
}
#pragma mark -门店负责人按钮
-(void)headButton:(UIButton *)button{
    [self touches];
    [_agentButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineAgent.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineHead.backgroundColor = UIColorRBG(255, 204, 0);
    [_viewThree setHidden:NO];
    [_viewTwo setHidden:YES];
    //设置文字
    NSString *strs = @"1.上传名片正反面照片，拍摄时确保名片边缘完整，字体清晰，亮度均匀";
    NSMutableAttributedString *attributedString =  [self changeSomeText:@"边缘完整，字体清晰，亮度均匀" inText:strs withColor:UIColorRBG(255, 168, 66)];
    _labelOne.text = @"";
    _labelOne.attributedText = attributedString;
    _labelTwo.text = @"2.照片必须真实拍摄，不得使用复印件和扫描件";
    [_button setTitle:@"提交审核" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(storeHeads:) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView.contentSize = CGSizeMake(0,_viewThree.fHeight+kApplicationStatusBarHeight+_viewThree.fY);
}
#pragma mark -有编码按钮
-(void)codeButton:(UIButton *)button{
    [self touches];
    [_noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineNoCode.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineCode.backgroundColor = UIColorRBG(255, 204, 0);
    _codeImageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 139);
    _codeImageView.image = [UIImage imageNamed:@"rz_background_3"];
    _codeType = @"0";
    [_codeViews setHidden:NO];
    [_noCodeViews setHidden:YES];
    //设置文字
    _labelOne.attributedText = [[NSAttributedString alloc] initWithString:@"1.门店编码是经喜APP合作门店的唯一标识，你可咨询你的店长或者同事"];
    _labelTwo.text = @"2.加入门店后报备客户，成交后可赚取佣金；APP内做任 务赚取现金奖励";
    [_button setTitle:@"加入门店" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(jionStore:) forControlEvents:UIControlEventTouchUpInside];
    _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY-76);
}
#pragma mark -无编码按钮
-(void)noCodeButton:(UIButton *)button{
    [self touches];
    [_codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineCode.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineNoCode.backgroundColor = UIColorRBG(255, 204, 0);
    _codeImageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 286);
    _codeImageView.image = [UIImage imageNamed:@"rz_wbm_pic_2"];
    _codeType = @"1";
    [_codeViews setHidden:YES];
    [_noCodeViews setHidden:NO];
    //设置文字
    NSString *strs = @"1.上传名片正反面照片，拍摄时确保名片边缘完整，字体清晰，亮度均匀";
    NSMutableAttributedString *attributedString =  [self changeSomeText:@"边缘完整，字体清晰，亮度均匀" inText:strs withColor:UIColorRBG(255, 168, 66)];
    _labelOne.text = @"";
    _labelOne.attributedText = attributedString;
    _labelTwo.text = @"2.照片必须真实拍摄，不得使用复印件和扫描件";
    
    [_button setTitle:@"提交审核" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(jionStoreNoCode:) forControlEvents:UIControlEventTouchUpInside];
    _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY);
    
}
#pragma mark -无编码-选择位置
-(void)positionButton:(UIButton *)button{
    [self touches];
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _storePosition.textColor = UIColorRBG(51, 51, 51);
        _storePosition.text = [address valueForKey:@"address"];
        _lnglat = [address valueForKey:@"lnglat"];
        _adCode = [address valueForKey:@"adcode"];
    };
}
#pragma mark -无编码-名片正面
-(void)cardButton:(UIButton *)button{
    [self touches];
    NSInteger tag = button.tag;
    
    WZAlertView *redView = [WZAlertView new];
    
    redView.imageName = @"card_2";
    
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        if (tag == 155) {
            _cardImages = image;
        }else{
            _cardImage = image;
        }
        
    };
}
#pragma mark -无编码-名片反面
-(void)cardSideButton:(UIButton *)button{
    [self touches];
    NSInteger tag = button.tag;
    WZAlertView *redView = [WZAlertView new];
    
    redView.imageName = @"card_1";
    
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        if (tag == 156) {
            _cardSideImages = image;
        }else{
            _cardSideImage = image;
        }
        
    };
}
#pragma mark -门店负责人-选择位置
-(void)headPositionButton:(UIButton *)button{
    [self touches];
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _headStorePosition.textColor = UIColorRBG(51, 51, 51);
        _headStorePosition.text = [address valueForKey:@"address"];
        _headLnglat = [address valueForKey:@"lnglat"];
        _headAdCode = [address valueForKey:@"adcode"];
    };
}
#pragma mark -门店负责人-名片正面
-(void)headCardButton:(UIButton *)button{
    [self touches];
    WZAlertView *redView = [WZAlertView new];
    
    redView.imageName = @"card_2";
    
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        _headCardImage = image;
    };
}
#pragma mark -门店负责人-营业执照
-(void)cardStoreButton:(UIButton *)button{
    [self touches];
    WZAlertView *redView = [WZAlertView new];
    
    redView.imageName = @"rz_pic";
    
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        _headStoreImage = image;
    };
}
//滑动触发事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y - 5;
    
    [self setNeedsStatusBarAppearanceUpdate];
    if(self.scrollView.contentOffset.y >= 5){
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        self.Bartitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 1 - ((64 - offsetY) / 64)];
        
    }else{
        self.tabView.backgroundColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        self.ineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0];
        self.Bartitle.textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha: 0];
        
    }
}
#pragma mark -关闭页面
-(void)closeButton{
    if([_types isEqual:@"1"]){
        //跳转至我的页面
        WZTabBarController *tar = [[WZTabBarController alloc] init];
        tar.selectedViewController = [tar.viewControllers objectAtIndex:2];
        [self.navigationController presentViewController:tar animated:YES completion:nil];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark -加入门店-有编码提交
-(void)jionStore:(UIButton *)button{
    NSString *name = _name.text;
    if ([name isEqual:@""]||!name) {
        [SVProgressHUD showInfoWithStatus:@"名字不能为空"];
        return;
    }
    NSString *code = _code.text;
    if ([code isEqual:@""]||!code) {
        [SVProgressHUD showInfoWithStatus:@"门店编码不能为空"];
        return;
    }
    
//    CGImageRef cgref = [_cardImages CGImage];
//    CIImage *cim = [_cardImages CIImage];
//    CGImageRef cgrefs = [_cardSideImages CGImage];
//    CIImage *cims = [_cardSideImages CIImage];
    
//    if ((cgref != NULL && cim != nil)||(cgrefs != NULL && cims != nil)) {
//        if ((cgref != NULL && cim != nil)&&(cgrefs != NULL && cims != nil)) {
//
//        }else{
//            [SVProgressHUD showInfoWithStatus:@"请上传完整"];
//            return;
//        }
//    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"realname"] = name;
    paraments[@"storeCode"] = code;
    paraments[@"type"] = @"1";
//    paraments[@"parentPhone"] = _inviteCode.text;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/companyAuthentication",HTTPURL];
    button.enabled = NO;
    [mgr POST:url parameters:paraments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        CGImageRef cgref = [_cardImages CGImage];
        CIImage *cim = [_cardImages CIImage];
        if (cgref != NULL && cim != nil) {
            NSData *imageData = [WZAlertView imageProcessWithImage:_cardImages];//进行图片压缩
            // 使用日期生成图片名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            // 任意的二进制数据MIMEType application/octet-stream
            [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        }
        
        CGImageRef cgrefs = [_cardSideImages CGImage];
        CIImage *cims = [_cardSideImages CIImage];
        if (cgrefs != NULL && cims != nil) {
            NSData *imageData1 = [WZAlertView imageProcessWithImage:_cardSideImages];//进行图片压缩
            // 使用日期生成图片名称
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            formatter1.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName1 = [NSString stringWithFormat:@"%@.png",[formatter1 stringFromDate:[NSDate date]]];
            // 任意的二进制数据MIMEType application/octet-stream
            [formData appendPartWithFileData:imageData1 name:@"opposite" fileName:fileName1 mimeType:@"image/png"];
        }
       
        
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"你已加入门店，请在系统消息里领取你的新人专属现金红包"];
            NSDictionary *data = [responseObject valueForKey:@"data"];
            //保存数据
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //认证状态
            [defaults setObject:[data valueForKey:@"status"] forKey:@"realtorStatus"];
            //门店名称
            [defaults setObject:[data valueForKey:@"storeName"] forKey:@"storeName"];
            //门店编码
            [defaults setObject:[data valueForKey:@"storeCode"] forKey:@"storeCode"];
            //门店位置
            [defaults setObject:[data valueForKey:@"cityName"] forKey:@"cityName"];
            //门店地址
            [defaults setObject:[data valueForKey:@"addr"] forKey:@"addr"];
            [defaults synchronize];
            
            if ([_types isEqual:@"1"]) {
                //跳转至我的页面
                WZTabBarController *tar = [[WZTabBarController alloc] init];
                tar.selectedViewController = [tar.viewControllers objectAtIndex:2];
                [self.navigationController presentViewController:tar animated:YES completion:nil];
            }else{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
//            if (cgref != NULL && cim != nil&&cgrefs != NULL && cims != nil) {
//                //审核页面
//                WZExamineController *exVc = [[WZExamineController alloc] init];
//                exVc.titleLabel = @"资料上传成功，审核通过后，你可在系统\n消息里领取你的新人专属现金红包，耐心等待审核...";
//                WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:exVc];
//                [self.navigationController presentViewController:nav animated:YES completion:nil];
//            }else{
            
           // }
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        button.enabled = YES;
        if (error.code == -1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
}
#pragma mark -加入门店-无编码提交
-(void)jionStoreNoCode:(UIButton *)button{
    NSString *name = _name.text;
    if ([name isEqual:@""]||!name) {
        [SVProgressHUD showInfoWithStatus:@"名字不能为空"];
        return;
    }
    NSString *storeName = _storeName.text;
    if ([storeName isEqual:@""]||!storeName) {
        [SVProgressHUD showInfoWithStatus:@"门店名称不能为空"];
        return;
    }
    if ([_adCode isEqual:@""]||!_adCode) {
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    if ([_lnglat isEqual:@""]||!_lnglat) {
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    NSString *address = _storeAddress.text;
    if ([address isEqual:@""]||!address) {
        [SVProgressHUD showInfoWithStatus:@"门店地址不能为空"];
        return;
    }
    CGImageRef cgref = [_cardImage CGImage];
    CIImage *cim = [_cardImage CIImage];
    if (cgref == NULL && cim == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传名片正面照片"];
        return;
    }
    CGImageRef cgrefs = [_cardSideImage CGImage];
    CIImage *cims = [_cardSideImage CIImage];
    if (cgrefs == NULL && cims == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传名片反面照片"];
        return;
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    
    //创建会话
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    parament[@"realname"] = name;
    parament[@"address"] = address;
    parament[@"storeName"] = storeName;
    parament[@"lnglat"] = _lnglat;
    parament[@"adCode"] = _adCode;
    parament[@"type"] = @"1";
//    parament[@"parentPhone"] = _inviteNOCode.text;
    NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/cardAuthentication",HTTPURL];
    button.enabled = NO;
    [mgr POST:url parameters:parament constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = [WZAlertView imageProcessWithImage:_cardImage];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        NSData *imageData1 = [WZAlertView imageProcessWithImage:_cardSideImage];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName1 = [NSString stringWithFormat:@"%@.png",[formatter1 stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData1 name:@"opposite" fileName:fileName1 mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        [SVProgressHUD dismiss];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            //保存审核状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"realtorStatus"];
            [defaults synchronize];
            //审核页面
            WZExamineController *exVc = [[WZExamineController alloc] init];
            exVc.titleLabel = @"资料上传成功，审核通过后，你可在系统\n消息里领取你的新人专属现金红包，耐心等待审核...";
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:exVc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        button.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
#pragma mark -门店负责人-提交
-(void)storeHeads:(UIButton *)button{
    NSString *name = _name.text;
    if ([name isEqual:@""]||!name) {
        [SVProgressHUD showInfoWithStatus:@"名字不能为空"];
        return;
    }
    NSString *storeName = _headStoreName.text;
    if ([storeName isEqual:@""]||!storeName) {
        [SVProgressHUD showInfoWithStatus:@"门店名称不能为空"];
        return;
    }
    if ([_headAdCode isEqual:@""]||!_headAdCode) {
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    if ([_headLnglat isEqual:@""]||!_headLnglat) {
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    NSString *address = _headStoreAddress.text;
    if ([address isEqual:@""]||!address) {
        [SVProgressHUD showInfoWithStatus:@"门店地址不能为空"];
        return;
    }
    CGImageRef cgref = [_headCardImage CGImage];
    CIImage *cim = [_headCardImage CIImage];
    if (cgref == NULL && cim == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传名片照片"];
        return;
    }
    CGImageRef cgrefs = [_headStoreImage CGImage];
    CIImage *cims = [_headStoreImage CIImage];
    if (cgrefs == NULL && cims == nil) {
        [SVProgressHUD showInfoWithStatus:@"请上传营业执照照片"];
        return;
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    
    //创建会话
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    parament[@"realname"] = name;
    parament[@"address"] = address;
    parament[@"storeName"] = storeName;
    parament[@"lnglat"] = _headLnglat;
    parament[@"adCode"] = _headAdCode;
    parament[@"type"] = @"1";
//    parament[@"parentPhone"] = _inviteHeadCode.text;
    NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/dutyAuthentication",HTTPURL];
    button.enabled = NO;
    [mgr POST:url parameters:parament constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = [WZAlertView imageProcessWithImage:_headCardImage];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        NSData *imageData1 = [WZAlertView imageProcessWithImage:_headStoreImage];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName1 = [NSString stringWithFormat:@"%@.png",[formatter1 stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData1 name:@"opposite" fileName:fileName1 mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        [SVProgressHUD dismiss];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            //保存审核状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"realtorStatus"];
            [defaults synchronize];
            //审核页面
            WZExamineController *exVc = [[WZExamineController alloc] init];
            exVc.titleLabel = @"资料上传成功，审核通过后，你可在系统\n消息里领取你的新人专属现金红包，耐心等待审核...";
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:exVc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        button.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    
    _scrollView.contentSize = CGSizeMake(0, _scrollView.contentSize.height+200);
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    _scrollView.contentSize = CGSizeMake(0, _scrollView.contentSize.height-200);
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_name == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    if (_inviteCode == textField||_inviteHeadCode == textField||_inviteNOCode == textField) {
        if (toBeString.length>11) {
            return NO;
        }
    }
    if (_code == textField) {
        if (toBeString.length>15) {
            return NO;
        }
    }
    if (toBeString.length>20) {
        return NO;
    }
    return YES;
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_code resignFirstResponder];
    [_storeName resignFirstResponder];
    [_inviteCode resignFirstResponder];
    [_inviteNOCode resignFirstResponder];
    [_inviteHeadCode resignFirstResponder];
    [_storeAddress resignFirstResponder];
    [_headStoreName resignFirstResponder];
    [_headStoreAddress resignFirstResponder];
}
-(void)touches{
    [_name resignFirstResponder];
    [_code resignFirstResponder];
    [_inviteCode resignFirstResponder];
    [_storeName resignFirstResponder];
    [_inviteNOCode resignFirstResponder];
    [_inviteHeadCode resignFirstResponder];
    [_storeAddress resignFirstResponder];
    [_headStoreName resignFirstResponder];
    [_headStoreAddress resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSMutableAttributedString *)changeSomeText:(NSString *)str inText:(NSString *)result withColor:(UIColor *)color {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:result];
    NSRange colorRange = NSMakeRange([[attributeStr string] rangeOfString:str].location,[[attributeStr string] rangeOfString:str].length);
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    
    return attributeStr;
}

@end

