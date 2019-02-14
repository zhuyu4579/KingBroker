//
//  WZLoginAndRegistarController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  登录/注册
#import <Masonry.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZLoadDateSeviceOne.h"
#import "WZNEWHTMLController.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "WZRegistarSetPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZForgetPassWordController.h"
#import "WZLoginAndRegistarController.h"

@interface WZLoginAndRegistarController ()<UITextFieldDelegate>
//下拉页面
@property(nonatomic,strong)UIScrollView *scrollView;
//关闭按钮
@property(nonatomic,strong)UIButton *closeButton;
//登录图标
@property(nonatomic,strong)UIImageView *loginImageView;
//登录页签
@property(nonatomic,strong)UIButton *loginButton;
//登录页签下划线
@property(nonatomic,strong)UIView *ineLogin;
//页签中间线
@property(nonatomic,strong)UILabel *Midline;
//注册页签
@property(nonatomic,strong)UIButton *registarButton;
//注册页签下划线
@property(nonatomic,strong)UIView *ineRegistar;
//历史用户名
@property(nonatomic,strong)NSString *oldName;
#pragma mark-login
@property(nonatomic,strong)UIView *loginView;
//登录label
@property(nonatomic,strong)UILabel *loginNameLabel;
//登录的用户名
@property(nonatomic,strong)UITextField *loginName;
//登录用户名下滑线
@property(nonatomic,strong)UIView *loginNameIne;
//登录label
@property(nonatomic,strong)UILabel *loginPassWordLabel;
//登录的密码
@property(nonatomic,strong)UITextField *loginPassWord;
//登录密码下滑线
@property(nonatomic,strong)UIView *loginPassWordIne;
//显示密码按钮
@property(nonatomic,strong)UIButton *showLoginPWButton;
//显示密码按钮下滑线
@property(nonatomic,strong)UIView *showLoginPWIne;
//登录按钮
@property(nonatomic,strong)UIButton *loginAction;
//忘记密码按钮
@property(nonatomic,strong)UIButton *forgetPWAction;
//忘记密码按钮下划线
@property(nonatomic,strong)UIView *forgetPWIne;

#pragma mark-regist
@property(nonatomic,strong)UIView *registarView;
//注册用户名Label
@property(nonatomic , strong)UILabel *registarNameLabel;
//注册的用户名
@property(nonatomic,strong)UITextField *registarName;
//用户名下滑线
@property(nonatomic,strong)UIView *registarNameIne;
//注册验证码Label
@property(nonatomic , strong)UILabel *verificationCodeLabel;
//注册的验证码
@property(nonatomic,strong)UITextField *verificationCode;
//验证码下滑线
@property(nonatomic,strong)UIView *verificationCodeIne;
//注册邀请码Label
@property(nonatomic , strong)UILabel *inviteCodeLabelOne;
@property(nonatomic , strong)UILabel *inviteCodeLabelTwo;
//注册的邀请码
@property(nonatomic,strong)UITextField *inviteCode;
//邀请码下滑线
@property(nonatomic,strong)UIView *inviteCodeIne;
//注册-获取验证码
@property(nonatomic,strong)UIButton *findVerificationCode;
//注册-选中协议
@property(nonatomic,strong)UIButton *selectAgreement;
//协议label
@property(nonatomic , strong)UILabel *agreementLabel;
//查看协议
@property(nonatomic,strong)UIButton *seeAgreement;
//下一步
@property(nonatomic,strong)UIButton *nextButton;
//定时器
@property(nonatomic,weak)NSTimer *timer;
@end

