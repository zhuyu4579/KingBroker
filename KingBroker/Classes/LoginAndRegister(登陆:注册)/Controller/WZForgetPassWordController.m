//
//  WZForgetPassWordController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZFrogetSetPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZForgetPassWordController.h"

@interface WZForgetPassWordController ()<UITextFieldDelegate>
//注册的用户名
@property(nonatomic,strong)UITextField *registarName;
//注册的验证码
@property(nonatomic,strong)UITextField *registarYZM;
//注册-获取验证码
@property(nonatomic,strong)UIButton *YZMButton;
//定时器
@property(nonatomic,weak)NSTimer *timer;
@end

@implementation WZForgetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    //创建控件
    [self createControl];
}
#pragma mark -创建控件
-(void)createControl{
    UILabel *title = [[UILabel alloc] init];
    title.text = @"请输入你注册的手机号";
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    title.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(51);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+101);
        make.height.offset(18);
    }];
    UILabel *telLabel = [[UILabel alloc] init];
    telLabel.text = @"手机号";
    telLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telLabel.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:telLabel];
    [telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(title.mas_bottom).offset(92);
        make.height.offset(12);
    }];
    UITextField *telphone = [[UITextField alloc] init];
    telphone.placeholder = @"请输入手机号";
    telphone.textColor = UIColorRBG(51, 51, 51);
    telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telphone.delegate = self;
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    [[telphone valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    telphone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _registarName = telphone;
    [self.view addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(telLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-107);
    }];
    //下划线
    UIView  *registarIne = [[UIView alloc] init];
    registarIne.backgroundColor = UIColorRBG(255, 245, 177);
    [self.view addSubview:registarIne];
    [registarIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(telphone.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-107);
    }];
    UILabel *YZMLabel = [[UILabel alloc] init];
    YZMLabel.text = @"验证码";
    YZMLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    YZMLabel.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:YZMLabel];
    [YZMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(registarIne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    //验证码
    UITextField *registarYZM = [[UITextField alloc] init];
    registarYZM.placeholder = @"请输入验证码";
    registarYZM.textColor = UIColorRBG(51, 51, 51);
    registarYZM.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    registarYZM.delegate = self;
    registarYZM.keyboardType = UIKeyboardTypeNumberPad;
    [[registarYZM valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
    registarYZM.clearButtonMode = UITextFieldViewModeWhileEditing;
    _registarYZM = registarYZM;
    [self.view addSubview:registarYZM];
    [registarYZM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(YZMLabel.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-205);
    }];
    //下划线
    UIView  *registarInes = [[UIView alloc] init];
    registarInes.backgroundColor = UIColorRBG(255, 245, 177);
    [self.view addSubview:registarInes];
    [registarInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(registarYZM.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-205);
    }];
    //获取验证码
    UIButton *findYZM = [[UIButton alloc] init];
    [findYZM setTitle:@"获取验证码" forState:UIControlStateNormal];
    [findYZM setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
    findYZM.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    findYZM.layer.cornerRadius = 12;
    findYZM.layer.masksToBounds = YES;
    findYZM.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
    findYZM.layer.borderWidth = 1.0;
    [findYZM addTarget:self action:@selector(findYZM:) forControlEvents:UIControlEventTouchUpInside];
    _YZMButton = findYZM;
    [self.view addSubview:findYZM];
    [findYZM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registarYZM.mas_right).offset(18);
        make.top.equalTo(YZMLabel.mas_bottom).offset(13);
        make.height.offset(24);
        make.width.offset(80);
    }];
    //下一步
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(registarInes.mas_bottom).offset(100);
        make.height.offset(45);
        make.width.offset(109);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"收不到验证码？";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    label.textColor = UIColorRBG(199, 199, 205);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-22);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49-JF_BOTTOM_SPACE);
        make.height.offset(11);
    }];
    //人工
    UIButton *buttonLabel = [[UIButton alloc] init];
    [buttonLabel setTitle:@"人工客服" forState:UIControlStateNormal];
    [buttonLabel setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
    buttonLabel.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    [buttonLabel addTarget:self action:@selector(buttonLabel) forControlEvents:UIControlEventTouchUpInside];
    [buttonLabel setEnlargeEdge:44];
    [self.view addSubview:buttonLabel];
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44-JF_BOTTOM_SPACE);
        make.height.offset(21);
        make.width.offset(45);
    }];
}
#pragma mark -获取验证码
-(void)findYZM:(UIButton *)button{
    NSString *telphone = _registarName.text;
    if ([telphone isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
        return;
    }
    NSString *str = [telphone substringToIndex:1];
    if (telphone.length != 11 || ![str isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    //修改按钮内容倒计时一分钟
    [self openCountdown];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"3";
    paraments[@"telphone"] = telphone;
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
                [_YZMButton setTitle:@"重新发送" forState:UIControlStateNormal];
                [_YZMButton setTitleColor:UIColorRBG(255, 204, 0) forState:UIControlStateNormal];
                _YZMButton.userInteractionEnabled = YES;
                _YZMButton.layer.borderColor = UIColorRBG(255, 204, 0).CGColor;
                _YZMButton.layer.borderWidth = 1.0;
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                _YZMButton.userInteractionEnabled = NO;
                //设置按钮显示读秒效果
                [_YZMButton setTitle:[NSString stringWithFormat:@"还剩%.2ds", seconds] forState:UIControlStateNormal];
                [_YZMButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
                _YZMButton.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
                _YZMButton.layer.borderWidth = 1.0;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark -下一步
-(void)next{
    NSString *telphone = _registarName.text;
    if ([telphone isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
        return;
    }
    NSString *str = [telphone substringToIndex:1];
    if (telphone.length != 11 || ![str isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"手机号格式错误"];
        return;
    }
    NSString *YZM = _registarYZM.text;
    if (YZM.length != 6) {
        [SVProgressHUD showInfoWithStatus:@"验证码格式不正确"];
        return;
    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"3";
    paraments[@"telphone"] = telphone;
    paraments[@"smsCode"] = YZM;
    NSString *url = [NSString stringWithFormat:@"%@/app/checkSmsCode",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            WZFrogetSetPWController *setPw = [[WZFrogetSetPWController alloc] init];
            setPw.navigationItem.title = @"设置密码";
            setPw.telphone = telphone;
            setPw.YZM = YZM;
           [self.navigationController pushViewController:setPw animated:YES];
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
#pragma mark-人工客服
-(void)buttonLabel{
    NSString *phone = @"057188841808";
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    
    if (_registarName == textField) {
        if (toBeString.length>11) {
            return NO;
        }
    }
    if (_registarYZM == textField) {
        if (toBeString.length>6) {
            return NO;
        }
    }
    textField.text = toBeString;
    return NO;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_registarName resignFirstResponder];
    [_registarYZM resignFirstResponder];
}
@end
