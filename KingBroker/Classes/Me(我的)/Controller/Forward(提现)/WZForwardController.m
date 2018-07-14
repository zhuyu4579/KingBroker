//
//  WZForwardController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZForwardController.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import "WZForwardDetailedController.h"
#import "WZForwardWindowController.h"
#import "WZAuthenticationController.h"
#import "WZfindPassWordController.h"
#import "WZAddZFBAccountController.h"
@interface WZForwardController ()<UITextFieldDelegate>
//余额
@property(nonatomic,strong)UILabel *moneys;
//密码框
@property(nonatomic,strong)UITextField *password;
//总金额
@property(nonatomic,strong)NSString *price;
@end

@implementation WZForwardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.navigationItem.title = @"我的钱包";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(findDetailed) title:@"明细"];
    //创建内容
    [self createContent];
   
}
//请求数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/userCapital/userCapital",HTTPURL];
    
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *forwardPrice = [data valueForKey:@"forwardPrice"];
            _price = forwardPrice;
            if(![forwardPrice isEqual:@""]||forwardPrice){
                _moneys.text = [NSString stringWithFormat:@"¥%@",forwardPrice];
            }
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                [NSString isCode:self.navigationController code:code];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
-(void)createContent{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"money"];
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+109);
    }];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"钱包余额";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    [self.view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(23);
        make.height.offset(17);
    }];
    UILabel *moneys = [[UILabel alloc] init];
    moneys.text = @"¥0.00";
    moneys.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:40];
    _moneys = moneys;
    [self.view addSubview:moneys];
    [moneys mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).offset(23);
        make.height.offset(40);
    }];
    UIButton *forWaryButton = [[UIButton alloc] init];
    [forWaryButton setTitle:@"提现到支付宝" forState:UIControlStateNormal];
    [forWaryButton setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    forWaryButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    forWaryButton.backgroundColor = UIColorRBG(248, 248, 248);
    forWaryButton.layer.borderColor = UIColorRBG(221, 221, 221).CGColor;
    forWaryButton.layer.borderWidth = 1.0;
    forWaryButton.layer.cornerRadius = 4.0;
    forWaryButton.layer.masksToBounds = YES;
    [forWaryButton addTarget:self action:@selector(forWaryButtons) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forWaryButton];
    [forWaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(moneys.mas_bottom).offset(78);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(44);
    }];
}
//查看明细
-(void)findDetailed{
    WZForwardDetailedController *detailedVC = [[WZForwardDetailedController alloc] init];
    [self.navigationController pushViewController:detailedVC animated:YES];
}
//提现
-(void)forWaryButtons{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger idcardStatus = [[user objectForKey:@"idcardStatus"] integerValue];
    
    if (idcardStatus == 0||idcardStatus == 3) {
        //实名认证
        [self authentication];
    }else if(idcardStatus == 2){
        //验证输入密码
        [self validatePassWord];
    }else if(idcardStatus == 1){
        [SVProgressHUD showInfoWithStatus:@"实名认证中"];
    }
  
}
//验证输入密码提示框
-(void)validatePassWord{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.fSize = CGSizeMake(self.view.fWidth, 175);
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"clear-icon"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeTK) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(18);
        make.width.offset(19);
        make.height.offset(19);
    }];
    UILabel *labelOne  = [[UILabel alloc] init];
    labelOne.text = @"输入登录密码，验证身份";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(19);
        make.height.offset(17);
    }];
    //丑陋的分割线
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(labelOne.mas_bottom).offset(10);
        make.height.offset(1);
        make.width.offset(view.fWidth-30);
    }];
    UITextField *password = [[UITextField alloc] init];
    password.placeholder = @"6-16位数字和字母";
    password.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    password.borderStyle = UITextBorderStyleNone;
    password.keyboardType = UIKeyboardTypeASCIICapable;
    [password setSecureTextEntry:YES];
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.delegate = self;
    _password = password;
    [view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(ineOne.mas_bottom).offset(23);
        make.height.offset(40);
        make.width.offset(view.fWidth-85);
    }];
    UIButton *confirm = [[UIButton alloc] init];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm.backgroundColor = UIColorRBG(3, 133, 219);
    confirm.layer.cornerRadius = 3.0;
    confirm.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [confirm addTarget:self action:@selector(confirmPW) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(ineOne.mas_bottom).offset(29);
        make.height.offset(28);
        make.width.offset(55);
    }];
    //丑陋的分割线
    UIView *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(password.mas_bottom);
        make.height.offset(1);
        make.width.offset(view.fWidth-30);
    }];
    
    UIButton *findPassword = [[UIButton alloc] init];
    [findPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [findPassword setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    findPassword.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [findPassword addTarget:self action:@selector(findPassWord) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:findPassword];
    [findPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(ineTwo.mas_bottom).offset(10);
        make.height.offset(14);
        make.width.offset(55);
    }];
    [GKCover translucentWindowCenterCoverContent:view animated:YES];
    
}
//关闭弹框
-(void)closeTK{
    [GKCover hide];
}
//提交密码
-(void)confirmPW{
    [_password resignFirstResponder];
    NSString *password = _password.text;
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
    
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/changPhoneValidate",HTTPURL];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"phone"] = phone;
    paraments[@"password"] = password;
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [GKCover hide];
            //查询是否有支付宝账户
            [self findZFBAccount];
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
//实名认证
-(void)authentication{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"使用提现功能需实名认证"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"实名认证" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               WZAuthenticationController *authen = [[WZAuthenticationController alloc] init];
                                                               [self.navigationController pushViewController:authen animated:YES];
                                                           }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//查询支付宝账号
-(void)findZFBAccount{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/userPayAccount/payAccount",HTTPURL];
    
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *exist = [data valueForKey:@"exist"];
            if ([exist isEqual:@"1"]) {
                WZForwardWindowController *forwardVc = [[WZForwardWindowController alloc] init];
                forwardVc.ZFBName = [[data valueForKey:@"data"] valueForKey:@"payAccount"];
                forwardVc.detailPrice = _price;
                forwardVc.ID = [[data valueForKey:@"data"] valueForKey:@"id"];
                [self.navigationController pushViewController:forwardVc animated:YES];
            }else{
                [self NoZFBAlert];
            }
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
//提示框没有绑定支付宝账号
-(void)NoZFBAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"使用提现功能需添加本人支付宝账号"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"添加支付宝" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               WZAddZFBAccountController *addZFB = [[WZAddZFBAccountController alloc] init];
                                                               addZFB.navigationItem.title = @"添加支付宝账号";
                                                               addZFB.ID = @"";
                                                               [self.navigationController pushViewController:addZFB animated:YES];
                                                           }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//找回密码
-(void)findPassWord{
    [_password resignFirstResponder];
    WZfindPassWordController *findPassWord = [[WZfindPassWordController alloc] init];
    findPassWord.navigationItem.title = @"修改密码";
    [self.navigationController pushViewController:findPassWord animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //请求数据
    [self loadData];
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
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_password resignFirstResponder];
}
@end
