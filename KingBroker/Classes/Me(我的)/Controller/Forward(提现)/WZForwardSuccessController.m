//
//  WZForwardSuccessController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZForwardSuccessController.h"

@interface WZForwardSuccessController ()

@end

@implementation WZForwardSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    UILabel *label = [[UILabel alloc] init];
    label.text = @"发起提现申请成功，等待平台处理，预计\n3~5个工作日到账";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    label.textColor = UIColorRBG(135, 133, 139);
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+168);
    }];
    //确定按钮
    UIButton *confirm = [[UIButton alloc] init];
    [confirm setTitle:@"完成" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirm.backgroundColor = UIColorRBG(255, 216, 0);
    confirm.layer.cornerRadius = 22.0;
    confirm.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [confirm addTarget:self action:@selector(confirmZFB:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(label.mas_bottom).offset(127);
        make.height.offset(44);
        make.width.offset(self.view.fWidth-30);
    }];
}
//
-(void)confirmZFB:(UIButton *)button{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popToB" object:nil];
    
    //dismiss当前模态控制器(不加动画)
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
@end
