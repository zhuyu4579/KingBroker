//
//  WZNewReportController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  报备/批量报备2.0
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZCustomerItem.h"
#import "NSString+LCExtension.h"
#import "UIBarButtonItem+Item.h"
#import "WZNewReportController.h"

@interface WZNewReportController ()

@end

@implementation WZNewReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed: @"add"] highImage:[UIImage imageNamed:@"add"] target:self action:@selector(addCustomer)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
