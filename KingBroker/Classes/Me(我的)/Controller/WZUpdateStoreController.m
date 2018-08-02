//
//  WZUpdateStoreController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZUpdateStoreController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
@interface WZUpdateStoreController ()
@property(nonatomic,strong)NSString *username;
@end

@implementation WZUpdateStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    _headHeight.constant = kApplicationStatusBarHeight+152;
    self.navigationItem.title = @"更换门店";
    //设置属性
    [self setupAttribute];
    
}
-(void)setupAttribute{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [ user objectForKey:@"username"];
    _username = username;
    NSString *top = [username substringToIndex:3];
    NSString *bottom = [username substringFromIndex:7];
    _telphone.text = [NSString stringWithFormat:@"请输入%@****%@收到的短信验证码",top,bottom];
    _telphone.textColor = UIColorRBG(68, 68, 68);
    _verificationCode.textColor = UIColorRBG(68, 68, 68);
    _verificationCode.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifictionButton.layer.cornerRadius = 4.0;
    _verifictionButton.backgroundColor = UIColorRBG(3, 133, 219);
    [_verifictionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius = 4.0;
    _nextButton.backgroundColor = UIColorRBG(3, 133, 219);
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//获取验证码
- (IBAction)ObtainVerificationCode:(UIButton *)sender {
    //获取手机文本框的手机号码
    NSString  *phone = _username;
    //判断手机格式是否正确
    if (phone.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    [self openCountdown];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"5";
    paraments[@"telphone"] = phone;
    NSString *url = [NSString stringWithFormat:@"%@/app/read/sendSmsByType",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"已发送"];
            //修改按钮内容倒计时一分钟
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
// 开启倒计时效果
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
                [self.verifictionButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.verifictionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.verifictionButton.userInteractionEnabled = YES;
                self.verifictionButton.backgroundColor = UIColorRBG(3, 133, 219);
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.verifictionButton setTitle:[NSString stringWithFormat:@"%.2d后重试", seconds] forState:UIControlStateNormal];
                [self.verifictionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.verifictionButton.userInteractionEnabled = NO;
                self.verifictionButton.backgroundColor = UIColorRBG(199, 199, 205);
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)nextAction:(UIButton *)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //获取手机文本框的手机号码
    NSString  *phone = _username;
    //判断手机格式是否正确
    if (phone.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    NSString *verification = _verificationCode.text;
    if (verification.length != 6) {
        [SVProgressHUD showInfoWithStatus:@"验证码格式错误"];
        return;
    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"telphone"] = phone;
    paraments[@"type"] = @"5";
    paraments[@"smsCode"] = verification;
    NSString *url = [NSString stringWithFormat:@"%@/app/checkSmsCode",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            WZJionStoreController *JionStore = [[WZJionStoreController alloc] init];
            JionStore.type = @"2";
            JionStore.navigationItem.title = @"更换门店";
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                
                [NSString isCode:self.navigationController code:code];
                //更新指定item
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];;
                item.badgeValue= nil;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.verificationCode resignFirstResponder];
}
@end
