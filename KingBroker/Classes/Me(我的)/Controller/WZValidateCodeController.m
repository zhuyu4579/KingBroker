//
//  WZValidateCodeController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  修改手机号码-验证旧手机号
#import "GKCover.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZModifyPhoneController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZValidateCodeController.h"

@interface WZValidateCodeController ()<UITextFieldDelegate>
//手机号
@property(nonatomic,strong)NSString *telphone;
//定时器
@property(nonatomic,weak)NSTimer *timer;

@end

@implementation WZValidateCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"验证当前手机号";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [ user objectForKey:@"username"];
    _telphone = username;
    if (![_telphone isEqual:@""]) {
        NSString *top = [username substringToIndex:3];
        NSString *bottom = [username substringFromIndex:7];
        _telphoneLabel.text = [NSString stringWithFormat:@"请输入%@****%@收到的\n短信验证码",top,bottom];
    }
    _code.textColor = [UIColor clearColor];
    _code.keyboardType = UIKeyboardTypeNumberPad;
    _code.delegate = self;
    _code.tintColor= [UIColor clearColor];
    
    _findCode.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _findCode.layer.cornerRadius = 18.0;
    _findCode.backgroundColor = UIColorRBG(255, 224, 0);
    _findCode.layer.shadowColor = UIColorRBG(255, 204, 0).CGColor;
    _findCode.layer.shadowRadius = 5.0f;
    _findCode.layer.shadowOffset = CGSizeMake(0, 5);
    _findCode.layer.shadowOpacity = 0.32;
    
    [_telphoneButton setEnlargeEdge:44];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -失去焦点
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_code resignFirstResponder];
    return YES;
}
#pragma mark-获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
}
#pragma mark-文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_code == textField) {
        if (toBeString.length>6) {
            return NO;
        }
    }
    for (int i = 0; i<6; i++) {
        UILabel *label = [self.view viewWithTag:(10+i)];
        label.text = @"";
        UIView *view = [self.view viewWithTag:(20+i)];
        view.backgroundColor = UIColorRBG(51, 51, 51);
    }
    for (int i = 0 ; i<toBeString.length; i++) {
        UILabel *label = [self.view viewWithTag:(10+i)];
        NSString *str = [toBeString substringWithRange:NSMakeRange(i, 1)];
        label.text = str;
        UIView *view = [self.view viewWithTag:(20+toBeString.length-1)];
        view.backgroundColor = UIColorRBG(255, 224, 0);
    }
    if (toBeString.length == 6) {
        
        UIView *view = [[UIView alloc] init];
        [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"验证中"];
        [self performSelector:@selector(loadData) withObject:self afterDelay:0.3];
    }
    return YES;
}

#pragma mark-获取验证码
- (IBAction)findCodes:(UIButton *)sender {
    
    _findCode.userInteractionEnabled = NO;
    _findCode.backgroundColor = [UIColor clearColor];
    [_findCode setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    _findCode.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
    _findCode.layer.shadowOffset = CGSizeMake(0, 0);
    _findCode.layer.borderWidth = 1.0;
    
    //修改按钮内容倒计时一分钟
    [self openCountdown];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    paraments[@"telphone"] = _telphone;
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
#pragma mark -验证码倒计时
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
                _findCode.userInteractionEnabled = YES;
                [_findCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_findCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _findCode.backgroundColor = UIColorRBG(255, 224, 0);
                _findCode.layer.borderWidth = 0;
                _findCode.layer.shadowOffset = CGSizeMake(0, 5);
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [_findCode setTitle:[NSString stringWithFormat:@"还剩%.2ds", seconds] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark -请求数据
-(void)loadData{

    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    paraments[@"telphone"] = _telphone;
    paraments[@"smsCode"] = _code.text;
    NSString *url = [NSString stringWithFormat:@"%@/app/checkSmsCode",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
               [_code resignFirstResponder];
                WZModifyPhoneController *modifyPhone = [[WZModifyPhoneController alloc] init];
                modifyPhone.oldPhone = _telphone;
                modifyPhone.password = _passWord;
                modifyPhone.oldYZM = _code.text;
                modifyPhone.navigationItem.title = @"修改绑定手机";
                [self.navigationController pushViewController:modifyPhone animated:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
#pragma mark-客服
- (IBAction)playTelphone:(UIButton *)sender {
    NSString *phone = @"057188841808";
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_code resignFirstResponder];
   
}
@end
