//
//  WZRegistarSetPWController.m
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
#import "WZNavigationController.h"
#import "WZRegistarSetPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"
#import <CloudPushSDK/CloudPushSDK.h>
@interface WZRegistarSetPWController ()<UITextFieldDelegate>
//密码
@property(nonatomic,strong)UITextField *registarPassWord;
//确认密码
@property(nonatomic,strong)UITextField *registarPassWordTwo;

@end

@implementation WZRegistarSetPWController

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
    title.text = @"请编辑您的密码";
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
    UITextField *registarPassWord = [[UITextField alloc] init];
    registarPassWord.placeholder = @"请输入6-16位数字或字母";
    registarPassWord.textColor = UIColorRBG(51, 51, 51);
    registarPassWord.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    registarPassWord.delegate = self;
    registarPassWord.keyboardType = UIKeyboardTypeASCIICapable;
    [[registarPassWord valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    registarPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    [registarPassWord setSecureTextEntry:YES];
    _registarPassWord = registarPassWord;
    [self.view addSubview:registarPassWord];
    [registarPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(passwordLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-138);
    }];
    //下划线
    UIView  *registarInes = [[UIView alloc] init];
    registarInes.backgroundColor = UIColorRBG(255, 245, 177);
    [self.view addSubview:registarInes];
    [registarInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(registarPassWord.mas_bottom);
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
        make.left.equalTo(registarPassWord.mas_right).offset(11);
        make.top.equalTo(passwordLabel.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    //下划线
    UIView  *showIne = [[UIView alloc] init];
    showIne.backgroundColor = UIColorRBG(255, 245, 177);
    [self.view addSubview:showIne];
    [showIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarInes.mas_right).offset(6);
        make.top.equalTo(registarPassWord.mas_bottom);
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
        make.top.equalTo(registarInes.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    UITextField *registarPassWordTwo = [[UITextField alloc] init];
    registarPassWordTwo.placeholder = @"请再次输入密码";
    registarPassWordTwo.textColor = UIColorRBG(51, 51, 51);
    registarPassWordTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    registarPassWordTwo.delegate = self;
    registarPassWordTwo.keyboardType = UIKeyboardTypeASCIICapable;
    [[registarPassWordTwo valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    registarPassWordTwo.clearButtonMode = UITextFieldViewModeWhileEditing;
    [registarPassWordTwo setSecureTextEntry:YES];
    _registarPassWordTwo = registarPassWordTwo;
    [self.view addSubview:registarPassWordTwo];
    [registarPassWordTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(PWLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-138);
    }];
    //下划线
    UIView  *registarIneTwo = [[UIView alloc] init];
    registarIneTwo.backgroundColor = UIColorRBG(255, 245, 177);
    [self.view addSubview:registarIneTwo];
    [registarIneTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(registarPassWordTwo.mas_bottom);
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
        make.left.equalTo(registarPassWordTwo.mas_right).offset(11);
        make.top.equalTo(PWLabel.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    //下划线
    UIView  *showIneTwo = [[UIView alloc] init];
    showIneTwo.backgroundColor = UIColorRBG(255, 245, 177);
    [self.view addSubview:showIneTwo];
    [showIneTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarIneTwo.mas_right).offset(6);
        make.top.equalTo(registarPassWordTwo.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    //提交按钮
    UIButton *modifyPWButton = [[UIButton alloc] init];
    [modifyPWButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
    [modifyPWButton setTitle:@"注册" forState:UIControlStateNormal];
    [modifyPWButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    modifyPWButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    modifyPWButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [modifyPWButton addTarget:self action:@selector(modifyPWButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyPWButton];
    [modifyPWButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(registarIneTwo.mas_bottom).offset(100);
        make.height.offset(45);
        make.width.offset(109);
    }];
}
#pragma mark -修改密码-显示密码
-(void)showPw:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_registarPassWord setSecureTextEntry:YES];
    }else{
        [_registarPassWord setSecureTextEntry:NO];
    }
}
#pragma mark -修改密码-显示密码2
-(void)showPwTwo:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_registarPassWordTwo setSecureTextEntry:YES];
    }else{
        [_registarPassWordTwo setSecureTextEntry:NO];
    }
}
#pragma mark -修改密码提交
-(void)modifyPWButton:(UIButton *)button{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //第一次密码
    NSString *password = _registarPassWord.text;
    if (password.length<6||password.length>16) {
        [SVProgressHUD showInfoWithStatus:@"第一个密码格式错误"];
        return;
    }
    //第二次密码
    NSString *passwordTwo = _registarPassWordTwo.text;
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
    paraments[@"parentPhone"] = _inviteCode;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/register",HTTPURL];
    [mgr POST:url  parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"注册成功"];
            
            //查询未读消息
            [self setloadData];
            
            //将数据传入加入门店中
            WZNewJionStoreController *store = [[WZNewJionStoreController alloc] init];
            store.types = @"1";
            store.jionType = @"1";
             WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:store];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            NSMutableDictionary *regis = [responseObject valueForKey:@"data"];
            [CloudPushSDK addAlias:[regis valueForKey:@"id"] withCallback:^(CloudPushCallbackResult *res) {
                NSLog(@"绑定别名成功");
            }];
            //将数据持久化
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[regis valueForKey:@"uuid"] forKey:@"uuid"];
            [defaults setObject:[regis valueForKey:@"username"] forKey:@"username"];
            [defaults setObject:[regis valueForKey:@"username"] forKey:@"oldName"];
            [defaults setObject:[regis valueForKey:@"id"] forKey:@"userId"];
            [defaults setObject:[regis valueForKey:@"cityId"] forKey:@"cityId"];
            [defaults setObject:[regis valueForKey:@"storeId"] forKey:@"storeId"];
            [defaults setObject:[regis valueForKey:@"realtorStatus"] forKey:@"realtorStatus"];
            [defaults setObject:[regis valueForKey:@"idcardStatus"] forKey:@"idcardStatus"];
            [defaults setObject:[regis valueForKey:@"invisibleLinkmanFlag"] forKey:@"invisibleLinkmanFlag"];
            [defaults setObject:[regis valueForKey:@"companyName"] forKey:@"companyName"];
            [defaults setObject:[regis valueForKey:@"companyFlag"] forKey:@"companyFlag"];
            [defaults synchronize];
            //上传设备ID
            [self receivingNotification];
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
#pragma mark -上传设备ID
-(void)receivingNotification{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //获取设备ID
    NSString *deviceId = [user objectForKey:@"deviceId"];
    
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
    paraments[@"deviceType"] = @"IOS";
    NSString *url = [NSString stringWithFormat:@"%@/app/loginCallback",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark -查询未读消息
-(void)setloadData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/read/notreadCount",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *count = [data valueForKey:@"count"] ;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:count forKey:@"newCount"];
            [defaults synchronize];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    
    if (_registarPassWord == textField||_registarPassWordTwo == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    textField.text = toBeString;
    return NO;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_registarPassWord resignFirstResponder];
    [_registarPassWordTwo resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
