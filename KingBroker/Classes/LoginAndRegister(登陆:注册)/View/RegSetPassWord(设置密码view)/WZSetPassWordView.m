//
//  WZSetPassWordView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSetPassWordView.h"
#import "UIViewController+WZFindController.h"
#import "WZJionStoreController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNavigationController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "JPUSHService.h"
@implementation WZSetPassWordView

+(instancetype)SetPWView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark -注册按钮
- (void)RegistarSuccess:(id)sender {
    UIButton *button = sender;
    UIViewController *Vc = [UIViewController viewController:self];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];

    //获取两个文本框的数据
    NSString *pass1 = _passWordOne.text;
    NSString *pass2 = _passWordTwo.text;
    //判断两次密码是否输入一样
    if (![pass1 isEqualToString:pass2]) {
        [SVProgressHUD showInfoWithStatus:@"密码不一致"];
        return;
    }
    _registDictionary[@"password"] = pass1;
    //创建会话请求
    button.enabled = NO;
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     mgr.requestSerializer.timeoutInterval = 60.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
   
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
     NSString *url = [NSString stringWithFormat:@"%@/sysUser/register",HTTPURL];
    [mgr POST:url parameters:_registDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSMutableDictionary *  _Nullable responseObject) {
        button.enabled = YES;
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"注册成功"];
            //加入门店
            WZJionStoreController *JionVc = [[WZJionStoreController alloc] init];
             WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionVc];
            JionVc.type = @"1";
            JionVc.types= @"1";
            [Vc.navigationController presentViewController:nav animated:YES completion:nil];
            //将数据传入加入门店中
            NSMutableDictionary *regis = [responseObject valueForKey:@"data"];
            [JPUSHService setAlias:[regis valueForKey:@"id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode == 0) {
                    NSLog(@"添加别名成功");
                }
            } seq:1];

            //将uuid 持久化
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
            [defaults synchronize];
            //传值给上一个页面
            if (_setPWBlock) {
                JionVc.registarBlock = ^(NSString *state) {
                    if (!state) {
                        _storeStare = state;
                        regis[@"realtorStatus"] = state;
                    }
                    _setPWBlock(regis);
                };
            }
            
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
#pragma mark -设置按钮
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //设置显示密码按钮
    [self.showPassWordOne setImage:[UIImage imageNamed:@"icon_yj"] forState:UIControlStateNormal];
    [self.showPassWordOne setImage:[UIImage imageNamed:@"icon_yj_2"] forState:UIControlStateSelected];
    [self.showPassWordOne addTarget:self action:@selector(showPWButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showPassWordS setImage:[UIImage imageNamed:@"icon_yj"] forState:UIControlStateNormal];
    [self.showPassWordS setImage:[UIImage imageNamed:@"icon_yj_2"] forState:UIControlStateSelected];
    [self.showPassWordS addTarget:self action:@selector(showPWButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showPassWordOne setEnlargeEdge:20];
    [self.showPassWordS setEnlargeEdge:20];
    //设置注册按钮
    self.setRegistarButton.layer.cornerRadius = 4.0;
    self.setRegistarButton.layer.masksToBounds = YES;
    self.setRegistarButton.tintColor = [UIColor whiteColor];
    self.setRegistarButton.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    //设置文本框
    [self setTextFile];
}
#pragma mark -设置文本框属性
-(void)setTextFile{
    //设置密码框的底线
    self.passWordOne.placeholder = @"请输入6～16位密码";
    self.passWordOne.textColor =  [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    self.passWordOne.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,self.passWordOne.bounds.size.height-1, self.passWordOne.bounds.size.width, 1)];
    ineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.passWordOne.keyboardType = UIKeyboardTypeASCIICapable;
    [self.passWordOne addSubview:ineView];
    [self.passWordOne becomeFirstResponder];
    [self.passWordOne addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordOne setSecureTextEntry:YES];
    //设置再次输入密码框的底线
    self.passWordTwo.placeholder = @"请再次输入密码";
    self.passWordTwo.textColor =  [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    self.passWordTwo.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(0,self.passWordTwo.bounds.size.height-1, self.passWordTwo.bounds.size.width, 1)];
    ineViews.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    //键盘设置
    self.passWordTwo.keyboardType = UIKeyboardTypeASCIICapable;
    [self.passWordTwo addSubview:ineViews];
    [self.passWordTwo addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordTwo setSecureTextEntry:YES];
}
//文本框值改变事件
-(void)usernameTextFieldChanged:(UITextField *)sender{
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    NSString *admin =  sender.text;
    NSInteger tag = sender.tag;
    UIButton *btu =(UIButton *) [Vc.view viewWithTag:(tag+1)];
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
    NSInteger passOne = self.passWordOne.text.length;
    NSInteger passTwo = self.passWordTwo.text.length;
    if(passOne == passTwo&&passOne>=6&&passOne<=16&&passTwo>=6&&passTwo<=16){
        self.setRegistarButton.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
        [self.setRegistarButton addTarget:self action:@selector(RegistarSuccess:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        self.setRegistarButton.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
        [self.setRegistarButton removeTarget:self action:@selector(RegistarSuccess:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
#pragma mark -清除账号
- (void)cleanAdmin:(UIButton *)button{
    
    NSInteger tag = button.tag;
    if (tag == 11) {
        
        self.passWordOne.text = @"";
        
        [self usernameTextFieldChanged:self.passWordOne];
    }
    if (tag == 21) {
        self.passWordTwo.text = @"";
        
        [self usernameTextFieldChanged:self.passWordTwo];
    }
    self.setRegistarButton.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.setRegistarButton removeTarget:self action:@selector(RegistarSuccess:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passWordOne resignFirstResponder];
    [self.passWordTwo resignFirstResponder];
}
-(void)showPWButtonClick:(UIButton *)button{
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
