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
@interface WZModifyPhoneController ()
//新手机号
@property (strong, nonatomic) IBOutlet UITextField *NEWPhone;
//验证码
@property (strong, nonatomic) IBOutlet UITextField *YZMPhone;
//获取验证码
@property (strong, nonatomic) IBOutlet UIButton *findYZM;
//提交
@property (strong, nonatomic) IBOutlet UIButton *comfilePhone;
//获取验证码
- (IBAction)findYZMS:(UIButton *)sender;
//修改手机号
- (IBAction)modifyPhone:(UIButton *)sender;

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
    _headHeight.constant = kApplicationStatusBarHeight+129;
    //设置发送验证码按钮
    self.findYZM.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    self.findYZM.layer.cornerRadius = 3.0;
    self.findYZM.layer.masksToBounds = YES;
    self.findYZM.enabled = NO;
    //设置提交按钮
    self.comfilePhone.layer.cornerRadius = 4.0;
    self.comfilePhone.layer.masksToBounds = YES;
    self.comfilePhone.backgroundColor = UIColorRBG(3, 133, 219);
    
    //设置账户的底线
    self.NEWPhone.placeholder = @"请输入新手机号";
    self.NEWPhone.textColor =  UIColorRBG(68, 68, 68);
    self.NEWPhone.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,self.NEWPhone.bounds.size.height-1, self.NEWPhone.bounds.size.width, 1)];
    ineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.NEWPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.NEWPhone addSubview:ineView];
    
    [self.NEWPhone addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //设置验证码输入框的底线
    self.YZMPhone.placeholder = @"输入验证码";
    self.YZMPhone.textColor =   UIColorRBG(68, 68, 68);
    self.YZMPhone.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(0,self.YZMPhone.bounds.size.height-1, self.YZMPhone.bounds.size.width, 1)];
    ineViews.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [self.YZMPhone addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //键盘设置
    self.YZMPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.YZMPhone addSubview:ineViews];
}
//文本框值改变事件
-(void)usernameTextFieldChanged:(UITextField *)sender{
    //判定获取验证码按钮是否亮起
    NSString *phone = _NEWPhone.text;
        if (phone.length == 11) {
            self.findYZM.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
            self.findYZM.enabled = YES;
            
        }else{
            self.findYZM.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
            self.findYZM.enabled = NO;
        }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


//点击验证码按钮
- (IBAction)findYZMS:(UIButton *)sender {
    
    //获取手机文本框的手机号码
    NSString  *phone = _NEWPhone.text;
   
    NSString *type = @"1";
    //判断手机格式是否正确
    //判断手机格式是否正确
    NSString *str = [phone substringToIndex:1];
    if (phone.length != 11 || ![str isEqual:@"1"]) {
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
                [self.findYZM setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.findYZM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.findYZM.enabled = YES;
                self.findYZM.backgroundColor = UIColorRBG(3, 133, 219);
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.findYZM setTitle:[NSString stringWithFormat:@"%.2d后重试", seconds] forState:UIControlStateNormal];
                [self.findYZM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.findYZM.enabled = NO;
                self.findYZM.backgroundColor = UIColorRBG(199, 199, 205);
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
     NSString *YZM = self.YZMPhone.text;
    //判断手机格式是否正确
    NSString *str = [NEWPhone substringToIndex:1];
    if (NEWPhone.length != 11 || ![str isEqual:@"1"]) {
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
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.NEWPhone resignFirstResponder];
    [self.YZMPhone resignFirstResponder];
}
@end
