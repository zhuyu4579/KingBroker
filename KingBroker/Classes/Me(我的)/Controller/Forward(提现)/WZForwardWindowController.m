//
//  WZForwardWindowController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZForwardController.h"
#import "NSString+LCExtension.h"
#import "WZNavigationController.h"
#import "WZAddZFBAccountController.h"
#import "WZForwardWindowController.h"
#import "WZForwardSuccessController.h"
@interface WZForwardWindowController ()<UITextFieldDelegate>
//输入金额
@property(nonatomic,strong)UITextField *prices;
//警告
@property(nonatomic,strong)UILabel *waring;
//确定按钮
@property(nonatomic,strong)UIButton *confirm;

@end

@implementation WZForwardWindowController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"提现";
    //创建内容
    [self createContent];
    
    //添加接收通知的观察者(popToB事件)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiPopToB) name:@"popToB" object:nil];
}
-(void)notiPopToB

{
    
    for (UIViewController *subVC in self.navigationController.viewControllers) {
        
        if ([subVC isKindOfClass:[WZForwardController class]]) {
            
            [self.navigationController popToViewController:(WZForwardController *)subVC animated:YES];
            
        }
        
    }
    
}
//创建内容
-(void)createContent{
    
    UIView *viewOne = [[UIView alloc] init];
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight + 60);
        make.width.offset(self.view.fWidth);
        make.height.offset(50);
    }];
    UILabel *ZFBLabel = [[UILabel alloc] init];
    ZFBLabel.text = @"支付宝账号";
    ZFBLabel.textColor = UIColorRBG(51, 51, 51);
    ZFBLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [viewOne addSubview:ZFBLabel];
    [ZFBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.top.equalTo(viewOne.mas_top).offset(17);
        make.height.offset(16);
    }];
    UILabel *ZFBName = [[UILabel alloc] init];
    ZFBName.textColor = UIColorRBG(153, 153, 153);
    ZFBName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
     ZFBName.text = _ZFBName;
    [viewOne addSubview:ZFBName];
    [ZFBName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ZFBLabel.mas_right).offset(28);
        make.top.equalTo(viewOne.mas_top).offset(17);
        make.height.offset(16);
    }];
    UIButton *updateButton = [[UIButton alloc] init];
    [updateButton setTitle:@"修改" forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateButton.backgroundColor = UIColorRBG(3, 133, 219);
    updateButton.layer.cornerRadius = 3.0;
    updateButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [updateButton addTarget:self action:@selector(updateButton) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:updateButton];
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right).offset(-15);
        make.top.equalTo(viewOne.mas_top).offset(11);
        make.height.offset(28);
        make.width.offset(55);
    }];
    UIView *viewTwo = [[UIView alloc] init];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTwo];
    [viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(viewOne.mas_bottom).offset(15);
        make.width.offset(self.view.fWidth);
        make.height.offset(120);
    }];
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"提现金额(免收手续费)";
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    labelTitle.textColor = UIColorRBG(153, 153, 153);
    [viewTwo addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_top).offset(15);
        make.height.offset(11);
    }];
    UILabel *priceTitle = [[UILabel alloc] init];
    priceTitle.text = @"¥";
    priceTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:35];
    [viewTwo addSubview:priceTitle];
    [priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(labelTitle.mas_bottom).offset(26);
        make.height.offset(25);
    }];
    UITextField *price = [[UITextField alloc] init];
    price.placeholder = @"输入金额";
    price.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:25];
    price.keyboardType = UIKeyboardTypeDecimalPad;
    price.borderStyle = UITextBorderStyleNone;
    price.clearButtonMode = UITextFieldViewModeWhileEditing;
    price.delegate = self;
    [price addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventEditingChanged];
    _prices = price;
    [viewTwo addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceTitle.mas_right).offset(14);
        make.top.equalTo(labelTitle.mas_bottom).offset(16);
        make.height.offset(45);
        make.right.equalTo(viewTwo.mas_right);
    }];
    //华丽的分割线
    UIView *ineOnes = [[UIView alloc] init];
    ineOnes.backgroundColor = UIColorRBG(242, 242, 242);
    [viewTwo addSubview:ineOnes];
    [ineOnes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(priceTitle.mas_bottom).offset(10);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-30);
    }];
    //可提现金额
    UILabel *detailPrice = [[UILabel alloc] init];
    detailPrice.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    detailPrice.textColor = UIColorRBG(153, 153, 153);
    detailPrice.text = [NSString stringWithFormat:@"可提现金额%@元",_detailPrice];
    _waring = detailPrice;
    [viewTwo addSubview:detailPrice];
    [detailPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(ineOnes.mas_bottom).offset(9);
        make.height.offset(13);
    }];
   
    UIButton *allPrice = [[UIButton alloc] init];
    [allPrice setTitle:@"全部提现" forState:UIControlStateNormal];
    [allPrice setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    allPrice.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [allPrice addTarget:self action:@selector(allPrice) forControlEvents:UIControlEventTouchUpInside];
    [viewTwo addSubview:allPrice];
    [allPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTwo.mas_right).offset(-15);
        make.top.equalTo(ineOnes.mas_bottom).offset(9);
        make.height.offset(14);
        make.width.offset(55);
    }];
    //确定按钮
    UIButton *confirm = [[UIButton alloc] init];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm.backgroundColor = UIColorRBG(3, 133, 219);
    confirm.layer.cornerRadius = 4.0;
    _confirm = confirm;
    confirm.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [confirm addTarget:self action:@selector(confirmZFB:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_bottom).offset(54);
        make.height.offset(44);
        make.width.offset(self.view.fWidth-30);
    }];
}
//文本框改变
-(void)changeContent:(UITextField *)textField{
    NSString *str = textField.text;
    if (![str isEqual:@""]) {
        if( ![self isPureInt:str] && ![self isPureFloat:str])
        {
            _waring.text = @"金额中包含非法字符";
            _waring.textColor = [UIColor redColor];
            return;
        }
        float n = [_detailPrice floatValue];
        float m = [str integerValue];
        if ( m > n) {
            _waring.text = @"金额已超过可提现金额";
            _waring.textColor = [UIColor redColor];
            _confirm.enabled = NO;
            return;
        }
    }
    
    _waring.text = [NSString stringWithFormat:@"可提现金额%@元",_detailPrice];
    _waring.textColor = UIColorRBG(153, 153, 153);
    _confirm.enabled = YES;
}
//修改支付宝账号
-(void)updateButton{
    WZAddZFBAccountController *addZFB = [[WZAddZFBAccountController alloc] init];
    addZFB.navigationItem.title = @"修改支付宝账号";
    addZFB.ZFBName.text = _ZFBName;
    addZFB.ID = _ID;
    [self.navigationController pushViewController:addZFB animated:YES];
}
//全部提现
-(void)allPrice{
    _prices.text = _detailPrice;
}
//提交
-(void)confirmZFB:(UIButton *)button{
    [_prices resignFirstResponder];
    NSString *str = _prices.text;
    if ([str isEqual:@""] || [str intValue] == 0) {
        [SVProgressHUD showInfoWithStatus:@"输入金额有误"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/withdrawCash/token",HTTPURL];

    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *token = [data valueForKey:@"token"];
            [self loadData:token];
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
//数据的提交
-(void)loadData:(NSString *)token{
     
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/withdrawCash/add",HTTPURL];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"serviceCharge"] = @"0";
    paraments[@"actualAmount"] = _prices.text;
    paraments[@"payAccount"] = _ZFBName;
    paraments[@"type"] = @"1";
    paraments[@"payType"] = @"1";
    paraments[@"token"] = token;
    
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [SVProgressHUD showWithStatus:@"提交中"];
    _confirm.enabled = NO;
    
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        _confirm.enabled = YES;
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            WZForwardSuccessController *forwardSuccess = [[WZForwardSuccessController alloc] init];
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:forwardSuccess];
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
        [GKCover hide];
        _confirm.enabled = YES;
        [SVProgressHUD dismiss];
    }];
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
    
    [_prices resignFirstResponder];
}
//判断是否是浮点数
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}
//判断是否为整形：

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
@end
