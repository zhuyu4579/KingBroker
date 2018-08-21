//
//  WZJionStoreController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZJionStoreController.h"
#import <Masonry.h>
#import "WZHaveCodeView.h"
#import "WZNoCodeView.h"
#import "UIBarButtonItem+Item.h"
#import "WZMeViewController.h"
#import "UIView+Frame.h"
#import "WZTabBarController.h"
@interface WZJionStoreController ()<UITextFieldDelegate>
@property(nonatomic,strong)  WZHaveCodeView *haveCodeView;
@property(nonatomic,strong)  WZNoCodeView *noCodeView;
@property(nonatomic,strong) UITextField *textF;
@property(nonatomic,strong) UIButton *textButton;
@property(nonatomic,strong) UIButton *textButtonTwo;
@end

@implementation WZJionStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];
    [self markView];
}

#pragma mark -设置导航栏标题
-(void)setNavTitle{
    //导航条标题
    self.navigationItem.title = @"加入门店";
    //设置控制器view背景色
    self.view.backgroundColor = UIColorRBG(245, 245, 245);
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"clear-icon"] highImage:[UIImage imageNamed:@"clear-icon"] target:self action:@selector(closeVc)];
    
}
#pragma mark -分区view初始化控件
-(void)markView{
    UIView *textView = [[UIView alloc] init];
    textView.frame = CGRectMake(0,kApplicationStatusBarHeight+54,SCREEN_WIDTH,45);
    textView.backgroundColor =UIColorRBG(255, 255, 255);
    [self.view addSubview:textView];
    
    UILabel *labelName = [[UILabel alloc] init];
    labelName.text = @"经纪人姓名：";
    labelName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelName.textColor = UIColorRBG(199, 199, 205);
    [textView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView.mas_left).with.offset(15);
        make.top.equalTo(textView.mas_top).offset(15);
        make.height.mas_offset(14);
    }];
    //创建文本框
    self.textF = [[UITextField alloc] init];
    self.textF.placeholder = @"必填";
    self.textF.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    self.textF.textColor = UIColorRBG(68, 68, 68);
    //键盘设置
    self.textF.keyboardType = UIKeyboardTypeDefault;
    self.textF.tag = 199;
    //设置焦点
    [self.textF becomeFirstResponder];
    self.textF.delegate = self;
    [textView addSubview:self.textF];
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_right).with.offset(0);
        make.width.offset(300);
        make.top.equalTo(textView.mas_top);
        make.height.mas_offset(45);
    }];
    
    UIView *textViewTwo = [[UIView alloc] init];
    textViewTwo.frame = CGRectMake(0,textView.fY+textView.fHeight+10,SCREEN_WIDTH,45);
    textViewTwo.backgroundColor =UIColorRBG(255, 255, 255);
    [self.view addSubview:textViewTwo];
    //创建lable
    UILabel *textlabel = [[UILabel alloc] init];
    textlabel.text = @"经纪门店编码";
    textlabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    textlabel.textColor = UIColorRBG(68, 68, 68);
    [textViewTwo addSubview:textlabel];
    [textlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textViewTwo).with.offset(15);
        make.top.equalTo(textViewTwo.mas_top).with.offset(16);
        make.height.mas_offset(14);
    }];
    //按钮一
    self.textButton = [[UIButton alloc] init];
    [self.textButton setTitle:@"无编码" forState: UIControlStateNormal];
    [self.textButton setTitleColor: [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.textButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.textButton.layer.cornerRadius = 5.0;
    self.textButton.layer.masksToBounds = YES;
    self.textButton.backgroundColor = UIColorRBG(246, 246, 246);
    [self.textButton addTarget:self action:@selector(noCode:) forControlEvents:UIControlEventTouchUpInside];
    [textViewTwo addSubview:self.textButton];
    [self.textButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textViewTwo).with.offset(-15);
        make.top.equalTo(textViewTwo.mas_top).with.offset(10);
        make.width.mas_offset(55);
        make.height.mas_offset(25);
    }];
    //按钮二
    self.textButtonTwo = [[UIButton alloc] init];
    [self.textButtonTwo setTitle:@"有编码" forState: UIControlStateNormal];
    [self.textButtonTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    self.textButtonTwo.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.textButtonTwo.layer.cornerRadius = 5.0;
    self.textButtonTwo.layer.masksToBounds = YES;
    self.textButtonTwo.backgroundColor = UIColorRBG(3, 133, 219);
    [self.textButtonTwo addTarget:self action:@selector(haveCode:) forControlEvents:UIControlEventTouchUpInside];
    [textViewTwo addSubview:self.textButtonTwo];
    [self.textButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textButton.mas_left).with.offset(-10);
        make.top.equalTo(textViewTwo.mas_top).with.offset(10);
        make.width.mas_offset(55);
        make.height.mas_offset(25);
    }];
    
    UIView *textViewThree = [[UIView alloc] init];
    textViewThree.frame = CGRectMake(0,textViewTwo.fY+textViewTwo.fHeight+1,SCREEN_WIDTH,469);
    textViewThree.backgroundColor =[UIColor clearColor];
    [self.view addSubview:textViewThree];
    _haveCodeView = [WZHaveCodeView haveCodeView];
    _haveCodeView.frame = textViewThree.bounds;
    _haveCodeView.type = _type;
    _haveCodeView.types = _types;
    if (_registarBlock) {
        __weak typeof (self) weakSelf = self;
        _haveCodeView.stateBlock = ^(NSString *state) {
            weakSelf.registarBlock(state);
        };
    }
    _noCodeView = [WZNoCodeView noCodeView];
    _noCodeView.frame = textViewThree.bounds;
    _noCodeView.type = _type;
    _noCodeView.types = _types;
    [_noCodeView setHidden:YES];
    [textViewThree addSubview:_haveCodeView];
    [textViewThree addSubview:_noCodeView];
    
}
//经纪人真实姓名
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _haveCodeView.JName = _textF.text;
    _noCodeView.JName = _textF.text;
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length>15) {
        return NO;
    }
    return YES;
}

#pragma mark -切换按钮背景色
-(void)setButtonBG:(UIButton *)bt HideBt:(UIButton *)Hbt{
    [bt setTitleColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    bt.backgroundColor = UIColorRBG(246, 246, 246);
    
    [Hbt setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    Hbt.backgroundColor = UIColorRBG(3, 133, 219);
}
#pragma mark -无编码点击事件
-(void)noCode:(UIButton *)button{
    [self setButtonBG:_textButtonTwo HideBt:_textButton];
    [_noCodeView setHidden:NO];
    [_haveCodeView setHidden:YES];
    
}
#pragma mark -有编码点击事件
-(void)haveCode:(UIButton *)button{
    [self setButtonBG:_textButton HideBt:_textButtonTwo];
    [_noCodeView setHidden:YES];
    [_haveCodeView setHidden:NO];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
//关闭加入门店-将注册信息传入我的页面
-(void)closeVc{
    [self.textF resignFirstResponder];
    if ([_types isEqual:@"1"]) {
        
        if ([_type isEqual:@"2"]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            //跳转至我的页面
            WZTabBarController *tar = [[WZTabBarController alloc] init];
            tar.selectedViewController = [tar.viewControllers objectAtIndex:0];
            [self.navigationController presentViewController:tar animated:YES completion:nil];
        }
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