@implementation WZLoginAndRegistarController
#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //页面表头模块
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.closeButton];
    [self.scrollView addSubview:self.loginImageView];
    [self.scrollView addSubview:self.loginButton];
    [self.scrollView addSubview:self.ineLogin];
    [self.scrollView addSubview:self.Midline];
    [self.scrollView addSubview:self.registarButton];
    [self.scrollView addSubview:self.ineRegistar];
    //页面登录模块
    [self.scrollView addSubview:self.loginView];
    [self.loginView addSubview:self.loginNameLabel];
    [self.loginView addSubview:self.loginName];
    [self.loginView addSubview:self.loginNameIne];
    [self.loginView addSubview:self.loginPassWordLabel];
    [self.loginView addSubview:self.loginPassWord];
    [self.loginView addSubview:self.loginPassWordIne];
    [self.loginView addSubview:self.showLoginPWButton];
    [self.loginView addSubview:self.showLoginPWIne];
    [self.loginView addSubview:self.loginAction];
    [self.loginView addSubview:self.forgetPWAction];
    [self.loginView addSubview:self.forgetPWIne];
    //页面注册模块
    [self.scrollView addSubview:self.registarView];
    [self.registarView addSubview:self.registarNameLabel];
    [self.registarView addSubview:self.registarName];
    [self.registarView addSubview:self.registarNameIne];
    [self.registarView addSubview:self.verificationCodeLabel];
    [self.registarView addSubview:self.verificationCode];
    [self.registarView addSubview:self.verificationCodeIne];
    [self.registarView addSubview:self.findVerificationCode];
    [self.registarView addSubview:self.inviteCodeLabelOne];
    [self.registarView addSubview:self.inviteCodeLabelTwo];
    [self.registarView addSubview:self.inviteCode];
    [self.registarView addSubview:self.inviteCodeIne];
    [self.registarView addSubview:self.selectAgreement];
    [self.registarView addSubview:self.agreementLabel];
    [self.registarView addSubview:self.seeAgreement];
    [self.registarView addSubview:self.nextButton];
    //默认选择页签
    [self defaultSelcetPage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight);
}
-(void)viewDidLayoutSubviews{
    //设置约束
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(15);
        make.top.equalTo(self.scrollView.mas_top).mas_offset(22);
        make.height.offset(15);
        make.width.offset(15);
    }];
    [self.loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.top.equalTo(self.scrollView.mas_top).mas_offset(50);
        make.height.offset(109);
        make.width.offset(109);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(59);
        make.top.equalTo(self.loginImageView.mas_bottom).mas_offset(32);
        make.height.offset(27);
        make.width.offset(35);
    }];
    [self.ineLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(59);
        make.top.equalTo(self.loginButton.mas_bottom);
        make.height.offset(2);
        make.width.offset(35);
    }];
    [self.Midline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginButton.mas_right).offset(26);
        make.top.equalTo(self.loginImageView.mas_bottom).mas_offset(40);
        make.height.offset(9);
    }];
    [self.registarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Midline.mas_right).offset(26);
        make.top.equalTo(self.loginImageView.mas_bottom).mas_offset(32);
        make.height.offset(27);
        make.width.offset(35);
    }];
    [self.ineRegistar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.Midline.mas_right).offset(26);
        make.top.equalTo(self.registarButton.mas_bottom);
        make.height.offset(2);
        make.width.offset(35);
    }];
    //登录模块
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.ineLogin.mas_bottom);
        make.height.offset(300);
        make.width.offset(self.scrollView.fWidth);
    }];
    [self.loginNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginView.mas_top).offset(37);
        make.height.offset(12);
    }];
    [self.loginName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginNameLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.scrollView.fWidth-107);
    }];
    [self.loginNameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginName.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.scrollView.fWidth-107);
    }];
    [self.loginPassWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginNameIne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    [self.loginPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginPassWordLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.scrollView.fWidth-138);
    }];
    [self.loginPassWordIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.scrollView.fWidth-138);
    }];
    [self.showLoginPWButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginPassWord.mas_right).offset(11);
        make.top.equalTo(self.loginPassWordLabel.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    [self.showLoginPWIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginPassWordIne.mas_right).offset(6);
        make.top.equalTo(self.loginPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    [self.loginAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginView.mas_left).offset(57);
        make.top.equalTo(self.loginPassWordIne.mas_bottom).offset(60);
        make.height.offset(45);
        make.width.offset(109);
    }];
    [self.forgetPWAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginAction.mas_right).offset(16);
        make.top.equalTo(self.loginPassWordIne.mas_bottom).offset(72);
        make.height.offset(11);
    }];
    [self.forgetPWIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginAction.mas_right).offset(16);
        make.top.equalTo(self.forgetPWAction.mas_bottom).offset(3);
        make.height.offset(1);
        make.width.offset(43);
    }];
    //注册
    [self.registarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.ineLogin.mas_bottom);
        make.height.offset(350);
        make.width.offset(self.scrollView.fWidth);
    }];
    [self.registarNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.registarView.mas_top).offset(37);
        make.height.offset(12);
    }];
    [self.registarName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.registarNameLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.scrollView.fWidth-107);
    }];
    [self.registarNameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.registarName.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.scrollView.fWidth-107);
    }];
    [self.verificationCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.registarNameIne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    [self.verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.verificationCodeLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.scrollView.fWidth-205);
    }];
    [self.verificationCodeIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.verificationCode.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.scrollView.fWidth-205);
    }];
    [self.findVerificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationCode.mas_right).offset(18);
        make.top.equalTo(self.verificationCodeLabel.mas_bottom).offset(13);
        make.height.offset(24);
        make.width.offset(80);
    }];
    [self.inviteCodeLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.verificationCodeIne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    [self.inviteCodeLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inviteCodeLabelOne.mas_right).offset(16);
        make.top.equalTo(self.verificationCodeIne.mas_bottom).offset(32);
        make.height.offset(12);
    }];
    [self.inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.inviteCodeLabelOne.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.scrollView.fWidth-107);
    }];
    [self.inviteCodeIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.inviteCode.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.scrollView.fWidth-107);
    }];
    [self.selectAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(58);
        make.top.equalTo(self.inviteCodeIne.mas_bottom).offset(17);
        make.height.offset(14);
        make.width.offset(14);
    }];
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectAgreement.mas_right).offset(7);
        make.top.equalTo(self.inviteCodeIne.mas_bottom).offset(19);
        make.height.offset(11);
    }];
    [self.seeAgreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreementLabel.mas_right);
        make.top.equalTo(self.inviteCodeIne.mas_bottom).offset(14);
        make.height.offset(21);
        make.width.offset(110);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarView.mas_left).offset(57);
        make.top.equalTo(self.seeAgreement.mas_bottom).offset(30);
        make.height.offset(45);
        make.width.offset(109);
    }];
}

