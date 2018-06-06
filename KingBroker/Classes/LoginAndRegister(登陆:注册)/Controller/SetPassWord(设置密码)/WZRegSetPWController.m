//
//  WZRegSetPWController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZRegSetPWController.h"
#import "WZSetPassWordView.h"
@interface WZRegSetPWController ()

@end

@implementation WZRegSetPWController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBcakSetPw];
}
#pragma mark -设置界面导航条设置
-(void)setBcakSetPw{
    
    //导航条标题
    self.navigationItem.title = @"设置密码";
     WZSetPassWordView  *regV = [WZSetPassWordView SetPWView];
     regV.registDictionary = _registar;
     [self.SetPassWord addSubview:regV];
    if(_regBlock){
        regV.setPWBlock = ^(NSMutableDictionary *regs) {
            _regBlock(regs);
        };
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
