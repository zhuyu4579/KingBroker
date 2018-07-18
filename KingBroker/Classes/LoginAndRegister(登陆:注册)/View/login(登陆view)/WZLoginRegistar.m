//
//  WZLoginRegistar.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/16.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZLoginRegistar.h"
#import "UIColor+Tools.h"
#import "WZRegController.h"
#import "WZfindPassWordController.h"
#import "UIViewController+WZFindController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZTabBarController.h"
#import "JPUSHService.h"
@interface WZLoginRegistar()<UITextFieldDelegate>

@end
@implementation WZLoginRegistar

//返回自己
+(instancetype)loginRegistar{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

#pragma mark -显示密码/隐藏秘密
- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (!button.selected) {
        [self.loginPassword setSecureTextEntry:YES];
    }else{
        [self.loginPassword setSecureTextEntry:NO];
    }
    
}

#pragma mark -找回密码
- (IBAction)findPassWordAction:(id)sender {
    WZfindPassWordController *findPWVc = [[WZfindPassWordController alloc] init];
    findPWVc.navigationItem.title = @"忘记密码";
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    [Vc.navigationController pushViewController:findPWVc animated:YES];
}
#pragma mark -登陆
- (IBAction)login:(id)sender{
    UIButton *button = sender;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    UIViewController *vc = [UIViewController viewController:self];
     //判断账户和密码不能为空
    NSString *name = self.loginAdmin.text;
    NSString *password = self.loginPassword.text;
    if (!name.length || !password.length) {
        [SVProgressHUD showInfoWithStatus:@"账号密码不能为空"];
        return;
    }
     //判断账号和密码格式
    if(name.length!=11||![self isPureInt:name]){
        [SVProgressHUD showInfoWithStatus:@"账号格式错误"];
        return;
    }
    
    //判断密码的长度
    if(password.length<6||password.length>16){
         [SVProgressHUD showInfoWithStatus:@"密码长度6-20个字符"];
        return;
    }
    //进行数据请求
    //创建会话请求
    button.enabled = NO;
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"username"] = name;
    paraments[@"password"] = password;
    //3.发送请求
    NSString *url = [NSString stringWithFormat:@"%@/app/login.api",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        //解析数据
        NSString *code = [responseObject valueForKey:@"code"];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
             _loginItem = [responseObject valueForKey:@"data"];

            [JPUSHService setAlias:[_loginItem valueForKey:@"id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode == 0) {
                    NSLog(@"添加别名成功");
                }
            } seq:1];

            if(_login){
                _login(_loginItem);
            }
            //数据持久化
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[_loginItem valueForKey:@"uuid"] forKey:@"uuid"];
            [defaults setObject:[_loginItem valueForKey:@"username"] forKey:@"username"];
            [defaults setObject:[_loginItem valueForKey:@"username"] forKey:@"oldName"];
            [defaults setObject:[_loginItem valueForKey:@"id"] forKey:@"userId"];
            [defaults setObject:[_loginItem valueForKey:@"cityId"] forKey:@"cityId"];
            [defaults setObject:[_loginItem valueForKey:@"storeId"] forKey:@"storeId"];
            [defaults setObject:[_loginItem valueForKey:@"realtorStatus"] forKey:@"realtorStatus"];
            [defaults setObject:[_loginItem valueForKey:@"idcardStatus"] forKey:@"idcardStatus"];
            [defaults setObject:[_loginItem valueForKey:@"commissionFag"] forKey:@"commissionFag"];
             [defaults setObject:[_loginItem valueForKey:@"invisibleLinkmanFlag"] forKey:@"invisibleLinkmanFlag"];
            [defaults synchronize];
            [self receivingNotification];
            WZTabBarController *tab = [[WZTabBarController alloc] init];
            [vc.navigationController presentViewController:tab animated:YES completion:nil];
        }else{
             NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        button.enabled = NO;
    }];
    
}

//开启接收通知
-(void)receivingNotification{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
   
    NSString *url = [NSString stringWithFormat:@"%@/sysJpush/findJpushhistoryList",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark -注册
- (IBAction)registar:(id)sender {
  WZRegController *ragVc = [[WZRegController alloc] init];
  UIViewController *Vc = [UIViewController viewController:[self superview]];
 [Vc.navigationController pushViewController:ragVc animated:YES];
    if (_login) {
        ragVc.registarDataBlock = ^(NSDictionary *registarData) {
            _login(registarData);
        };
    }
 
}

#pragma mark -重写drawRect方法设置按钮圆角
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //设置登录按钮圆角
    self.loginButton.layer.cornerRadius = 4.0;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
    
    //设置注册按钮圆角
    self.registarButton.layer.cornerRadius = 4.0;
    self.registarButton.layer.masksToBounds = YES;
    [self.registarButton.layer setBorderWidth:1.0];
    [self.registarButton setTitleColor:[UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.registarButton.layer.borderColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0].CGColor;
    
    //设置找回密码按钮
    [self.findPassWord setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    //设置选中按钮
    [self.showHIdePassWord setImage:[UIImage imageNamed:@"icon_yj"] forState:UIControlStateNormal];
    [self.showHIdePassWord setImage:[UIImage imageNamed:@"icon_yj_2"] forState:UIControlStateSelected];
    [self.showHIdePassWord addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setTextFeildbords];
    
    [self.showHIdePassWord setEnlargeEdge:20];
}
#pragma mark -设置输入框
-(void)setTextFeildbords{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *oldName = [ user objectForKey:@"oldName"];
    //设置账户输入框的底线
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,self.loginAdmin.bounds.size.height-1, self.loginAdmin.bounds.size.width, 1)];
    ineView.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.loginAdmin.keyboardType = UIKeyboardTypeNumberPad;
    [self.loginAdmin addSubview:ineView];
    self.loginAdmin.delegate = self;
    [self.loginAdmin becomeFirstResponder];
    self.loginAdmin.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginAdmin.clearsOnBeginEditing = NO;
    if (oldName) {
        self.loginAdmin.text = oldName;
    }
    //设置密码输入框的底线
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(0,self.loginPassword.bounds.size.height-1, self.loginAdmin.bounds.size.width, 1)];
    ineViews.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    //键盘设置
    self.loginPassword.keyboardType = UIKeyboardTypeASCIICapable;
    self.loginPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginPassword.delegate = self;
    //设置密码框
    [self.loginPassword setSecureTextEntry:YES];
    [self.loginPassword addSubview:ineViews];
    
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
    if (_loginPassword == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    if (toBeString.length>25) {
        return NO;
    }
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.loginAdmin resignFirstResponder];
    [self.loginPassword resignFirstResponder];
}
@end
