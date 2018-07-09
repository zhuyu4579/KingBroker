//
//  WZHaveCodeView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHaveCodeView.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIViewController+WZFindController.h"
#import "WZTabBarController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "GKCover.h"
@interface WZHaveCodeView()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *textHF;

@end

@implementation WZHaveCodeView

+(instancetype)haveCodeView{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark -初始化控件
-(void)layoutSubviews{
    self.backgroundColor = [UIColor clearColor];
    UIView *textHaveView = [[UIView alloc] init];
    textHaveView.frame = CGRectMake(0,1,SCREEN_WIDTH,44);
    textHaveView.backgroundColor = UIColorRBG(255, 255, 255);
    [self addSubview:textHaveView];
    //创建文本框
     self.textHF = [[UITextField alloc] init];
     self.textHF.placeholder = @"经纪人门店编码";
     self.textHF.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
     self.textHF.textColor = UIColorRBG(68, 68, 68);
    self.textHF.delegate = self;
    //键盘设置
     self.textHF.keyboardType = UIKeyboardTypeNumberPad;
    [textHaveView addSubview: self.textHF];
    [self.textHF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textHaveView).with.offset(15);
        make.right.equalTo(textHaveView).with.offset(-15);
        make.top.equalTo(textHaveView.mas_top);
        make.height.mas_offset(44);
    }];
    //创建lable一
    UILabel *texthavelabel = [[UILabel alloc] init];
    texthavelabel.text = @"1.门店编码是经服合作门店的唯一标识，你可咨询你的店长或者同事";
    texthavelabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    texthavelabel.textColor = UIColorRBG(153, 153, 153);
    texthavelabel.numberOfLines = 0;
    [self addSubview:texthavelabel];
    [texthavelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.top.equalTo(textHaveView.mas_bottom).with.offset(10);
        make.right.equalTo(self).with.offset(-15);
        
    }];
     //创建lable二
    UILabel *texthavelabelTwo = [[UILabel alloc] init];
    texthavelabelTwo.text = @"2.加入门店后报备客户，成交后可赚取佣金；经服APP内做任务赚取现金奖励";
    texthavelabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    texthavelabelTwo.textColor = UIColorRBG(153, 153, 153);
    texthavelabelTwo.numberOfLines = 0;
    [self addSubview:texthavelabelTwo];
    [texthavelabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.top.equalTo(texthavelabel.mas_bottom).with.offset(5);
        
    }];
    //按钮一
    UIButton *textHaveButton = [[UIButton alloc] init];
    [textHaveButton setTitle:@"加入门店" forState: UIControlStateNormal];
    [textHaveButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [textHaveButton setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    textHaveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    textHaveButton.layer.cornerRadius = 4.0;
    textHaveButton.layer.masksToBounds = YES;
    textHaveButton.backgroundColor = UIColorRBG(3, 133, 219);
    [textHaveButton addTarget:self action:@selector(subitemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:textHaveButton];
    [textHaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.mas_offset(44);
    }];
   
}

#pragma mark -有编码提交审核
-(void)subitemAction:(UIButton *)button{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    [self performSelector:@selector(loadData) withObject:self afterDelay:1];
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length>15) {
        return NO;
    }
    return YES;
}
-(void)loadData{
    UITextField *textName = (UITextField *) [self.superview.superview viewWithTag:199];
    [textName resignFirstResponder];
    //判断经纪人姓名
    if ([_JName isEqual:@""]||!_JName) {
        [SVProgressHUD showInfoWithStatus:@"经纪人姓名不能为空"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        return;
    }
    //判断门店编码
    NSString *codeMa = _textHF.text;
    if ([codeMa isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"门店编码不能为空"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        return;
    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"realname"] = _JName;
    paraments[@"storeCode"] = codeMa;
    paraments[@"type"] = _type;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/companyAuthentication",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSString *state  = [responseObject valueForKey:@"data"];
            if (_stateBlock) {
                _stateBlock(state);
            }
            [GKCover hide];
            [SVProgressHUD dismiss];
            if ([_types isEqual:@"1"]) {
                //跳转至首页
                WZTabBarController *tar = [[WZTabBarController alloc] init];
                tar.selectedViewController = [tar.viewControllers objectAtIndex:0];
                [[UIViewController viewController:[self superview]].navigationController presentViewController:tar animated:YES completion:nil];
            }else{
                
                [[UIViewController viewController:[self superview]].navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            
            
        }else{
            [GKCover hide];
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
             [GKCover hide];
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
}

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textHF resignFirstResponder];
   
}
@end
