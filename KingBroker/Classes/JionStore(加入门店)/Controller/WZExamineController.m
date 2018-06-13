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
    self.view.backgroundColor = UIColorRBG(245, 245, 245);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.hidesBackButton = YES;
}
#pragma mark -创建控件
-(void)foundControl{
    //创建一个图片
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV setImage:[UIImage imageNamed:@"time"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+95);
        make.width.offset(75);
        make.height.offset(75);
    }];
    //创建一个lable
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.frame = CGRectMake(159,204,59,16);
    labelOne.text = @"审核中...";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [self.view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageV.mas_bottom).offset(20);
        make.height.offset(16);
    }];
    //创建第二个Lable
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"名片上传成功，请耐心等待审核…";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwo.textColor = UIColorRBG(153, 153, 153);
    [self.view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).offset(20);
        make.height.offset(14);
    }];
    //创建第一个button
    UIButton *buttonOne = [[UIButton alloc] init];
    
    [buttonOne setTitle:@"去首页" forState: UIControlStateNormal];
    [buttonOne setTitleColor: [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buttonOne setTitleColor: [UIColor blueColor] forState:UIControlStateHighlighted];
    buttonOne.layer.borderWidth = 1.0;
    buttonOne.layer.borderColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0].CGColor;
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:15];
    buttonOne.layer.cornerRadius = 3.0;
    buttonOne.layer.masksToBounds = YES;
    [buttonOne addTarget:self action:@selector(jumpHomePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOne];
    [buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelTwo.mas_bottom).offset(50);
        make.height.offset(44);
        make.width.offset(140);
    }];
    //创建第二个button
    UIButton *buttonTwo = [[UIButton alloc] init];
    
    [buttonTwo setTitle:@"返回我的页面" forState: UIControlStateNormal];
    [buttonTwo setTitleColor: [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buttonTwo setTitleColor: [UIColor blueColor] forState:UIControlStateHighlighted];
    buttonTwo.layer.borderWidth = 1.0;
    buttonTwo.layer.borderColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0].CGColor;
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:15];
    buttonTwo.layer.cornerRadius = 3.0;
    buttonTwo.layer.masksToBounds = YES;
    [buttonTwo addTarget:self action:@selector(EditPersonalInformation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTwo];
    [buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(buttonOne.mas_bottom).offset(20);
        make.height.offset(44);
        make.width.offset(140);
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
