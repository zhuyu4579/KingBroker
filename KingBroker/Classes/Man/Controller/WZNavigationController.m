//
//  WZNavigationController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZNavigationController.h"
#import "UIBarButtonItem+Item.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WZNavigationController
#pragma mark -设置导航条文字的格式
+(void)load{
    UINavigationBar *narBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    [narBar setTitleTextAttributes:attrs];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //管理手势滑动返回
    //self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
    //禁止系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
}
#pragma mark -UIGestureRecognizerDelegate决定是否触发手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.childViewControllers.count>1;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //返回按钮
    if (self.childViewControllers.count>0) {
         viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] target:self action:@selector(back)];
        
    }
    [super pushViewController:viewController animated:animated];
}
#pragma mark -返回上一级
-(void)back{
    [self  popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
