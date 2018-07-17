//
//  WZShareHouseController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIView+Center.h"
#import "WZShareHouseController.h"
#import "WZShareVideoController.h"
#import "WZSharePhoneController.h"
#import "WZShareHouseDatisController.h"
@interface WZShareHouseController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIView *titlesView;

@property(nonatomic,weak)UIButton *previousClickButton;

@property(nonatomic,weak)UIView *titleUnderLine;

@property(nonatomic,weak) UIScrollView *scrollView;

@property(nonatomic,strong) WZShareVideoController *shareVideoVc;
@property(nonatomic,strong) WZSharePhoneController *sharePhoneVc;
@property(nonatomic,strong) WZShareHouseDatisController *shareHouseDatisVc;
@end

@implementation WZShareHouseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"分享";
    //初始化子控制器
    [self setupAllChilds];
    //创建一个UIScrollView
    [self setUIScrollView];
    //创建标题栏
    [self setTitlesView];
}
#pragma mark -初始化子控制器
-(void)setupAllChilds{
    WZShareVideoController *shareVideoVc  = [[WZShareVideoController alloc] init];
    _shareVideoVc = shareVideoVc;
    shareVideoVc.projectId = _ID;
    [self addChildViewController:shareVideoVc];
    WZSharePhoneController *sharePhoneVc = [[WZSharePhoneController alloc] init];
    _sharePhoneVc = sharePhoneVc;
    sharePhoneVc.projectId = _ID;
    [self addChildViewController:sharePhoneVc];
    WZShareHouseDatisController *shareHouseDatisVc = [[WZShareHouseDatisController alloc] init];
    _shareHouseDatisVc = shareHouseDatisVc;
    shareHouseDatisVc.projectId = _ID;
    [self addChildViewController:shareHouseDatisVc];
   
}
#pragma mark -创建UIScrollView
-(void)setUIScrollView{
    self.automaticallyAdjustsScrollViewInsets =NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(self.view.fX, self.view.fY+1, self.view.fWidth, self.view.fHeight);
    scrollView.backgroundColor = UIColorRBG(242, 242, 242);
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate =self;
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.contentSize =CGSizeMake(scrollView.fWidth*4,0);
}
#pragma mark -创建标题栏
-(void)setTitlesView{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, 44)];
    titlesView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    //设置标题栏按钮
    [self setupTitlesButton];
    //设置下划线
    [self setupTitlesUnderline];
}
#pragma mark -设置标题栏按钮
-(void)setupTitlesButton{
    //文字
    NSArray *titles =@[@"视频",@"图片",@"楼盘"];
    
    CGFloat titleButtonW = self.titlesView.fWidth/3;
    CGFloat titleButtonH =self.titlesView.fHeight;
    
    for (NSInteger i = 0; i<3; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [self.titlesView addSubview:titleButton];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i*titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
        titleButton.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        if (i == 0) {
            
            [self titleButtonClick:titleButton];
            
        }
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}
#pragma mark -按钮点击事件
-(void)titleButtonClick:(UIButton *)titleButton{
    self.previousClickButton.selected =NO;
    titleButton.selected = YES;
    self.previousClickButton = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        //处理下划线
        self.titleUnderLine.cX = titleButton.cX;
        //联动
        self.scrollView.contentOffset = CGPointMake(self.scrollView.fWidth * titleButton.tag, self.scrollView.contentOffset.y);
    }completion:^(BOOL finished) {
        UIView *childsView = self.childViewControllers[titleButton.tag].view;
        childsView.frame = CGRectMake(self.scrollView.fWidth*titleButton.tag, _titlesView.fY+_titlesView.fHeight, self.scrollView.fWidth, self.scrollView.fHeight-_titlesView.fY-_titlesView.fHeight);
        [self.scrollView addSubview:childsView];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshShare" object:nil];
    }];
}
#pragma mark -设置下划线
-(void)setupTitlesUnderline{
    UIButton *firstTitleButton = self.titlesView.subviews.firstObject;
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.fHeight = 2;
    titleUnderLine.fWidth = 65;
    titleUnderLine.fY = self.titlesView.fHeight - titleUnderLine.fHeight;
    titleUnderLine.cX = self.titlesView.fWidth/6;
    titleUnderLine.backgroundColor = [firstTitleButton  titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderLine];
    self.titleUnderLine = titleUnderLine;
}
#pragma mark -滑动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //算出按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.fWidth;
    UIButton *titleButton = self.titlesView.subviews[index];
    
    [self titleButtonClick:titleButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
