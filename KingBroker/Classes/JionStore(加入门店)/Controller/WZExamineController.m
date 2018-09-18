//
//  WZExamineController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZExamineController.h"
#import "WZTabBarController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "WZMeViewController.h"
#import "WZNavigationController.h"
@interface WZExamineController ()

@end

@implementation WZExamineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle];
    [self foundControl];
}
#pragma mark -设置导航栏标题
-(void)setNavTitle{
    //导航条标题
    self.navigationItem.title = @"审核资料";
    //设置控制器view背景色
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.hidesBackButton = YES;
}
#pragma mark -创建控件
-(void)foundControl{
    
    //创建一个图片
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV setImage:[UIImage imageNamed:@"pic"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+44);
        make.width.offset(self.view.fWidth);
        make.height.offset(260);
    }];
    UIImageView *images = [[UIImageView alloc] init];
    [images setImage:[UIImage imageNamed:@"plaint"]];
    [self.view addSubview:images];
    [images mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+107);
        make.width.offset(112);
        make.height.offset(112);
    }];
    //创建一个lable
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.frame = CGRectMake(159,204,59,16);
    labelOne.text = @"审核中...";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    labelOne.textColor = [UIColor whiteColor];
    [self.view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(images.mas_bottom).offset(-28);
        make.height.offset(13);
    }];
    //创建第二个Lable
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"资料上传成功，请耐心等待审核…";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    labelTwo.textColor = UIColorRBG(102, 102, 102);
    [self.view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageV.mas_bottom).offset(65);
        make.height.offset(15);
    }];
    //创建第一个button
    UIButton *buttonOne = [[UIButton alloc] init];
    [buttonOne setTitle:@"去首页" forState: UIControlStateNormal];
    [buttonOne setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [buttonOne setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    buttonOne.layer.borderWidth = 1.0;
    buttonOne.layer.borderColor = UIColorRBG(242, 242, 242).CGColor;
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonOne addTarget:self action:@selector(jumpHomePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];
    [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(54);
        make.width.offset(SCREEN_WIDTH/2.0);
    }];
    //创建第二个button
    UIButton *buttonTwo = [[UIButton alloc] init];
    [buttonTwo setTitle:@"我的页面" forState: UIControlStateNormal];
    [buttonTwo setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [buttonTwo setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    buttonTwo.layer.borderWidth = 1.0;
    buttonTwo.layer.borderColor = UIColorRBG(242, 242, 242).CGColor;
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonTwo addTarget:self action:@selector(EditPersonalInformation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTwo];
    [buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(54);
        make.width.offset(SCREEN_WIDTH/2.0);
    }];
}
#pragma mark -跳转去首页
-(void)jumpHomePage:(UIButton *)button{
    WZTabBarController *tar = [[WZTabBarController alloc] init];
    [self.navigationController presentViewController:tar animated:YES completion:nil];
}
#pragma mark -跳转我的页面
-(void)EditPersonalInformation:(UIButton *)button{
    WZTabBarController *tar = [[WZTabBarController alloc] init];
    tar.selectedViewController = [tar.viewControllers objectAtIndex:2];
    [self.navigationController presentViewController:tar animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
