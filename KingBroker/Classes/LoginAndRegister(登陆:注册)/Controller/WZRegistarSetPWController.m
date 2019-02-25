//
//  WZRegistarSetPWController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "GKCover.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZLoadDateSeviceOne.h"
#import "NSString+LCExtension.h"
#import "WZNavigationController.h"
#import "WZRegistarSetPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"
#import <CloudPushSDK/CloudPushSDK.h>
@interface WZRegistarSetPWController ()<UITextFieldDelegate>
//标题一
@property(nonatomic,strong)UILabel *titleOne;
//标题二
@property(nonatomic,strong)UILabel *titleTwo;
//第一次密码label
@property(nonatomic,strong)UILabel *passWordLabelOne;
//密码
@property(nonatomic,strong)UITextField *registarPassWord;
//下划线
@property(nonatomic,strong)UIView *ineOne;
//显示密码
@property(nonatomic,strong)UIButton *showPWButtonOne;
//下划线
@property(nonatomic,strong)UIView *buttonIneOne;
//第二次密码label
@property(nonatomic,strong)UILabel *passWordLabelTwo;
//确认密码
@property(nonatomic,strong)UITextField *registarPassWordTwo;
//下划线
@property(nonatomic,strong)UIView *ineTwo;
//显示密码
@property(nonatomic,strong)UIButton *showPWButtonTwo;
//下划线
@property(nonatomic,strong)UIView *buttonIneTwo;
//提交按钮
@property(nonatomic,strong)UIButton *modifyPWButton;


@end

@implementation WZRegistarSetPWController
#pragma mark -lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置密码";
    
    [self.view addSubview:self.titleOne];
    [self.view addSubview:self.titleTwo];
    [self.view addSubview:self.passWordLabelOne];
    [self.view addSubview:self.registarPassWord];
    [self.view addSubview:self.ineOne];
    [self.view addSubview:self.showPWButtonOne];
    [self.view addSubview:self.buttonIneOne];
    [self.view addSubview:self.passWordLabelTwo];
    [self.view addSubview:self.registarPassWordTwo];
    [self.view addSubview:self.ineTwo];
    [self.view addSubview:self.showPWButtonTwo];
    [self.view addSubview:self.buttonIneTwo];
    [self.view addSubview:self.modifyPWButton];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewDidLayoutSubviews{
    [self.titleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(51);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+101);
        make.height.offset(18);
    }];
    [self.titleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(51);
        make.top.equalTo(self.titleOne.mas_bottom).offset(10);
        make.height.offset(14);
    }];
    [self.passWordLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.titleTwo.mas_bottom).offset(68);
        make.height.offset(12);
    }];
    [self.registarPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.passWordLabelOne.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-138);
    }];
    [self.ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.registarPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-138);
    }];
    [self.showPWButtonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarPassWord.mas_right).offset(11);
        make.top.equalTo(self.passWordLabelOne.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    [self.buttonIneOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ineOne.mas_right).offset(6);
        make.top.equalTo(self.registarPassWord.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    [self.passWordLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.ineOne.mas_bottom).offset(31);
        make.height.offset(12);
    }];
    [self.registarPassWordTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.passWordLabelTwo.mas_bottom);
        make.height.offset(38);
        make.width.offset(self.view.fWidth-138);
    }];
    [self.ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.registarPassWordTwo.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-138);
    }];
    [self.showPWButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registarPassWordTwo.mas_right).offset(11);
        make.top.equalTo(self.passWordLabelTwo.mas_bottom).offset(17);
        make.height.offset(7);
        make.width.offset(14);
    }];
    [self.buttonIneTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ineTwo.mas_right).offset(6);
        make.top.equalTo(self.registarPassWordTwo.mas_bottom);
        make.height.offset(1);
        make.width.offset(25);
    }];
    [self.modifyPWButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(57);
        make.top.equalTo(self.ineTwo.mas_bottom).offset(100);
        make.height.offset(45);
        make.width.offset(109);
    }];
}
#pragma mark -UITextFieldDelegate
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
    
    if (_registarPassWord == textField||_registarPassWordTwo == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    textField.text = toBeString;
    return NO;
}
#pragma mark -touchesDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_registarPassWord resignFirstResponder];
    [_registarPassWordTwo resignFirstResponder];
}
#pragma mark -点击事件
//修改密码-显示密码
-(void)showPw:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_registarPassWord setSecureTextEntry:YES];
    }else{
        [_registarPassWord setSecureTextEntry:NO];
    }
}
//修改密码-显示密码2
-(void)showPwTwo:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [_registarPassWordTwo setSecureTextEntry:YES];
    }else{
        [_registarPassWordTwo setSecureTextEntry:NO];
    }
}
//修改密码提交
-(void)modifyPWButton:(UIButton *)button{
   
    //第一次密码
    NSString *password = _registarPassWord.text;
    if (password.length<6||password.length>16) {
        [SVProgressHUD showInfoWithStatus:@"第一个密码格式错误"];
        return;
    }
    //第二次密码
    NSString *passwordTwo = _registarPassWordTwo.text;
    if (passwordTwo.length<6||passwordTwo.length>16) {
        [SVProgressHUD showInfoWithStatus:@"第二个密码格式错误"];
        return;
    }
    if(![password isEqual:passwordTwo]){
        [SVProgressHUD showInfoWithStatus:@"两次密码不一致"];
        return;
    }
    button.enabled = NO;
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"password"] = password;
    paraments[@"phone"] = _telphone;
    paraments[@"verificationCode"] = _YZM;
    paraments[@"parentPhone"] = _inviteCode;
    
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        button.enabled = YES;
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            //[SVProgressHUD showInfoWithStatus:@"注册成功"];
            //查询未读消息
            [self setloadData];
            NSMutableDictionary *regis = [dic valueForKey:@"data"];
            
            NSString *warnFlag = [regis valueForKey:@"warnFlag"];
            NSString *rewardPrice = [regis valueForKey:@"rewardPrice"];
            
            //将数据传入加入门店中
            WZNewJionStoreController *store = [[WZNewJionStoreController alloc] init];
            store.types = @"1";
            store.jionType = @"1";
            store.warnFlag = warnFlag;
            store.rewardPrice = rewardPrice;
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:store];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
            
            [CloudPushSDK addAlias:[regis valueForKey:@"id"] withCallback:^(CloudPushCallbackResult *res) {
                NSLog(@"绑定别名成功");
            }];
            //将数据持久化
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
            [defaults setObject:[regis valueForKey:@"companyName"] forKey:@"companyName"];
            [defaults setObject:[regis valueForKey:@"companyFlag"] forKey:@"companyFlag"];
            [defaults synchronize];
            //上传设备ID
            [self receivingNotification];
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        button.enabled = YES;
    } parament:paraments URL:@"/sysUser/register"];
    
}