#pragma mark -UITextFieldDelegate
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
    if (_verificationCode == textField) {
        if (toBeString.length>6) {
            return NO;
        }
    }
    textField.text = toBeString;
    return NO;
}

#pragma mark -touchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_loginName resignFirstResponder];
    [_loginPassWord resignFirstResponder];
    [_registarName resignFirstResponder];
    [_verificationCode resignFirstResponder];
    [_inviteCode resignFirstResponder];
    
}
-(void)touches{
    [_loginName resignFirstResponder];
    [_loginPassWord resignFirstResponder];
    [_registarName resignFirstResponder];
    [_verificationCode resignFirstResponder];
    [_inviteCode resignFirstResponder];
}
#pragma mark - Method
-(void)defaultSelcetPage{
    if ([_type isEqual:@"0"]) {
        [_loginButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        _ineLogin.backgroundColor = UIColorRBG(255, 204, 0);
        [_loginView setHidden:NO];
        
    }else{
        [_registarButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        _ineRegistar.backgroundColor = UIColorRBG(255, 204, 0);
        [_registarView setHidden:NO];
        
    }
  
    
}
#pragma mark -response
//关闭页面
-(void)closeButtons{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//点击切换登录模块
-(void)loginButton:(UIButton *)button{
    [self touches];
    [_registarButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineRegistar.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineLogin.backgroundColor = UIColorRBG(255, 204, 0);
    [_registarView setHidden:YES];
    [_loginView setHidden:NO];
    
}
//点击切换注册模块
-(void)registarButton:(UIButton *)button{
    [self touches];
    [_loginButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineLogin.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineRegistar.backgroundColor = UIColorRBG(255, 204, 0);
    [_loginView setHidden:YES];
    [_registarView setHidden:NO];
    
}

-(void)showPw:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_loginPassWord setSecureTextEntry:YES];
    }else{
        [_loginPassWord setSecureTextEntry:NO];
    }
}
//登录
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
    NSLog(@"111");
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"username"] = name;
    paraments[@"password"] = passWord;
    
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        button.enabled = YES;
        //解析数据
        NSString *code = [dic valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
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
            [defaults setObject:[data valueForKey:@"companyName"] forKey:@"companyName"];
            [defaults setObject:[data valueForKey:@"companyFlag"] forKey:@"companyFlag"];
            [defaults setObject:[data valueForKey:@"idcardStatus"] forKey:@"idcardStatus"];
            [defaults setObject:[data valueForKey:@"commissionFag"] forKey:@"commissionFag"];
            [defaults setObject:[data valueForKey:@"invisibleLinkmanFlag"] forKey:@"invisibleLinkmanFlag"];
            [defaults synchronize];
            [self receivingNotification];
            [self closeButtons];
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        button.enabled = YES;
    } parament:paraments URL:@"/app/login.api"];
    
}
//忘记密码
-(void)forgetPw{
    [self touches];
    WZForgetPassWordController *fPW = [[WZForgetPassWordController alloc] init];
    [self.navigationController pushViewController:fPW animated:YES];
}
//注册-选择协议
-(void)selectAgreement:(UIButton *)button{
    button.selected = !button.selected;
}
//注册-查看协议
-(void)seeAgreements{
    [self touches];
    WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
    html.url = [NSString stringWithFormat:@"%@/apph5/agreement.html",HTTPH5];
    [self.navigationController pushViewController:html animated:YES];
}

