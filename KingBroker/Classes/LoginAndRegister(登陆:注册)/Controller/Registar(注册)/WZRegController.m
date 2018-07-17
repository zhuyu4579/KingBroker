//
//  WZRegController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZRegController.h"
#import "WZRegistarView.h"
@interface WZRegController ()

@end

@implementation WZRegController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBcakButton];
}
#pragma mark -设置界面导航条设置
-(void)setBcakButton{
    _headHeight.constant = kApplicationStatusBarHeight+94;
    //导航条标题
    self.navigationItem.title = @"注册";
    
    WZRegistarView *regV = [WZRegistarView registarView];
    
    [self.registarOne addSubview:regV];
    if (_registarDataBlock) {
        regV.registarBlock = ^(NSDictionary *registar) {
            _registarDataBlock(registar);
        };
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
