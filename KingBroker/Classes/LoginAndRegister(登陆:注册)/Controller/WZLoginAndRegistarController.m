//
//  WZLoginAndRegistarController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  登录/注册
#import <Masonry.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZNEWHTMLController.h"
#import "WZForgetPassWordController.h"
#import "WZRegistarSetPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZLoginAndRegistarController.h"
#import <CloudPushSDK/CloudPushSDK.h>
@interface WZLoginAndRegistarController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
//登录下划线
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIView *ineLogin;
//注册下划线
@property(nonatomic,strong)UIButton *registarButton;
@property(nonatomic,strong)UIView *ineRegistar;
//登录模块
@property(nonatomic,strong)UIView *loginView;
//注册模块
@property(nonatomic,strong)UIView *registarView;
//登录的用户名
@property(nonatomic,strong)UITextField *loginName;
//登录的密码
@property(nonatomic,strong)UITextField *loginPassWord;
//注册的用户名
@property(nonatomic,strong)UITextField *registarName;
//注册的验证码
@property(nonatomic,strong)UITextField *registarYZM;
//注册的邀请码
@property(nonatomic,strong)UITextField *inviteCode;
//注册-获取验证码
@property(nonatomic,strong)UIButton *YZMButton;
//注册-选中协议
@property(nonatomic,strong)UIButton *selectAgreement;
//定时器
@property(nonatomic,weak)NSTimer *timer;
@end