//获取验证码
-(void)findVerificationCodes:(UIButton *)button{
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
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
    paraments[@"telphone"] = telphone;
    
    //修改按钮内容倒计时一分钟
    [self openCountdown];
    
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"已发送"];
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/app/read/sendSmsByType"];
    
}
//验证码倒计时
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
                [_findVerificationCode setTitle:@"重新发送" forState:UIControlStateNormal];
                [_findVerificationCode setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
                _findVerificationCode.userInteractionEnabled = YES;
                _findVerificationCode.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
                _findVerificationCode.layer.borderWidth = 1.0;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                _findVerificationCode.userInteractionEnabled = NO;
                //设置按钮显示读秒效果
                [_findVerificationCode setTitle:[NSString stringWithFormat:@"还剩%.2ds", seconds] forState:UIControlStateNormal];
                [_findVerificationCode setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
                _findVerificationCode.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
                _findVerificationCode.layer.borderWidth = 1.0;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
//下一步
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
    NSString *YZM = _verificationCode.text;
    if (YZM.length != 6) {
        [SVProgressHUD showInfoWithStatus:@"验证码格式不正确"];
        return;
    }
    if(_selectAgreement.selected != YES){
        [SVProgressHUD showInfoWithStatus:@"请同意协议"];
        return;
    }
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
    paraments[@"telphone"] = telphone;
    paraments[@"smsCode"] = YZM;
    paraments[@"parentPhone"] = _inviteCode.text;
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            WZRegistarSetPWController *registar = [[WZRegistarSetPWController alloc] init];
            registar.telphone = telphone;
            registar.YZM = YZM;
            registar.inviteCode = _inviteCode.text;
            [self.navigationController pushViewController:registar animated:YES];
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/app/checkSmsCode"];
    
}
//上传设备ID
-(void)receivingNotification{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //获取设备ID
    NSString *deviceId = [user objectForKey:@"deviceId"];
    
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"appType"] = @"1";
    paraments[@"deviceCode"] = deviceId;
    paraments[@"deviceType"] = @"IOS";
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/app/loginCallback"];
    
}

