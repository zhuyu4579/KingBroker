//
//  WZBoaringController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "WZBoaringController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import "UIView+Center.h"
#import "WZLossTableController.h"
#import "WZBoardingTableController.h"
#import "WZCompleteTableController.h"
#import "WZDealTableController.h"
#import "WZNewReportController.h"
#import "UIButton+WZEnlargeTouchAre.h"

@interface WZBoaringController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIView *titlesView;

@property(nonatomic,strong)UIButton *previousClickButton;

@property(nonatomic,strong)UIView *titleUnderLine;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) WZBoardingTableController *boading;
@property(nonatomic,strong) WZDealTableController *deal;
@property(nonatomic,strong) WZCompleteTableController *complete;
@property(nonatomic,strong) WZLossTableController *loss;
@end

@implementation WZBoaringController

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
   WZBoardingTableController *boaring  = [[WZBoardingTableController alloc] init];
    _boading = boaring;
    [self addChildViewController:boaring];
    WZDealTableController *deal = [[WZDealTableController alloc] init];
    _deal = deal;
    [self addChildViewController:deal];
    WZCompleteTableController *complele = [[WZCompleteTableController alloc] init];
    _complete = complele;
    [self addChildViewController:complele];
    WZLossTableController *loss = [[WZLossTableController alloc] init];
    _loss = loss;
    [self addChildViewController:loss];
   
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
    scrollView.contentSize =CGSizeMake(scrollView.fWidth*4,0);
    
//    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, kApplicationStatusBarHeight+44)];
//    buttonView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:buttonView];
    
//    //创建返回按钮
//    UIButton *backButton = [[UIButton alloc] init];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"wd_wmBack"] forState:UIControlStateNormal];
//    [backButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:15];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView addSubview:backButton];
//    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(buttonView.mas_left).offset(15);
//        make.top.equalTo(buttonView.mas_top).offset(kApplicationStatusBarHeight+13);
//        make.width.offset(11);
//        make.height.offset(20);
//    }];
//    UILabel *title = [[UILabel alloc] init];
//    title.text = @"我的订单";
//    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
//    title.textColor = [UIColor whiteColor];
//    [buttonView addSubview:title];
//    [title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(buttonView.mas_centerX);
//        make.top.equalTo(buttonView.mas_top).offset(kApplicationStatusBarHeight+13);
//        make.height.offset(18);
//    }];
//    //创建报备按钮
//    UIButton *selectButton = [[UIButton alloc] init];
//    [selectButton setBackgroundImage:[UIImage imageNamed:@"wd_joinus"] forState:UIControlStateNormal];
//    [selectButton setEnlargeEdgeWithTop:10 right:15 bottom:10 left:20];
//    [selectButton addTarget:self action:@selector(addModel) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView addSubview:selectButton];
//    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(buttonView.mas_right).offset(-15);
//        make.top.equalTo(buttonView.mas_top).offset(kApplicationStatusBarHeight+15);
//        make.width.offset(18);
//        make.height.offset(18);
//    }];
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
    NSArray *titles =@[@"待上客",@"待成交",@"已完成",@"已失效"];
    
    CGFloat titleButtonW = self.titlesView.fWidth/4;
    CGFloat titleButtonH =self.titlesView.fHeight;
    
    for (NSInteger i = 0; i<4; i++) {
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:nil];
    }];
}
#pragma mark -设置下划线
-(void)setupTitlesUnderline{
    
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.fHeight = 2;
    titleUnderLine.fWidth = 40;
    titleUnderLine.fY = self.titlesView.fHeight - titleUnderLine.fHeight;
    titleUnderLine.cX = self.titlesView.fWidth/8;
    titleUnderLine.backgroundColor = UIColorRBG(255, 216, 0);
    [self.titlesView addSubview:titleUnderLine];
    self.titleUnderLine = titleUnderLine;
}
#pragma mark -设置导航栏
-(void)setNavItem{
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.title = @"我的订单";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"add_3"] highImage:[UIImage imageNamed:@"add_3"] target:self action:@selector(addModel)];
    
}
#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addModel{
    WZNewReportController *report = [[WZNewReportController alloc] init];
    [self.navigationController pushViewController:report animated:YES];
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
