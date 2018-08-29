//
//  WZfindPassWordController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZfindPassWordController.h"
#import "WZFindPWView.h"
@interface WZfindPassWordController ()

@end

@implementation WZfindPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFindNav];
}
#pragma mark -设置导航条
-(void)setFindNav{
    //加载WZFindPWViw
    WZFindPWView *FPWView = [WZFindPWView findPWView];
    FPWView.modityId = _modityID;
    [self.textFindPassWord addSubview:FPWView];
    _headHeight.constant = kApplicationStatusBarHeight + 94;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)artificialService:(id)sender {
    NSString *phone = @"057188841808";
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