#pragma mark -getter
//滑动
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
//页面关闭按钮
-(UIButton *)closeButton{
    if(!_closeButton){
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtons) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setEnlargeEdge:44];
    }
    return _closeButton;
}
//登录页图标
-(UIImageView *)loginImageView{
    if (!_loginImageView) {
        _loginImageView = [[UIImageView alloc] init];
        _loginImageView.image = [UIImage imageNamed:@"logo"];
    }
    return _loginImageView;
}
//登录页签
-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setEnlargeEdge:44];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        [_loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
//登录页签下划线
-(UIView *)ineLogin{
    if (!_ineLogin) {
        _ineLogin = [[UIView alloc] init];
        _ineLogin.backgroundColor = [UIColor clearColor];
    }
    return _ineLogin;
}
//页签中间线
-(UILabel *)Midline{
    if (!_Midline) {
        _Midline = [[UILabel alloc] init];
        _Midline.text = @"/";
        _Midline.textColor = UIColorRBG(153, 153, 153);
    }
    return _Midline;
}
//注册页签
-(UIButton *)registarButton{
    if (!_registarButton) {
        _registarButton = [[UIButton alloc] init];
        [_registarButton setEnlargeEdge:44];
        [_registarButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registarButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        _registarButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        [_registarButton addTarget:self action:@selector(registarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registarButton;
}
//注册页签下划线
-(UIView *)ineRegistar{
    if (!_ineRegistar) {
        _ineRegistar = [[UIView alloc] init];
        _ineRegistar.backgroundColor = [UIColor clearColor];
    }
    return _ineRegistar;
}
//登录模块
-(UIView *)loginView{
    if (!_loginView) {
        _loginView = [[UIView alloc] init];
        [_loginView setHidden:YES];
    }
    return _loginView;
}
-(UILabel *)loginNameLabel{
    if (!_loginNameLabel) {
        _loginNameLabel = [[UILabel alloc] init];
        _loginNameLabel.text = @"用户名";
        _loginNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _loginNameLabel.textColor = UIColorRBG(51, 51, 51);
    }
    return _loginNameLabel;
}
-(UITextField *)loginName{
    if (!_loginName) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _oldName = [user objectForKey:@"oldName"];
        _loginName = [[UITextField alloc] init];
        _loginName.placeholder = @"请输入用户名";
        if (![_oldName isEqual:@""] || _oldName) {
            _loginName.text = _oldName;
        }
        _loginName.textColor = UIColorRBG(49, 35, 6);
        _loginName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _loginName.delegate = self;
        _loginName.keyboardType = UIKeyboardTypeNumberPad;
        [[_loginName valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _loginName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _loginName.clearsOnBeginEditing = NO;
    }
    return _loginName;
}
-(UIView *)loginNameIne{
    if (!_loginNameIne) {
        _loginNameIne = [[UIView alloc] init];
        _loginNameIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _loginNameIne;
}
-(UILabel *)loginPassWordLabel{
    if (!_loginPassWordLabel) {
        _loginPassWordLabel = [[UILabel alloc] init];
        _loginPassWordLabel.text = @"密码";
        _loginPassWordLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _loginPassWordLabel.textColor = UIColorRBG(51, 51, 51);
    }
    return _loginPassWordLabel;
}
-(UITextField *)loginPassWord{
    if (!_loginPassWord) {
        _loginPassWord = [[UITextField alloc] init];
        _loginPassWord.placeholder = @"请输入密码";
        _loginPassWord.textColor = UIColorRBG(49, 35, 6);
        _loginPassWord.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _loginPassWord.delegate = self;
        _loginPassWord.keyboardType = UIKeyboardTypeASCIICapable;
        [[_loginPassWord valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _loginPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_loginPassWord setSecureTextEntry:YES];
    }
    return _loginPassWord;
}
-(UIView *)loginPassWordIne{
    if (!_loginPassWordIne) {
        _loginPassWordIne = [[UIView alloc] init];
        _loginPassWordIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _loginPassWordIne;
}
-(UIButton *)showLoginPWButton{
    if (!_showLoginPWButton) {
        _showLoginPWButton = [[UIButton alloc] init];
        [_showLoginPWButton setBackgroundImage:[UIImage imageNamed:@"zc_icon_2"] forState:UIControlStateNormal];
        [_showLoginPWButton setBackgroundImage:[UIImage imageNamed:@"zc_icon_1"] forState:UIControlStateSelected];
        [_showLoginPWButton addTarget:self action:@selector(showPw:) forControlEvents:UIControlEventTouchUpInside];
        [_showLoginPWButton setEnlargeEdgeWithTop:10 right:20 bottom:20 left:10];
    }
    return _showLoginPWButton;
}
-(UIView *)showLoginPWIne{
    if (!_showLoginPWIne) {
        _showLoginPWIne = [[UIView alloc] init];
        _showLoginPWIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _showLoginPWIne;
}
-(UIButton *)loginAction{
    if (!_loginAction) {
        _loginAction = [[UIButton alloc] init];
        [_loginAction setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
        [_loginAction setTitle:@"登录" forState:UIControlStateNormal];
        [_loginAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginAction.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _loginAction.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        [_loginAction addTarget:self action:@selector(logins:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginAction;
}
-(UIButton *)forgetPWAction{
    if (!_forgetPWAction) {
        _forgetPWAction = [[UIButton alloc] init];
        [_forgetPWAction setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPWAction setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        _forgetPWAction.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        [_forgetPWAction addTarget:self action:@selector(forgetPw) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPWAction;
}
-(UIView *)forgetPWIne{
    if (!_forgetPWIne) {
        _forgetPWIne = [[UIView alloc] init];
        _forgetPWIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _forgetPWIne;
}
//注册模块
-(UIView *)registarView{
    if (!_registarView) {
        _registarView = [[UIView alloc] init];
        [_registarView setHidden:YES];
    }
    return _registarView;
}
-(UILabel *)registarNameLabel{
    if (!_registarNameLabel) {
        _registarNameLabel = [[UILabel alloc] init];
        _registarNameLabel.text = @"手机号";
        _registarNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _registarNameLabel.textColor = UIColorRBG(51, 51, 51);
    }
    return _registarNameLabel;
}
-(UITextField *)registarName{
    if (!_registarName) {
        _registarName = [[UITextField alloc] init];
        _registarName.placeholder = @"请输入手机号";
        _registarName.textColor = UIColorRBG(49, 35, 6);
        _registarName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _registarName.delegate = self;
        _registarName.keyboardType = UIKeyboardTypeNumberPad;
        [[_registarName valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _registarName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _registarName.clearsOnBeginEditing = NO;
    }
    return _registarName;
}
-(UIView *)registarNameIne{
    if (!_registarNameIne) {
        _registarNameIne = [[UIView alloc] init];
        _registarNameIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return  _registarNameIne;
}
-(UILabel *)verificationCodeLabel{
    if (!_verificationCodeLabel) {
        _verificationCodeLabel = [[UILabel alloc] init];
        _verificationCodeLabel.text = @"验证码";
        _verificationCodeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _verificationCodeLabel.textColor = UIColorRBG(51, 51, 51);
    }
    return _verificationCodeLabel;
}
-(UITextField *)verificationCode{
    if (!_verificationCode) {
        _verificationCode = [[UITextField alloc] init];
        _verificationCode.placeholder = @"请输入验证码";
        _verificationCode.textColor = UIColorRBG(49, 35, 6);
        _verificationCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _verificationCode.delegate = self;
        _verificationCode.keyboardType = UIKeyboardTypeNumberPad;
        [[_verificationCode valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _verificationCode;
}
-(UIView *)verificationCodeIne{
    if (!_verificationCodeIne) {
        _verificationCodeIne = [[UIView alloc] init];
        _verificationCodeIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _verificationCodeIne;
}
-(UIButton *)findVerificationCode{
    if (!_findVerificationCode) {
        _findVerificationCode = [[UIButton alloc] init];
        [_findVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_findVerificationCode setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
        _findVerificationCode.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _findVerificationCode.layer.cornerRadius = 12;
        _findVerificationCode.layer.masksToBounds = YES;
        _findVerificationCode.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
        _findVerificationCode.layer.borderWidth = 1.0;
        [_findVerificationCode addTarget:self action:@selector(findVerificationCodes:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _findVerificationCode;
}
-(UILabel *)inviteCodeLabelOne{
    if (!_inviteCodeLabelOne) {
        _inviteCodeLabelOne = [[UILabel alloc] init];
        _inviteCodeLabelOne.text = @"邀请人";
        _inviteCodeLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _inviteCodeLabelOne.textColor = UIColorRBG(51, 51, 51);
    }
    return _inviteCodeLabelOne;
}
-(UILabel *)inviteCodeLabelTwo{
    if (!_inviteCodeLabelTwo) {
        _inviteCodeLabelTwo = [[UILabel alloc] init];
        _inviteCodeLabelTwo.text = @"(选填)";
        _inviteCodeLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _inviteCodeLabelTwo.textColor = UIColorRBG(204, 204, 204);
    }
    return _inviteCodeLabelTwo;
}
-(UITextField *)inviteCode{
    if (!_inviteCode) {
        _inviteCode = [[UITextField alloc] init];
        _inviteCode.placeholder = @"请输入邀请码";
        _inviteCode.textColor = UIColorRBG(49, 35, 6);
        _inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _inviteCode.delegate = self;
        _inviteCode.keyboardType = UIKeyboardTypeDefault;
        [[_inviteCode valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _inviteCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inviteCode.clearsOnBeginEditing = NO;
    }
    return _inviteCode;
}
-(UIView *)inviteCodeIne{
    if (!_inviteCodeIne) {
        _inviteCodeIne = [[UIView alloc] init];
        _inviteCodeIne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _inviteCodeIne;
}
-(UIButton *)selectAgreement{
    if (!_selectAgreement) {
        _selectAgreement = [[UIButton alloc] init];
        [_selectAgreement setBackgroundImage:[UIImage imageNamed:@"ZC_YES_1"] forState:UIControlStateNormal];
        [_selectAgreement setBackgroundImage:[UIImage imageNamed:@"ZC_YES"] forState:UIControlStateSelected];
        [_selectAgreement addTarget:self action:@selector(selectAgreement:) forControlEvents:UIControlEventTouchUpInside];
        [_selectAgreement setEnlargeEdgeWithTop:17 right:30 bottom:30 left:44];
        _selectAgreement.selected = YES;
    }
    return _selectAgreement;
}
-(UILabel *)agreementLabel{
    if (!_agreementLabel) {
        _agreementLabel = [[UILabel alloc] init];
        _agreementLabel.text = @"我已同意";
        _agreementLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
        _agreementLabel.textColor = UIColorRBG(199, 199, 205);
    }
    return _agreementLabel;
}
-(UIButton *)seeAgreement{
    if (!_seeAgreement) {
        _seeAgreement = [[UIButton alloc] init];
        [_seeAgreement setTitle:@"《经喜用户服务协议》" forState:UIControlStateNormal];
        [_seeAgreement setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
        _seeAgreement.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
        [_seeAgreement addTarget:self action:@selector(seeAgreements) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeAgreement;
}
-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        [_nextButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        [_nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
