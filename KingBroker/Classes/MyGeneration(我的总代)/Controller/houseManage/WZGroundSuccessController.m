//
//  WZGroundSuccessController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIBarButtonItem+Item.h"
#import "WZGroundSuccessController.h"

@interface WZGroundSuccessController ()

@end

@implementation WZGroundSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger n = SCREEN_WIDTH/375.0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(success) title:@"完成"];
    UIImageView *imageViewOne = [[UIImageView alloc] init];
    imageViewOne.image = [UIImage imageNamed:@"bb_succeed"];
    [self.view addSubview:imageViewOne];
    [imageViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight +79);
        make.width.offset(74);
        make.height.offset(74);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.textColor = UIColorRBG(85, 85, 85);
    title.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
    title.text = @"提交成功";
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageViewOne.mas_bottom).offset(18);
        make.height.offset(17);
    }];
    UILabel *title2 = [[UILabel alloc] init];
    title2.textColor = UIColorRBG(100, 100, 100);
    title2.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size: 14];
    title2.text = @"提交成功";
    [self.view addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(title.mas_bottom).offset(11);
        make.height.offset(14);
    }];
    
    UIImageView *imageViewTwo = [[UIImageView alloc] init];
    imageViewTwo.image = [UIImage imageNamed:@"zd_lc"];
    [self.view addSubview:imageViewTwo];
    [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(title2.mas_bottom).offset(45);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(67*n);
    }];
    UIButton *vipButton = [[UIButton alloc] init];
    [vipButton setBackgroundImage:[UIImage imageNamed:@"zd_tg"] forState:UIControlStateNormal];
    [vipButton addTarget:self action:@selector(buyVip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vipButton];
    [vipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(imageViewTwo.mas_bottom).offset(77);
        make.width.offset(self.view.fWidth);
        make.height.offset(138*n);
    }];
}
#pragma mark -完成
-(void)success{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -跳转会员
-(void)buyVip{
    
   
}
@end