@implementation WZLoginAndRegistarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //创建控件
    [self createControl];
}
#pragma mark - 创建控件
-(void)createControl{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setEnlargeEdge:44];
    [_scrollView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(_scrollView.mas_top).mas_offset(22);
        make.height.offset(15);
        make.width.offset(15);
    }];
    //图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"logo"];
    [_scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView.mas_centerX);
        make.top.equalTo(_scrollView.mas_top).mas_offset(50);
        make.height.offset(109);
        make.width.offset(109);
    }];
    //登录/注册页签
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setEnlargeEdge:44];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    [loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    _loginButton = loginButton;
    [_scrollView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(59);
        make.top.equalTo(imageView.mas_bottom).mas_offset(32);
        make.height.offset(27);
        make.width.offset(35);
    }];
    //划线
    UIView *ineLogin = [[UIView alloc] init];
    ineLogin.backgroundColor = [UIColor clearColor];
    _ineLogin = ineLogin;
    [_scrollView addSubview:ineLogin];
    [ineLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(59);
        make.top.equalTo(loginButton.mas_bottom);
        make.height.offset(2);
        make.width.offset(35);
    }];
    //中间线
    UILabel *ines = [[UILabel alloc] init];
    ines.text = @"/";
    ines.textColor = UIColorRBG(153, 153, 153);
    [_scrollView addSubview:ines];
    [ines mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton.mas_right).offset(26);
        make.top.equalTo(imageView.mas_bottom).mas_offset(40);
        make.height.offset(9);
    }];
    //登录/注册页签
    UIButton *registarButton = [[UIButton alloc] init];
    [registarButton setEnlargeEdge:44];
    [registarButton setTitle:@"注册" forState:UIControlStateNormal];
    [registarButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    registarButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
     [registarButton addTarget:self action:@selector(registarButton:) forControlEvents:UIControlEventTouchUpInside];
    _registarButton = registarButton;
    [_scrollView addSubview:registarButton];
    [registarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ines.mas_right).offset(26);
        make.top.equalTo(imageView.mas_bottom).mas_offset(32);
        make.height.offset(27);
        make.width.offset(35);
    }];
    //划线
    UIView *ineRegistar = [[UIView alloc] init];
    ineRegistar.backgroundColor = [UIColor clearColor];
    _ineRegistar = ineRegistar;
    [_scrollView addSubview:ineRegistar];
    [ineRegistar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ines.mas_right).offset(26);
        make.top.equalTo(registarButton.mas_bottom);
        make.height.offset(2);
        make.width.offset(35);
    }];
    //登录
    [self login];
    //注册
    [self registar];
    if ([_type isEqual:@"0"]) {
        [loginButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineLogin.backgroundColor = UIColorRBG(255, 204, 0);
        [_loginView setHidden:NO];
        
    }else{
        [registarButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineRegistar.backgroundColor = UIColorRBG(255, 204, 0);
        [_registarView setHidden:NO];
        
    }
    _scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight);

}
#pragma mark -创建登录模块
-(void)login{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *oldName = [ user objectForKey:@"oldName"];
    UIView *loginView = [[UIView alloc] init];
    _loginView = loginView;
    [loginView setHidden:YES];
    [_scrollView addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left);
        make.top.equalTo(_ineLogin.mas_bottom);
        make.height.offset(300);
        make.width.offset(_scrollView.fWidth);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"用户名";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [loginView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(loginView.mas_top).offset(37);
        make.height.offset(12);
    }];
    UITextField *loginName = [[UITextField alloc] init];
    loginName.placeholder = @"请输入用户名";
    if (![oldName isEqual:@""] || oldName) {
        loginName.text = oldName;
    }
    loginName.textColor = UIColorRBG(49, 35, 6);
    loginName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    loginName.delegate = self;
    loginName.keyboardType = UIKeyboardTypeNumberPad;
    [[loginName valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    loginName.clearButtonMode = UITextFieldViewModeWhileEditing;
    loginName.clearsOnBeginEditing = NO;
    _loginName = loginName;
    [loginView addSubview:loginName];
    [loginName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(_scrollView.fWidth-107);
    }];
    //下划线
    UIView  *loginIne = [[UIView alloc] init];
    loginIne.backgroundColor = UIColorRBG(255, 245, 177);
    [loginView addSubview:loginIne];
    [loginIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(loginName.mas_bottom);
        make.height.offset(1);
        make.width.offset(_scrollView.fWidth-107);
    }];
    //密码
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"密码";
    passwordLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    passwordLabel.textColor = UIColorRBG(51, 51, 51);
    [loginView addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(loginIne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    UITextField *loginPassWord = [[UITextField alloc] init];
    loginPassWord.placeholder = @"请输入密码";
    loginPassWord.textColor = UIColorRBG(49, 35, 6);
    loginPassWord.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    loginPassWord.delegate = self;
    loginPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    [[loginPassWord valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    loginPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginPassWord setSecureTextEntry:YES];
    _loginPassWord = loginPassWord;
    [loginView addSubview:loginPassWord];
    [loginPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(passwordLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(_scrollView.fWidth-138);
    }];
    //下划线
    UIView  *loginInes = [[UIView alloc] init];
    loginInes.backgroundColor = UIColorRBG(255, 245, 177);
    [loginView addSubview:loginInes];
    [loginInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(loginPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(_scrollView.fWidth-138);
    }];
    //显示密码
    UIButton *showPw = [[UIButton alloc] init];
    [showPw setBackgroundImage:[UIImage imageNamed:@"zc_icon_2"] forState:UIControlStateNormal];
    [showPw setBackgroundImage:[UIImage imageNamed:@"zc_icon_1"] forState:UIControlStateSelected];
    [showPw addTarget:self action:@selector(showPw:) forControlEvents:UIControlEventTouchUpInside];
    [showPw setEnlargeEdgeWithTop:10 right:20 bottom:20 left:10];
    [loginView addSubview:showPw];
    [showPw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginPassWord.mas_right).offset(11);
        make.top.equalTo(passwordLabel.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    //下划线
    UIView  *showIne = [[UIView alloc] init];
    showIne.backgroundColor = UIColorRBG(255, 245, 177);
    [loginView addSubview:showIne];
    [showIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginInes.mas_right).offset(6);
        make.top.equalTo(loginPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [loginButton addTarget:self action:@selector(logins:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginView.mas_left).offset(57);
        make.top.equalTo(loginInes.mas_bottom).offset(60);
        make.height.offset(45);
        make.width.offset(109);
    }];
    //忘记密码
    UIButton *findPassWord = [[UIButton alloc] init];
    [findPassWord setTitle:@"忘记密码" forState:UIControlStateNormal];
    [findPassWord setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    findPassWord.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    [findPassWord addTarget:self action:@selector(forgetPw) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:findPassWord];
    [findPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton.mas_right).offset(16);
        make.top.equalTo(loginInes.mas_bottom).offset(72);
        make.height.offset(11);
    }];
    //下划线
    UIView  *findIne = [[UIView alloc] init];
    findIne.backgroundColor = UIColorRBG(255, 245, 177);
    [loginView addSubview:findIne];
    [findIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton.mas_right).offset(16);
        make.top.equalTo(findPassWord.mas_bottom).offset(3);
        make.height.offset(1);
        make.width.offset(43);
    }];
}

