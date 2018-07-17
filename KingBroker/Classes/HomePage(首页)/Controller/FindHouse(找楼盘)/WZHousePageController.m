//
//  WZHousePageController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/5.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHousePageController.h"
#import "WZHouseController.h"
#import "WZHouseCollectController.h"
#import "UIView+Frame.h"
@interface WZHousePageController ()
//子控制器
@property(nonatomic,strong)WZHouseController *allHouseVC;
//收藏控制器
@property(nonatomic,strong)WZHouseCollectController *collectHouseVC;
//导航栏
@property (nonatomic, strong)UISegmentedControl *segmented;

@end

@implementation WZHousePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题
    [self setNarItem];
}
-(WZHouseController *)allHouseVC{
    if (_allHouseVC == nil) {
        _allHouseVC = [[WZHouseController alloc] init];
        _allHouseVC.view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight);
    }
    return _allHouseVC;
}
-(WZHouseCollectController *)collectHouseVC{
    if (_collectHouseVC == nil) {
        _collectHouseVC = [[WZHouseCollectController alloc] init];
        _collectHouseVC.view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight);
    }
    return _collectHouseVC;
}
#pragma mark -设置导航栏
-(void)setNarItem{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"全部楼盘", @"我的楼盘"]];
    _segmented  = segmented;
    
    segmented.frame = CGRectMake(0, 0, 139, 30);
    
    // 设置整体的色调
    segmented.tintColor = UIColorRBG(3, 133, 219);
    
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:UIColorRBG(3, 133, 219),NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    // 设置初始选中项
    segmented.selectedSegmentIndex = _status;
    
    [segmented addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    // 设置点击后恢复原样，默认为NO，点击后一直保持选中状态
    [segmented setMomentary:NO];
    self.navigationItem.titleView = segmented;
    if (_status == 0) {
        [self.view addSubview:self.allHouseVC.view];
        [_allHouseVC loadRefreshs];
    }else{
        [self.view addSubview:self.collectHouseVC.view];
        [_collectHouseVC loadRefreshs];
    }
}
//点击切换子控制器
-(void)selectItem:(UISegmentedControl *)segmend{
    if(segmend.selectedSegmentIndex == 0){
        [self.collectHouseVC.view removeFromSuperview];
        [self.view addSubview:self.allHouseVC.view];
        [_allHouseVC loadRefreshs];
    }else{
        [self.allHouseVC.view removeFromSuperview];
        [self.view addSubview:self.collectHouseVC.view];
        [_collectHouseVC loadRefreshs];
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
