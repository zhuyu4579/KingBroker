//
//  WZAddZFBAccountController.m
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
#import "NSString+LCExtension.h"
#import "WZForwardController.h"
#import "WZAddZFBAccountController.h"

@interface WZAddZFBAccountController ()<UITextFieldDelegate>

@end

@implementation WZAddZFBAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    
    //创建内容
    [self createContents];
}
//创建内容
-(void)createContents{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realname = [ user objectForKey:@"realname"];
    UILabel *lanbelOne = [[UILabel alloc] init];
    lanbelOne.textColor = UIColorRBG(135, 134, 140);
    lanbelOne.text = @"为了资金安全，只能绑定当前实名认证人的支付宝";
    lanbelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [self.view addSubview:lanbelOne];
    [lanbelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight + 70);
        make.height.offset(14);
    }];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(lanbelOne.mas_bottom).offset(10);
        make.height.offset(92);
        make.width.offset(self.view.fWidth);
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"姓         名";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(16);
    }];
    UILabel *name = [[UILabel alloc] init];
    name.text = realname;
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    name.textColor = UIColorRBG(153, 153, 153);
    [view addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(28);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(16);
    }];
    //猥琐的分割线
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(name.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(view.fWidth-15);
    }];
    UILabel *ZFBLabel = [[UILabel alloc] init];
    ZFBLabel.text = @"支付宝账号";
    ZFBLabel.textColor = UIColorRBG(51, 51, 51);
    ZFBLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [view addSubview:ZFBLabel];
    [ZFBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(ineOne.mas_bottom).offset(15);
        make.height.offset(16);
    }];
    UITextField *ZFBName = [[UITextField alloc] init];
    ZFBName.placeholder = @"点击输入";
    ZFBName.textColor = UIColorRBG(51, 51, 51);
    ZFBName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
    ZFBName.keyboardType = UIKeyboardTypeDefault;
    ZFBName.clearButtonMode = UITextFieldViewModeWhileEditing;
    ZFBName.delegate = self;
    _ZFBName = ZFBName;
    [view addSubview:ZFBName];
    [ZFBName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ZFBLabel.mas_right).offset(28);
        make.top.equalTo(ineOne.mas_bottom);
        make.height.offset(46);
        make.right.equalTo(view.mas_right);
    }];
    //确定按钮
    UIButton *confirm = [[UIButton alloc] init];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm.backgroundColor = UIColorRBG(3, 133, 219);
    confirm.layer.cornerRadius = 4.0;
    confirm.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [confirm addTarget:self action:@selector(confirmZFB:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(view.mas_bottom).offset(153);
        make.height.offset(44);
        make.width.offset(self.view.fWidth-30);
    }];
}
//确定
-(void)confirmZFB:(UIButton *)button{
    NSString *str = _ZFBName.text;
    if ([str isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"支付宝账号不能为空"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *realname = [ user objectForKey:@"realname"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/userPayAccount/addorUpdate",HTTPURL];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"payAccount"] = str;
    paraments[@"accountName"] = realname;
    paraments[@"payeeType"] = @"1";
    paraments[@"type"] = @"1";
    paraments[@"id"] = _ID;
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [SVProgressHUD showWithStatus:@"提交中"];
    button.enabled = NO;
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        button.enabled = YES;
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"绑定成功"];
            for (UIViewController *subVC in self.navigationController.viewControllers) {
                
                if ([subVC isKindOfClass:[WZForwardController class]]) {
                    
                    [self.navigationController popToViewController:(WZForwardController *)subVC animated:YES];
                    
                }
                
            }
            
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
        button.enabled = YES;
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
    
    [_ZFBName resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
