//
//  WZHousePageController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/5.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZHousePageController.h"
#import "WZHouseController.h"
#import "WZHouseCollectController.h"
#import "UIView+Frame.h"
@interface WZHousePageController ()
//子控制器
@property(nonatomic,strong)WZHouseController *allHouseVC;
//收藏控制器
@property(nonatomic,strong)WZHouseCollectController *collectHouseVC;
//全部楼盘按钮
@property(nonatomic,strong)UIButton *allButton;
//我的楼盘按钮
@property(nonatomic,strong)UIButton *meButton;
//下划线
@property(nonatomic,strong)UIView *ineOne;
//下划线
@property(nonatomic,strong)UIView *ineTwo;
@end

@implementation WZHousePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题
    [self setNarItem];
    
    if (_status == 0) {
        _allButton.selected = YES;
        _meButton.selected = NO;
        [_ineOne setHidden:NO];
        [_ineTwo setHidden:YES];
        [self.view addSubview:self.allHouseVC.view];
        [_allHouseVC loadRefreshs];
    }else{
        
        _allButton.selected = NO;
        _meButton.selected = YES;
        [_ineOne setHidden:YES];
        [_ineTwo setHidden:NO];
        [self.view addSubview:self.collectHouseVC.view];
        [_collectHouseVC loadRefreshs];
    }
}
-(WZHouseController *)allHouseVC{
    if (_allHouseVC == nil) {
        _allHouseVC = [[WZHouseController alloc] init];
        _allHouseVC.view.frame = CGRectMake(0,kApplicationStatusBarHeight+44, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-44);
    }
    return _allHouseVC;
}
-(WZHouseCollectController *)collectHouseVC{
    if (_collectHouseVC == nil) {
        _collectHouseVC = [[WZHouseCollectController alloc] init];
        _collectHouseVC.view.frame = CGRectMake(0, kApplicationStatusBarHeight+44, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-44);
    }
    return _collectHouseVC;
}
#pragma mark -设置导航栏
-(void)setNarItem{
    
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, kApplicationStatusBarHeight+44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setBackgroundImage:[UIImage imageNamed:@"dh_more_unfold"] forState:UIControlStateNormal];
    [backButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:15];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(navView.mas_left).offset(15);
        make.top.equalTo(navView.mas_top).offset(kApplicationStatusBarHeight+13);
        make.width.offset(11);
        make.height.offset(20);
    }];
    //导航栏按钮view
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [navView addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navView.mas_centerX);
        make.top.equalTo(navView.mas_top).offset(kApplicationStatusBarHeight+5);
        make.width.offset(218);
        make.height.offset(33);
    }];
    //按钮
    UIButton *allButton = [[UIButton alloc] init];
    [allButton setTitle:@"全部楼盘" forState:UIControlStateNormal];
    allButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    [allButton setTitleColor:UIColorRBG(85, 85, 85) forState:UIControlStateNormal];
    [allButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateSelected];
    [allButton addTarget:self action:@selector(allHouse) forControlEvents:UIControlEventTouchUpInside];
    _allButton = allButton;
    [buttonView addSubview:allButton];
    [allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonView.mas_left);
        make.top.equalTo(buttonView.mas_top).offset(3);
        make.width.offset(109);
        make.height.offset(27);
    }];
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(255, 216, 0);
    _ineOne = ineOne;
    [buttonView addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(allButton.mas_centerX);
        make.top.equalTo(allButton.mas_bottom);
        make.width.offset(30);
        make.height.offset(3);
    }];
    
    UIButton *meButton = [[UIButton alloc] init];
    [meButton setTitle:@"我的楼盘" forState:UIControlStateNormal];
    meButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    [meButton setTitleColor:UIColorRBG(85, 85, 85) forState:UIControlStateNormal];
    [meButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateSelected];
    [meButton addTarget:self action:@selector(meHouse) forControlEvents:UIControlEventTouchUpInside];
    _meButton = meButton;
    [buttonView addSubview:meButton];
    [meButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buttonView.mas_right);
        make.top.equalTo(buttonView.mas_top).offset(3);
        make.width.offset(109);
        make.height.offset(27);
    }];
    
    UIView *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(255, 216, 0);
    _ineTwo = ineTwo;
    [buttonView addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(meButton.mas_centerX);
        make.top.equalTo(meButton.mas_bottom);
        make.width.offset(30);
        make.height.offset(3);
    }];

}
#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -全部楼盘
-(void)allHouse{
    _status = 0;
    _allButton.selected = YES;
    _meButton.selected = NO;
    [_ineOne setHidden:NO];
    [_ineTwo setHidden:YES];
    [self.collectHouseVC.view removeFromSuperview];
    [self.view addSubview:self.allHouseVC.view];
    [_allHouseVC loadRefreshs];
}
#pragma mark -我的楼盘
-(void)meHouse{
    _status = 1;
    _allButton.selected = NO;
    _meButton.selected = YES;
    [_ineOne setHidden:YES];
    [_ineTwo setHidden:NO];
    [self.allHouseVC.view removeFromSuperview];
    [self.view addSubview:self.collectHouseVC.view];
    [_collectHouseVC loadRefreshs];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
@end