#pragma mark -创建注册模块
-(void)registar{
    UIView *registarView = [[UIView alloc] init];
    _registarView = registarView;
    [registarView setHidden:YES];
    [_scrollView addSubview:registarView];
    [registarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left);
        make.top.equalTo(_ineLogin.mas_bottom);
        make.height.offset(350);
        make.width.offset(_scrollView.fWidth);
    }];
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.text = @"手机号";
    telLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telLabel.textColor = UIColorRBG(51, 51, 51);
    [registarView addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(registarView.mas_top).offset(37);
        make.height.offset(12);
    }];
    UITextField *telphone = [[UITextField alloc] init];
    telphone.placeholder = @"请输入手机号";
    telphone.textColor = UIColorRBG(49, 35, 6);
    telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telphone.delegate = self;
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    [[telphone valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    telphone.clearButtonMode = UITextFieldViewModeWhileEditing;
    telphone.clearsOnBeginEditing = NO;
    _registarName = telphone;
    [registarView addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(telLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(_scrollView.fWidth-107);
    }];
    //下划线
    UIView  *registarIne = [[UIView alloc] init];
    registarIne.backgroundColor = UIColorRBG(255, 245, 177);
    [registarView addSubview:registarIne];
    [registarIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(_scrollView.fWidth-107);
    }];
    UILabel *YZMLabel = [[UILabel alloc] init];
    YZMLabel.text = @"验证码";
    YZMLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    YZMLabel.textColor = UIColorRBG(51, 51, 51);
    [registarView addSubview:YZMLabel];
    [YZMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(registarIne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    //验证码
    UITextField *registarYZM = [[UITextField alloc] init];
    registarYZM.placeholder = @"请输入验证码";
    registarYZM.textColor = UIColorRBG(49, 35, 6);
    registarYZM.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    registarYZM.delegate = self;
    registarYZM.keyboardType = UIKeyboardTypeNumberPad;
    [[registarYZM valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    registarYZM.clearButtonMode = UITextFieldViewModeWhileEditing;
    _registarYZM = registarYZM;
    [registarView addSubview:registarYZM];
    [registarYZM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(YZMLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(_scrollView.fWidth-205);
    }];
    //下划线
    UIView  *registarInes = [[UIView alloc] init];
    registarInes.backgroundColor = UIColorRBG(255, 245, 177);
    [registarView addSubview:registarInes];
    [registarInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(registarYZM.mas_bottom);
        make.height.offset(1);
        make.width.offset(_scrollView.fWidth-205);
    }];
    //获取验证码
    UIButton *findYZM = [[UIButton alloc] init];
    [findYZM setTitle:@"获取验证码" forState:UIControlStateNormal];
    [findYZM setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
    findYZM.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    findYZM.layer.cornerRadius = 12;
    findYZM.layer.masksToBounds = YES;
    findYZM.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
    findYZM.layer.borderWidth = 1.0;
    [findYZM addTarget:self action:@selector(findYZM:) forControlEvents:UIControlEventTouchUpInside];
    _YZMButton = findYZM;
    [registarView addSubview:findYZM];
    [findYZM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarYZM.mas_right).offset(18);
        make.top.equalTo(YZMLabel.mas_bottom).offset(13);
        make.height.offset(24);
        make.width.offset(80);
    }];
   
    //邀请码
    UILabel *inviteLabel = [[UILabel alloc] init];
    inviteLabel.text = @"邀请人";
    inviteLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    inviteLabel.textColor = UIColorRBG(51, 51, 51);
    [registarView addSubview:inviteLabel];
    [inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(registarInes.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    UILabel *inviteLabels = [[UILabel alloc] init];
    inviteLabels.text = @"(选填)";
    inviteLabels.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    inviteLabels.textColor = UIColorRBG(204, 204, 204);
    [registarView addSubview:inviteLabels];
    [inviteLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviteLabel.mas_right).offset(16);
        make.top.equalTo(registarInes.mas_bottom).offset(32);
        make.height.offset(12);
    }];
    UITextField *inviteCode = [[UITextField alloc] init];
    inviteCode.placeholder = @"请输入邀请码";
    inviteCode.textColor = UIColorRBG(49, 35, 6);
    inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    inviteCode.delegate = self;
    inviteCode.keyboardType = UIKeyboardTypeDefault;
    [[inviteCode valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    inviteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    inviteCode.clearsOnBeginEditing = NO;
    _inviteCode = inviteCode;
    [registarView addSubview:inviteCode];
    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(inviteLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(_scrollView.fWidth-107);
    }];
    //下划线
    UIView  *inviteIne = [[UIView alloc] init];
    inviteIne.backgroundColor = UIColorRBG(255, 245, 177);
    [registarView addSubview:inviteIne];
    [inviteIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(inviteCode.mas_bottom);
        make.height.offset(1);
        make.width.offset(_scrollView.fWidth-107);
    }];
    
    //同意协议按钮
    UIButton *selectAgreement = [[UIButton alloc] init];
    [selectAgreement setBackgroundImage:[UIImage imageNamed:@"ZC_YES_1"] forState:UIControlStateNormal];
    [selectAgreement setBackgroundImage:[UIImage imageNamed:@"ZC_YES"] forState:UIControlStateSelected];
    [selectAgreement addTarget:self action:@selector(selectAgreement:) forControlEvents:UIControlEventTouchUpInside];
    [selectAgreement setEnlargeEdgeWithTop:17 right:30 bottom:30 left:44];
    _selectAgreement = selectAgreement;
    [registarView addSubview:selectAgreement];
    [selectAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(58);
        make.top.equalTo(inviteIne.mas_bottom).offset(17);
        make.height.offset(14);
        make.width.offset(14);
    }];
    UILabel *aLabel = [[UILabel alloc] init];
    aLabel.text = @"我已同意";
    aLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    aLabel.textColor = UIColorRBG(199, 199, 205);
    [registarView addSubview:aLabel];
    [aLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAgreement.mas_right).offset(7);
        make.top.equalTo(inviteIne.mas_bottom).offset(19);
        make.height.offset(11);
    }];
    //查看协议
    UIButton *findAgreement = [[UIButton alloc] init];
    [findAgreement setTitle:@"《经喜用户服务协议》" forState:UIControlStateNormal];
    [findAgreement setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    findAgreement.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    [findAgreement addTarget:self action:@selector(findAgreement) forControlEvents:UIControlEventTouchUpInside];
    [registarView addSubview:findAgreement];
    [findAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(aLabel.mas_right);
        make.top.equalTo(inviteIne.mas_bottom).offset(14);
        make.height.offset(21);
        make.width.offset(110);
    }];
    //下一步
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [registarView addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarView.mas_left).offset(57);
        make.top.equalTo(findAgreement.mas_bottom).offset(30);
        make.height.offset(45);
        make.width.offset(109);
    }];
}
#pragma mark -点击切换登录模块
-(void)loginButton:(UIButton *)button{
    [self touches];
    [_registarButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineRegistar.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineLogin.backgroundColor = UIColorRBG(255, 204, 0);
    [_registarView setHidden:YES];
    [_loginView setHidden:NO];
   
}
#pragma mark -点击切换注册模块
-(void)registarButton:(UIButton *)button{
    [self touches];
    [_loginButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineLogin.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineRegistar.backgroundColor = UIColorRBG(255, 204, 0);
    [_loginView setHidden:YES];
    [_registarView setHidden:NO];
     
}
#pragma mark -登录-显示密码
-(void)showPw:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_loginPassWord setSecureTextEntry:YES];
    }else{
        [_loginPassWord setSecureTextEntry:NO];
    }
}
#pragma mark -登录-忘记密码
-(void)forgetPw{
    [self touches];
    WZForgetPassWordController *fPW = [[WZForgetPassWordController alloc] init];
    [self.navigationController pushViewController:fPW animated:YES];
}
#pragma mark -登录
-(void)logins:(UIButton *)button{
    [self touches];
    
    
    NSString *name = _loginName.text;
    if (name.length != 11 || [name isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"用户名格式不正确"];
        return;
    }
    NSString *passWord = _loginPassWord.text;
    if (passWord.length <6 || passWord.length >16) {
        [SVProgressHUD showInfoWithStatus:@"密码格式不正确"];
        return;
    }
    //进行数据请求
    button.enabled = NO;
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"username"] = name;
    paraments[@"password"] = passWord;
    
    //3.发送请求
    NSString *url = [NSString stringWithFormat:@"%@/app/login.api",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        //解析数据
        NSString *code = [responseObject valueForKey:@"code"];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
           NSDictionary *data = [responseObject valueForKey:@"data"];
            [CloudPushSDK addAlias:[data valueForKey:@"id"] withCallback:^(CloudPushCallbackResult *res) {
                NSLog(@"绑定别名成功");
            }];
           
            //数据持久化
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[data valueForKey:@"uuid"] forKey:@"uuid"];
            [defaults setObject:[data valueForKey:@"username"] forKey:@"username"];
            [defaults setObject:[data valueForKey:@"username"] forKey:@"oldName"];
            [defaults setObject:[data valueForKey:@"id"] forKey:@"userId"];
            [defaults setObject:[data valueForKey:@"cityId"] forKey:@"cityId"];
            [defaults setObject:[data valueForKey:@"storeId"] forKey:@"storeId"];
            [defaults setObject:[data valueForKey:@"realtorStatus"] forKey:@"realtorStatus"];
            [defaults setObject:[data valueForKey:@"idcardStatus"] forKey:@"idcardStatus"];
            [defaults setObject:[data valueForKey:@"commissionFag"] forKey:@"commissionFag"];
            [defaults setObject:[data valueForKey:@"invisibleLinkmanFlag"] forKey:@"invisibleLinkmanFlag"];
            [defaults synchronize];
            [self receivingNotification];
            [self closeButton];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        button.enabled = YES;
    }];
    
}
#pragma mark -注册-选择协议
-(void)selectAgreement:(UIButton *)button{
    button.selected = !button.selected;
}
#pragma mark -注册-查看协议
-(void)findAgreement{
    [self touches];
    WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
    html.url = [NSString stringWithFormat:@"%@/apph5/agreement.html",HTTPH5];
    [self.navigationController pushViewController:html animated:YES];
}
#pragma mark -获取验证码
-(void)findYZM:(UIButton *)button{
    [self touches];
    NSString *telphone = _registarName.text;
    if ([telphone isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
        return;
    }
    NSString *str = [telphone substringToIndex:1];
    if (telphone.length != 11 || ![str isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    //修改按钮内容倒计时一分钟
    [self openCountdown];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
    paraments[@"telphone"] = telphone;
    NSString *url = [NSString stringWithFormat:@"%@/app/read/sendSmsByType",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"已发送"];
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
#pragma mark -验证码倒计时
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [_YZMButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [_YZMButton setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
                _YZMButton.userInteractionEnabled = YES;
                _YZMButton.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
                _YZMButton.layer.borderWidth = 1.0;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                _YZMButton.userInteractionEnabled = NO;
                //设置按钮显示读秒效果
                [_YZMButton setTitle:[NSString stringWithFormat:@"还剩%.2ds", seconds] forState:UIControlStateNormal];
                [_YZMButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
                _YZMButton.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
                _YZMButton.layer.borderWidth = 1.0;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark -下一步
-(void)next{
    [self touches];
    NSString *telphone = _registarName.text;
    if ([telphone isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
        return;
    }
    NSString *str = [telphone substringToIndex:1];
    if (telphone.length != 11 || ![str isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    NSString *YZM = _registarYZM.text;
    if (YZM.length != 6) {
        [SVProgressHUD showInfoWithStatus:@"验证码格式不正确"];
        return;
    }
    if(_selectAgreement.selected != YES){
        [SVProgressHUD showInfoWithStatus:@"请同意协议"];
        return;
    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
    paraments[@"telphone"] = telphone;
    paraments[@"smsCode"] = YZM;
    paraments[@"parentPhone"] = _inviteCode.text;
    NSString *url = [NSString stringWithFormat:@"%@/app/checkSmsCode",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            WZRegistarSetPWController *registar = [[WZRegistarSetPWController alloc] init];
            registar.telphone = telphone;
            registar.YZM = YZM;
            registar.inviteCode = _inviteCode.text;
            [self.navigationController pushViewController:registar animated:YES];
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
#pragma mark -开启接收通知
-(void)receivingNotification{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //获取设备ID
    NSString *deviceId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"appType"] = @"1";
    paraments[@"deviceCode"] = deviceId;
    
    NSString *url = [NSString stringWithFormat:@"%@/app/loginCallback",HTTPURL];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark -关闭页面
-(void)closeButton{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    if(textField==_inviteCode){
         _scrollView.contentSize = CGSizeMake(0, self.view.fHeight+100);
    }
}
// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField==_inviteCode){
        _scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight);
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_loginPassWord == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    if (_loginName == textField||_registarName == textField) {
        if (toBeString.length>11) {
            return NO;
        }
    }
    if (_registarYZM == textField) {
        if (toBeString.length>6) {
            return NO;
        }
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
    [_loginName resignFirstResponder];
    [_loginPassWord resignFirstResponder];
    [_registarName resignFirstResponder];
    [_registarYZM resignFirstResponder];
    [_inviteCode resignFirstResponder];
    
}
-(void)touches{
    [_loginName resignFirstResponder];
    [_loginPassWord resignFirstResponder];
    [_registarName resignFirstResponder];
    [_registarYZM resignFirstResponder];
    [_inviteCode resignFirstResponder];
}
@end
