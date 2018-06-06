//
//  WZTabBarController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTabBarController.h"
#import "WZPagesViewController.h"
#import "WZNewsTableViewController.h"
#import "WZMallViewController.h"
#import "WZMeViewController.h"
#import "UIImage+Tools.h"
#import "WZNavigationController.h"
@interface WZTabBarController ()

@end

@implementation WZTabBarController
//只会调用一次
+(void)load{
    //拿到所有的tabBarItem
    //获取哪个类中的UItabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //设置按钮选择状态下文字的颜色
    //创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = UIColorRBG(3, 133, 219);
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    //设置字体的尺寸：只有在正常状态下才能有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}

#pragma mark -生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //2.1创建子控制器
    [self setupAllChildViewController];
    //2.2设置tabBar按钮内容-->对应的子控制器
    [self setupAllTitleButton];
    //[[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置tabBar不透明
    [UITabBar appearance].translucent = NO;
}


#pragma mark -添加所以子控制器
-(void)setupAllChildViewController{
   
    //首页
    WZPagesViewController *pageVc = [[WZPagesViewController alloc] init];
    
    //创建导航控制器
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:pageVc];
   
    [self addChildViewController:nav];
    //消息
    WZNewsTableViewController *newVc = [[WZNewsTableViewController alloc] init];
    //创建导航控制器
    WZNavigationController *nav1 = [[WZNavigationController alloc] initWithRootViewController:newVc];
   
    [self addChildViewController:nav1];

    //我的
    WZMeViewController *meVc = [[WZMeViewController alloc] init];
    //创建导航控制器
    WZNavigationController *nav3 = [[WZNavigationController alloc] initWithRootViewController:meVc];
    
    [self addChildViewController:nav3];
    
}

#pragma mark -设置按钮的文字和图标
-(void)setupAllTitleButton{
    //0：pageVc首页
    UINavigationController *pageVc = self.childViewControllers[0];
        pageVc.tabBarItem.title = @"首页";
        pageVc.tabBarItem.image = [UIImage imageNamed:@"home"];
        pageVc.tabBarItem.selectedImage = [UIImage imageOfAlwaysOriginalWithImageNamed:@"home_2"];
    
    //1:nav1消息
    UINavigationController *nav1 = self.childViewControllers[1];
        nav1.tabBarItem.title = @"消息";
        nav1.tabBarItem.image = [UIImage imageNamed:@"message"];
        nav1.tabBarItem.selectedImage = [UIImage imageOfAlwaysOriginalWithImageNamed:@"message_2"];

    //3:nav3我的
    UINavigationController *nav3 = self.childViewControllers[2];
        nav3.tabBarItem.title = @"我的";
        nav3.tabBarItem.image = [UIImage imageNamed:@"mine"];
        nav3.tabBarItem.selectedImage = [UIImage imageOfAlwaysOriginalWithImageNamed:@"mine_2"];

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
