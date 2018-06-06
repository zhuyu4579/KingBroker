//
//  WZSetFindPWView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSetFindPWView.h"
#import "UIViewController+WZFindController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
@interface WZSetFindPWView()<UITextFieldDelegate>
//用户名

@end
@implementation WZSetFindPWView

+(instancetype)SetNewPW{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark -提交数据
- (void)fromNewPassWord:(id)sender {
    UIButton *button = sender;
    button.enabled = NO;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //1.获取文本框内容
    NSString *password = self.NewPassWordText.text;
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"password"] = password;
    paraments[@"phone"] = _phone;
    paraments[@"verificationCode"] = _YZM;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/changPassword",URL];
    [mgr POST:url  parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            button.enabled = YES;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userDefaults dictionaryRepresentation];
            for (NSString *key in dic) {
                [userDefaults removeObjectForKey:key];
            }
            [userDefaults synchronize];
            //返回登录页面
            UIViewController *Vc = [UIViewController viewController:[self superview]];
            [NSString isCode:Vc.navigationController code:@"401"];
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
#pragma mark -设置按钮属性
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //设置显示密码按钮
    [self.NewPWShow setImage:[UIImage imageNamed:@"icon_yj"] forState:UIControlStateNormal];
    [self.NewPWShow setImage:[UIImage imageNamed:@"icon_yj_2"] forState:UIControlStateSelected];
    [self.NewPWShow addTarget:self action:@selector(showPWClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.NewPWShowOne setImage:[UIImage imageNamed:@"icon_yj"] forState:UIControlStateNormal];
    [self.NewPWShowOne setImage:[UIImage imageNamed:@"icon_yj_2"] forState:UIControlStateSelected];
    [self.NewPWShowOne addTarget:self action:@selector(showPWClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.NewPWShow setEnlargeEdge:20];
    [self.NewPWShowOne setEnlargeEdge:20];
    //设置注册按钮
        self.FromNewPassWord.layer.cornerRadius = 4.0;
        self.FromNewPassWord.layer.masksToBounds = YES;
        self.FromNewPassWord.tintColor = [UIColor whiteColor];
        self.FromNewPassWord.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    //设置文本框
    [self setTextFile];
}
#pragma mark -设置文本框属性
-(void)setTextFile{
    //设置密码框的底线
    self.NewPassWordText.placeholder = @"请输入6～16位密码";
    self.NewPassWordText.textColor =  UIColorRBG(68, 68, 68);
    self.NewPassWordText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,self.NewPassWordText.bounds.size.height-1, self.NewPassWordText.bounds.size.width, 1)];
    ineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.NewPassWordText.keyboardType = UIKeyboardTypeASCIICapable;
    [self.NewPassWordText addSubview:ineView];
    [self.NewPassWordText becomeFirstResponder];
    _NewPassWordText.delegate = self;
    //绑定值改变触发事件
    [self.NewPassWordText addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //设置成密码框
    [self.NewPassWordText setSecureTextEntry:YES];
    //设置输入框的底线
    self.AgainPassWordText.placeholder = @"再次输入密码";
    self.AgainPassWordText.textColor =  UIColorRBG(68, 68, 68);
    self.AgainPassWordText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(0,self.AgainPassWordText.bounds.size.height-1, self.AgainPassWordText.bounds.size.width, 1)];
    ineViews.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    _AgainPassWordText.delegate = self;
    //键盘设置
    self.AgainPassWordText.keyboardType = UIKeyboardTypeASCIICapable;
    [self.AgainPassWordText addSubview:ineViews];
    
    //绑定值改变触发事件
    [self.AgainPassWordText addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    //设置成密码框
    [self.AgainPassWordText setSecureTextEntry:YES];
}
#pragma mark -文本框值改变事件
-(void)usernameTextFieldChanged:(UITextField *)sender{
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    NSString *admin =  sender.text;
    NSInteger tag = sender.tag;
    UIButton *btu =(UIButton *) [Vc.view viewWithTag:(tag+1)];
    [btu setEnlargeEdge:20];
    if (admin.length==1) {
        [btu setImage:[UIImage imageNamed:@"clear-All"] forState:UIControlStateNormal];
        //绑定清楚点击事件
        [btu addTarget:self action:@selector(cleanAdmin:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (admin.length == 0) {
        [btu setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btu removeTarget:self action:@selector(cleanAdmin:) forControlEvents:UIControlEventTouchUpInside];
    }
    //判定下一步按钮是否亮起
    NSString *passOne = self.NewPassWordText.text;
    NSString *passTwo = self.AgainPassWordText.text;
    if(passOne.length == passTwo.length&&passOne.length>=6&&passOne.length<=16&&passTwo.length>=6&&passTwo.length<=16&&[passOne isEqualToString:passTwo]){
        self.FromNewPassWord.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
        [self.FromNewPassWord addTarget:self action:@selector(fromNewPassWord:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        self.FromNewPassWord.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
        [self.FromNewPassWord removeTarget:self action:@selector(fromNewPassWord:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}
#pragma mark -清除账号
- (void)cleanAdmin:(UIButton *)button{
    
    NSInteger tag = button.tag;
    if (tag == 11) {
        
        self.NewPassWordText.text = @"";
        
        [self usernameTextFieldChanged:self.NewPassWordText];
    }
    if (tag == 21) {
        self.AgainPassWordText.text = @"";
        
        [self usernameTextFieldChanged:self.AgainPassWordText];
    }
    self.FromNewPassWord.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.FromNewPassWord removeTarget:self action:@selector(fromNewPassWord:) forControlEvents:UIControlEventTouchUpInside];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.NewPassWordText resignFirstResponder];
    [self.AgainPassWordText resignFirstResponder];
}

#pragma mark -显示或者隐藏密码
-(void)showPWClick:(UIButton *)button{
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    UITextField *text =(UITextField *) [Vc.view viewWithTag:(tag-2)];
    
    if (!button.selected) {
        [text setSecureTextEntry:YES];
    }else{
        [text setSecureTextEntry:NO];
    }
}
@end
