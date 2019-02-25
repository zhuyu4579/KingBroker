//
//  WZInvitationCodesController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2019/2/20.
//  Copyright © 2019 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "UIView+Frame.h"
#import "UIColor+Tools.h"
#import "WZLoadDateSeviceOne.h"
#import "WZInvitationCodesController.h"

@interface WZInvitationCodesController ()<UITextFieldDelegate>
//邀请码
@property(nonatomic,strong)UITextField *invitationCode;
//提交按钮
@property(nonatomic,strong)UIButton *submissionButton;

@end

@implementation WZInvitationCodesController
#pragma mark -lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    
    if (toBeString.length>20) {
        return NO;
    }
    return YES;
}
#pragma mark -touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_invitationCode resignFirstResponder];
  
}
#pragma mark -点击提交
-(void)submission{
    NSString *code = _invitationCode.text;
    if ([code isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"邀请码为空"];
        return;
    }
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"parentPhone"] = code;
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功\n1元红包已到账"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/sysUser/newcomerAddCode"];
}
- (void)playPhone{
    NSString *phone = @"057188841808";
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
#pragma mark -创建控件
-(void)createView{
    _invitationCode = [[UITextField alloc] init];
    _invitationCode.placeholder = @"输入好友的邀请码，得1元现金红包";
    _invitationCode.textColor = UIColorRBG(68, 68, 68);
    _invitationCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _invitationCode.delegate = self;
    _invitationCode.keyboardType = UIKeyboardTypeDefault;
    _invitationCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_invitationCode];
    [_invitationCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+100);
        make.width.offset(self.view.fWidth-40);
        make.height.offset(45);
    }];
    UIView *codeIne = [[UIView alloc] init];
    codeIne.backgroundColor = UIColorRBG(204, 204, 204);
    [self.view addSubview:codeIne];
    [codeIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.invitationCode.mas_bottom);
        make.width.offset(self.view.fWidth-40);
        make.height.offset(1);
    }];
    _submissionButton = [[UIButton alloc] init];
    _submissionButton.backgroundColor = UIColorRBG(255, 224, 0);
    _submissionButton.layer.cornerRadius = 25.0;
    _submissionButton.layer.masksToBounds = YES;
    [_submissionButton setTitle:@"提交" forState:UIControlStateNormal];
    _submissionButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    [_submissionButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    [_submissionButton addTarget:self action:@selector(submission) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submissionButton];
    [_submissionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(codeIne.mas_bottom).offset(54);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(49);
    }];
    UILabel *titleOne = [[UILabel alloc] init];
    titleOne.text = @"温馨提示";
    titleOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    titleOne.textColor = UIColorRBG(51, 51, 51);
    [self.view addSubview:titleOne];
    [titleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(22);
        make.top.equalTo(_submissionButton.mas_bottom).offset(45);
        make.width.offset(self.view.fWidth-44);
        make.height.offset(14);
    }];
    UILabel *titleLabelThree = [[UILabel alloc] init];
    titleLabelThree.text = @"";
    titleLabelThree.textColor = UIColorRBG(153, 153, 153);
    titleLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    NSString *strs = @"1.下载经喜APP后的3天内可以输入邀请码，超过时间不能输入。\n\n2.一个手机只能输入一次邀请码。已经输入过邀请码的手机，切换账号也无法输入其他邀请码\n\n3.使用APP分身软件、高危手机号等非正常用户，将不能输入邀请码，且会被系统记录。\n\n4.如有疑问，请联系人工客服。";
    NSMutableAttributedString *attributedString =  [UIColor changeSomeText:@"人工客服" inText:strs withColor:UIColorRBG(242, 179, 9)];
    titleLabelThree.attributedText = attributedString;
    titleLabelThree.numberOfLines = 0;
    [self.view addSubview:titleLabelThree];
    [titleLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(22);
        make.top.equalTo(titleOne.mas_bottom).offset(21);
        make.width.offset(self.view.fWidth-40);
    }];
    UIButton *palyTelphone = [[UIButton alloc] init];
    [palyTelphone addTarget:self action:@selector(playPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:palyTelphone];
    [palyTelphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(22);
        make.top.equalTo(titleLabelThree.mas_bottom).offset(-15);
        make.width.offset(self.view.fWidth-200);
        make.height.offset(18);
    }];
}

@end
