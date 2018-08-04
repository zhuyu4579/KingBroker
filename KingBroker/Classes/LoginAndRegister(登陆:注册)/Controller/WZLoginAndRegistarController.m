//
//  WZLoginAndRegistarController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  登录/注册
#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZLoginAndRegistarController.h"

@interface WZLoginAndRegistarController ()

@end

@implementation WZLoginAndRegistarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建控件
    [self createControl];
}
#pragma mark - 创建控件
-(void)createControl{
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    //图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).mas_offset(kApplicationStatusBarHeight+50);
        make.height.offset(109);
        make.width.offset(109);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

@end
