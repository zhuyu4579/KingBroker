//
//  WZReadPassWordController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZReadPassWordController.h"
#import "WZfindPassWordController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
@interface WZReadPassWordController ()<UITextFieldDelegate>

@end

@implementation WZReadPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"修改绑定手机号码";
    _passWord.textColor =  UIColorRBG(68, 68, 68);
    _passWord.keyboardType = UIKeyboardTypeASCIICapable;
   _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWord.delegate = self;
    //设置密码框
    [_passWord setSecureTextEntry:YES];
    _nextButton.layer.cornerRadius = 4.0;
    _nextButton.backgroundColor = UIColorRBG(3, 133, 219);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_passWord resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)showPW:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
       [_passWord setSecureTextEntry:NO];
    }else{
       [_passWord setSecureTextEntry:YES];
    }
}
//下一步
- (IBAction)nextAction:(UIButton *)sender {
       NSString *password = _passWord.text;
    if (password.length<6 || password.length>16) {
        [SVProgressHUD showInfoWithStatus:@"密码格式错误"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *phone = [ user objectForKey:@"username"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"phone"] = phone;
    paraments[@"password"] = password;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/changPhoneValidate",URL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            WZfindPassWordController *findPassWord = [[WZfindPassWordController alloc] init];
            findPassWord.modityID = password;
            findPassWord.navigationItem.title = @"修改绑定手机";
            [self.navigationController pushViewController:findPassWord animated:YES];
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
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passWord resignFirstResponder];
}
@end
