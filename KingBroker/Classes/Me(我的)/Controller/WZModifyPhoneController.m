//
//  WZModifyPhoneController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZModifyPhoneController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZModifyPhoneController ()<UITextFieldDelegate>
//新手机号
@property (strong, nonatomic) IBOutlet UITextField *NEWPhone;
//验证码
@property (strong, nonatomic) IBOutlet UITextField *YZMPhone;
//获取验证码
@property (strong, nonatomic) IBOutlet UIButton *findYZM;
//提交
@property (strong, nonatomic) IBOutlet UIButton *comfilePhone;
@property (strong, nonatomic) IBOutlet UIButton *telphoneButton;

//获取验证码
- (IBAction)findYZMS:(UIButton *)sender;
//修改手机号
- (IBAction)modifyPhone:(UIButton *)sender;
//客服
- (IBAction)playTelphone:(UIButton *)sender;

@end

@implementation WZModifyPhoneController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    //设置控件属性
    [self setController];
}
//设置控件属性
-(void)setController{
    //设置发送验证码按钮
    [self.findYZM setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
    self.findYZM.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
    self.findYZM.layer.borderWidth = 1.0;
    self.findYZM.layer.cornerRadius = 12.0;
    //设置提交按钮
    self.comfilePhone.layer.cornerRadius = 18.0;
    self.comfilePhone.backgroundColor = UIColorRBG(255, 224, 0);
    self.comfilePhone.layer.shadowColor = UIColorRBG(255, 204, 0).CGColor;
    self.comfilePhone.layer.shadowRadius = 5.0f;
    self.comfilePhone.layer.shadowOffset = CGSizeMake(0, 5);
    self.comfilePhone.layer.shadowOpacity = 0.32;
    //设置账户
    self.NEWPhone.placeholder = @"请输入新手机号";
    self.NEWPhone.textColor =  UIColorRBG(68, 68, 68);
    self.NEWPhone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.NEWPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.NEWPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[_NEWPhone valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    self.NEWPhone.delegate = self;
    //设置验证码输入框
    self.YZMPhone.textColor =   UIColorRBG(68, 68, 68);
    self.YZMPhone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    //键盘设置
    self.YZMPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.YZMPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[_YZMPhone valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    self.YZMPhone.delegate = self;
    
    [self.telphoneButton setEnlargeEdge:44];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//点击验证码按钮
- (IBAction)findYZMS:(UIButton *)sender {
    
    //获取手机文本框的手机号码
    NSString  *phone = _NEWPhone.text;
    
    NSString *type = @"2";
    //判断手机格式是否正确
    if (phone.length != 11 ) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    NSString *str = [phone substringToIndex:1];
    if (![str isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    //修改按钮内容倒计时一分钟
    [self openCountdown];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 60;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = type;
    paraments[@"telphone"] = phone;
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
                [self.findYZM setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.findYZM setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
                self.findYZM.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.findYZM setTitle:[NSString stringWithFormat:@"还剩%.2ds", seconds] forState:UIControlStateNormal];
                [self.findYZM setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
                self.findYZM.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
//点击提交
- (IBAction)modifyPhone:(UIButton *)sender {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //获取新的手机号码
    NSString *NEWPhone = _NEWPhone.text;
    NSString *YZM = _YZMPhone.text;
    //判断手机格式是否正确
    if (NEWPhone.length != 11 ) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    NSString *str = [NEWPhone substringToIndex:1];
    if (![str isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    if (YZM.length!=6) {
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
    paraments[@"oldPhone"] = _oldPhone;
    paraments[@"phone"] = NEWPhone;
    paraments[@"password"] = _password;
    paraments[@"verificationCode"] = YZM;
    paraments[@"oldVerificationCode"] = _oldYZM;
    NSLog(@"%@",paraments);
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/changPhone",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
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
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_NEWPhone == textField) {
        if (toBeString.length>11) {
            return NO;
        }
    }
    if (_YZMPhone == textField) {
        if (toBeString.length>6) {
            return NO;
        }
    }
    return YES;
}
#pragma mark -客服
- (IBAction)playTelphone:(UIButton *)sender {
    NSString *phone = @"057188841808";
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.NEWPhone resignFirstResponder];
    [self.YZMPhone resignFirstResponder];
}
@end