#pragma mark-loadDate
//上传设备ID
-(void)receivingNotification{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //获取设备ID
    NSString *deviceId = [user objectForKey:@"deviceId"];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"appType"] = @"1";
    paraments[@"deviceCode"] = deviceId;
    paraments[@"deviceType"] = @"IOS";
    
    [WZLoadDateSeviceOne postUserInfosSuccess:^(NSDictionary *dic) {
        
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/app/loginCallback"];
}
//查询未读消息
-(void)setloadData{
    
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            NSString *count = [data valueForKey:@"count"] ;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:count forKey:@"newCount"];
            [defaults synchronize];
            
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/userMessage/read/notreadCount"];
}
#pragma mark-getter
-(UILabel *)titleOne{
    if (!_titleOne) {
        _titleOne = [[UILabel alloc] init];
        _titleOne.text = @"请编辑您的密码";
        _titleOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        _titleOne.textColor = UIColorRBG(51, 51, 51);
    }
    return _titleOne;
}
-(UILabel *)titleTwo{
    if (!_titleTwo) {
        _titleTwo = [[UILabel alloc] init];
        _titleTwo.text = @"建议您的新密码以字母和数字混合";
        _titleTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _titleTwo.textColor = UIColorRBG(153, 153, 153);
    }
    return _titleTwo;
}
-(UILabel *)passWordLabelOne{
    if (!_passWordLabelOne) {
        _passWordLabelOne = [[UILabel alloc] init];
        _passWordLabelOne.text = @"密码";
        _passWordLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _passWordLabelOne.textColor = UIColorRBG(51, 51, 51);
    }
    return _passWordLabelOne;
}
-(UITextField *)registarPassWord{
    if (!_registarPassWord) {
        _registarPassWord = [[UITextField alloc] init];
        _registarPassWord.placeholder = @"请输入6-16位数字或字母";
        _registarPassWord.textColor = UIColorRBG(51, 51, 51);
        _registarPassWord.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _registarPassWord.delegate = self;
        _registarPassWord.keyboardType = UIKeyboardTypeASCIICapable;
        [[_registarPassWord valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _registarPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_registarPassWord setSecureTextEntry:YES];
    }
    return _registarPassWord;
}
-(UIView *)ineOne{
    if (!_ineOne) {
        _ineOne = [[UIView alloc] init];
        _ineOne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _ineOne;
}
-(UIButton *)showPWButtonOne{
    if (!_showPWButtonOne) {
        _showPWButtonOne = [[UIButton alloc] init];
        [_showPWButtonOne setBackgroundImage:[UIImage imageNamed:@"zc_icon_2"] forState:UIControlStateNormal];
        [_showPWButtonOne setBackgroundImage:[UIImage imageNamed:@"zc_icon_1"] forState:UIControlStateSelected];
        [_showPWButtonOne addTarget:self action:@selector(showPw:) forControlEvents:UIControlEventTouchUpInside];
        [_showPWButtonOne setEnlargeEdgeWithTop:10 right:20 bottom:20 left:10];
    }
    return _showPWButtonOne;
}
-(UIView *)buttonIneOne{
    if (!_buttonIneOne) {
        _buttonIneOne = [[UIView alloc] init];
        _buttonIneOne.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _buttonIneOne;
}
-(UILabel *)passWordLabelTwo{
    if (!_passWordLabelTwo) {
        _passWordLabelTwo = [[UILabel alloc] init];
        _passWordLabelTwo.text = @"确认密码";
        _passWordLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _passWordLabelTwo.textColor = UIColorRBG(51, 51, 51);
    }
    return _passWordLabelTwo;
}
-(UITextField *)registarPassWordTwo{
    if (!_registarPassWordTwo) {
        _registarPassWordTwo = [[UITextField alloc] init];
        _registarPassWordTwo.placeholder = @"请再次输入密码";
        _registarPassWordTwo.textColor = UIColorRBG(51, 51, 51);
        _registarPassWordTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _registarPassWordTwo.delegate = self;
        _registarPassWordTwo.keyboardType = UIKeyboardTypeASCIICapable;
        [[_registarPassWordTwo valueForKey:@"_clearButton"] setImage:[UIImage imageNamed:@"close_dl"] forState:UIControlStateNormal];
        _registarPassWordTwo.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_registarPassWordTwo setSecureTextEntry:YES];
    }
    return _registarPassWordTwo;
}
-(UIView *)ineTwo{
    if (!_ineTwo) {
        _ineTwo = [[UIView alloc] init];
        _ineTwo.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _ineTwo;
}
-(UIButton *)showPWButtonTwo{
    if (!_showPWButtonTwo) {
        _showPWButtonTwo = [[UIButton alloc] init];
        [_showPWButtonTwo setBackgroundImage:[UIImage imageNamed:@"zc_icon_2"] forState:UIControlStateNormal];
        [_showPWButtonTwo setBackgroundImage:[UIImage imageNamed:@"zc_icon_1"] forState:UIControlStateSelected];
        [_showPWButtonTwo addTarget:self action:@selector(showPwTwo:) forControlEvents:UIControlEventTouchUpInside];
        [_showPWButtonTwo setEnlargeEdgeWithTop:10 right:20 bottom:20 left:10];
    }
    return _showPWButtonTwo;
}
-(UIView *)buttonIneTwo{
    if (!_buttonIneTwo) {
        _buttonIneTwo = [[UIView alloc] init];
        _buttonIneTwo.backgroundColor = UIColorRBG(255, 245, 177);
    }
    return _buttonIneTwo;
}
-(UIButton *)modifyPWButton{
    if (!_modifyPWButton) {
        _modifyPWButton = [[UIButton alloc] init];
        [_modifyPWButton setBackgroundImage:[UIImage imageNamed:@"zc_button"] forState:UIControlStateNormal];
        [_modifyPWButton setTitle:@"注册" forState:UIControlStateNormal];
        [_modifyPWButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _modifyPWButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _modifyPWButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        [_modifyPWButton addTarget:self action:@selector(modifyPWButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyPWButton;
}


@end
