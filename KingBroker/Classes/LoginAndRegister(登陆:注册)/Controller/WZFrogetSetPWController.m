//
//  WZFrogetSetPWController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "NSString+LCExtension.h"
#import "WZFrogetSetPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZFrogetSetPWController ()<UITextFieldDelegate>
//密码
@property(nonatomic,strong)UITextField *loginPassWord;
//确认密码
@property(nonatomic,strong)UITextField *loginPassWordTwo;
@end

@implementation WZFrogetSetPWController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置密码";
    //创建控件
    [self createControl];
}
#pragma mark-创建控件
-(void)createControl{
    UILabel *title = [[UILabel alloc] init];
    title.text = @"请重新编辑您的密码";
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    title.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(51);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+101);
        make.height.offset(18);
    }];
    UILabel *titleTwo = [[UILabel alloc] init];
    titleTwo.text = @"建议您的新密码以字母和数字混合";
    titleTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    titleTwo.textColor = UIColorRBG(153, 153, 153);
    [self.view addSubview:titleTwo];
    [titleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(51);
        make.top.equalTo(title.mas_bottom).offset(10);
        make.height.offset(14);
    }];
    //密码
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"密码";
    passwordLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    passwordLabel.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(titleTwo.mas_bottom).offset(68);
        make.height.offset(12);
    }];
    UITextField *loginPassWord = [[UITextField alloc] init];
    loginPassWord.placeholder = @"请输入6-16位数字或字母";
    loginPassWord.textColor = UIColorRBG(255, 204, 0);
    loginPassWord.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    loginPassWord.delegate = self;
    loginPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    [[loginPassWord valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    loginPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginPassWord setSecureTextEntry:YES];
    _loginPassWord = loginPassWord;
    [self.view addSubview:loginPassWord];
    [loginPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(passwordLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-138);
    }];
    //下划线
    UIView  *loginInes = [[UIView alloc] init];
    loginInes.backgroundColor = UIColorRBG(255, 204, 0);
    [self.view addSubview:loginInes];
    [loginInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(loginPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-138);
    }];
    //显示密码
    UIButton *showPw = [[UIButton alloc] init];
    [showPw setBackgroundImage:[UIImage imageNamed:@"zc_icon_2"] forState:UIControlStateNormal];
    [showPw setBackgroundImage:[UIImage imageNamed:@"zc_icon_1"] forState:UIControlStateSelected];
    [showPw addTarget:self action:@selector(showPw:) forControlEvents:UIControlEventTouchUpInside];
    [showPw setEnlargeEdgeWithTop:10 right:20 bottom:20 left:10];
    [self.view addSubview:showPw];
    [showPw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginPassWord.mas_right).offset(11);
        make.top.equalTo(passwordLabel.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    //下划线
    UIView  *showIne = [[UIView alloc] init];
    showIne.backgroundColor = UIColorRBG(255, 204, 0);
    [self.view addSubview:showIne];
    [showIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginInes.mas_right).offset(6);
        make.top.equalTo(loginPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    //确认密码
    UILabel *PWLabel = [[UILabel alloc] init];
    PWLabel.text = @"确认密码";
    PWLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    PWLabel.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:PWLabel];
    [PWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(loginInes.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    UITextField *loginPassWordTwo = [[UITextField alloc] init];
    loginPassWordTwo.placeholder = @"请再次输入密码";
    loginPassWordTwo.textColor = UIColorRBG(255, 204, 0);
    loginPassWordTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    loginPassWordTwo.delegate = self;
    loginPassWordTwo.keyboardType = UIKeyboardTypeASCIICapable;
    [[loginPassWordTwo valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    loginPassWordTwo.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginPassWordTwo setSecureTextEntry:YES];
    _loginPassWordTwo = loginPassWordTwo;
    [self.view addSubview:loginPassWordTwo];
    [loginPassWordTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(PWLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-138);
    }];
    //下划线
    UIView  *loginIneTwo = [[UIView alloc] init];
    loginIneTwo.backgroundColor = UIColorRBG(255, 204, 0);
    [self.view addSubview:loginIneTwo];
    [loginIneTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(loginPassWordTwo.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-138);
    }];
    //显示密码
    UIButton *showPwTwo = [[UIButton alloc] init];
    [showPwTwo setBackgroundImage:[UIImage imageNamed:@"zc_icon_2"] forState:UIControlStateNormal];
    [showPwTwo setBackgroundImage:[UIImage imageNamed:@"zc_icon_1"] forState:UIControlStateSelected];
    [showPwTwo addTarget:self action:@selector(showPwTwo:) forControlEvents:UIControlEventTouchUpInside];
    [showPwTwo setEnlargeEdgeWithTop:10 right:20 bottom:20 left:10];
    [self.view addSubview:showPwTwo];
    [showPwTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginPassWordTwo.mas_right).offset(11);
        make.top.equalTo(PWLabel.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    //下划线
    UIView  *showIneTwo = [[UIView alloc] init];
    showIneTwo.backgroundColor = UIColorRBG(255, 204, 0);
    [self.view addSubview:showIneTwo];
    [showIneTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginIneTwo.mas_right).offset(6);
        make.top.equalTo(loginPassWordTwo.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    //提交按钮
    UIButton *modifyPWButton = [[UIButton alloc] init];
    [modifyPWButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
    [modifyPWButton setTitle:@"提交" forState:UIControlStateNormal];
    [modifyPWButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    modifyPWButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    modifyPWButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [modifyPWButton addTarget:self action:@selector(modifyPWButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyPWButton];
    [modifyPWButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(loginIneTwo.mas_bottom).offset(100);
        make.height.offset(45);
        make.width.offset(109);
    }];
}
#pragma mark -修改密码-显示密码
-(void)showPw:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_loginPassWord setSecureTextEntry:YES];
    }else{
        [_loginPassWord setSecureTextEntry:NO];
    }
}
#pragma mark -修改密码-显示密码2
-(void)showPwTwo:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_loginPassWordTwo setSecureTextEntry:YES];
    }else{
        [_loginPassWordTwo setSecureTextEntry:NO];
    }
}
#pragma mark -修改密码提交
-(void)modifyPWButton:(UIButton *)button{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //第一次密码
    NSString *password = _loginPassWord.text;
    if (password.length<6||password.length>16) {
        [SVProgressHUD showInfoWithStatus:@"第一个密码格式错误"];
        return;
    }
    //第二次密码
    NSString *passwordTwo = _loginPassWordTwo.text;
    if (passwordTwo.length<6||passwordTwo.length>16) {
        [SVProgressHUD showInfoWithStatus:@"第二个密码格式错误"];
        return;
    }
    if(![password isEqual:passwordTwo]){
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    button.enabled = NO;
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"password"] = password;
    paraments[@"phone"] = _telphone;
    paraments[@"verificationCode"] = _YZM;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/changPassword",HTTPURL];
    [mgr POST:url  parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            //返回登录页面
            [NSString isCode:self.navigationController code:@"401"];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        button.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_loginPassWord == textField||_loginPassWordTwo == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_loginPassWord resignFirstResponder];
    [_loginPassWordTwo resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
