//
//  WZLoginController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/16.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  登陆页面

#import "WZLoginController.h"
#import "WZLoginRegistar.h"
#import "UIBarButtonItem+Item.h"
@interface WZLoginController()<UIGestureRecognizerDelegate>


@end

@implementation WZLoginController

#pragma mark -关闭登陆页面
- (IBAction)closeLogin:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil ];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _headHeight.constant = kApplicationStatusBarHeight;
    //创建WZLoginRegistar
    WZLoginRegistar *lrV = [WZLoginRegistar loginRegistar];
    //传输数据
    if(_loginBlock){
        lrV.login = ^(NSDictionary *login) {
            _loginBlock(login);
        };
    }
    
    [self.millerLogin addSubview:lrV];
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
