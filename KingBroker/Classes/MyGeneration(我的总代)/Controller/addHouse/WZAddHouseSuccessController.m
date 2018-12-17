//
//  WZAddHouseSuccessController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIBarButtonItem+Item.h"
#import "WZAddHouseSuccessController.h"

@interface WZAddHouseSuccessController ()

@end

@implementation WZAddHouseSuccessController

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
    title.text = @"添加楼盘成功";
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageViewOne.mas_bottom).offset(18);
        make.height.offset(17);
    }];
    
    
    UIImageView *imageViewTwo = [[UIImageView alloc] init];
    imageViewTwo.image = [UIImage imageNamed:@"zd_lc"];
    [self.view addSubview:imageViewTwo];
    [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(title.mas_bottom).offset(70);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(67*n);
    }];
}
#pragma mark -完成
-(void)success{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushD" object:self];
    UIViewController *vc = self.presentingViewController;
    
    if (!vc.presentingViewController)   return;
    
    while (vc.presentingViewController)  {
        vc = vc.presentingViewController;
    }
    
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}
@end
