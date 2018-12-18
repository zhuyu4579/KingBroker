//
//  WZEditHouseController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIView+Center.h"
#import "NSString+LCExtension.h"
#import "WZEditHouseController.h"
#import "WZEditHouseViewController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZEditHouseViewTwoController.h"
#import "WZEditHouseViewThreeController.h"
@interface WZEditHouseController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIView *titlesView;

@property(nonatomic,strong)UIButton *previousClickButton;

@property(nonatomic,strong)UIView *titleUnderLine;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) WZEditHouseViewController *editHouseView;
@property(nonatomic,strong) WZEditHouseViewTwoController *editHouseViewTwo;
@property(nonatomic,strong) WZEditHouseViewThreeController *editHouseViewThree;

@end

@implementation WZEditHouseController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavItem];
    //初始化子控制器
    [self setupAllChilds];
    //创建一个UIScrollView
    [self setUIScrollView];
    //创建标题栏
    [self setTitlesView];
}


#pragma mark -初始化子控制器
-(void)setupAllChilds{
    
    WZEditHouseViewController *editHouseView  = [[WZEditHouseViewController alloc] init];
    _editHouseView = editHouseView;
    editHouseView.data = _data;
    [self addChildViewController:editHouseView];
    WZEditHouseViewTwoController *editHouseViewTwo = [[WZEditHouseViewTwoController alloc] init];
    _editHouseViewTwo = editHouseViewTwo;
    editHouseViewTwo.data = _data;
    [self addChildViewController:editHouseViewTwo];
    WZEditHouseViewThreeController *editHouseViewThree = [[WZEditHouseViewThreeController alloc] init];
    _editHouseViewThree = editHouseViewThree;
    editHouseViewThree.data = _data;
    [self addChildViewController:editHouseViewThree];
}
#pragma mark -创建UIScrollView
-(void)setUIScrollView{
    self.automaticallyAdjustsScrollViewInsets =NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(self.view.fX, self.view.fY+1, self.view.fWidth, self.view.fHeight);
    scrollView.backgroundColor = UIColorRBG(247, 247, 247);
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate =self;
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.contentSize =CGSizeMake(scrollView.fWidth*3,0);
    
}

#pragma mark -创建标题栏
-(void)setTitlesView{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, 41)];
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
    NSArray *titles =@[@"必填信息",@"补充信息",@"图片信息"];
    
    CGFloat titleButtonW = self.titlesView.fWidth/3;
    CGFloat titleButtonH =self.titlesView.fHeight;
    
    for (NSInteger i = 0; i<3; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [self.titlesView addSubview:titleButton];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i*titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitleColor:UIColorRBG(102, 96, 91) forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateSelected];
        titleButton.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
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
        
    }];
}
#pragma mark -设置下划线
-(void)setupTitlesUnderline{
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.fHeight = 2;
    titleUnderLine.fWidth = 50;
    titleUnderLine.fY = self.titlesView.fHeight - titleUnderLine.fHeight;
    titleUnderLine.cX = self.titlesView.fWidth/6;
    titleUnderLine.backgroundColor = UIColorRBG(255, 216, 0);
    [self.titlesView addSubview:titleUnderLine];
    self.titleUnderLine = titleUnderLine;
}
#pragma mark -设置导航栏
-(void)setNavItem{
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.title = @"编辑";
    
}
#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -滑动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //算出按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.fWidth;
    UIButton *titleButton = self.titlesView.subviews[index];
    [self titleButtonClick:titleButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

@end
