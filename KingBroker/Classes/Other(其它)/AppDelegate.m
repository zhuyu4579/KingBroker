//
//  AppDelegate.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchIntroductionView.h"
#import "WZTabBarController.h"

@implementation AppDelegate

//程序启动时就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口根控制器
    WZTabBarController *tabBarVc = [[WZTabBarController alloc] init];
    self.window.rootViewController = tabBarVc;
    //3.显示窗口
    [self.window makeKeyAndVisible];
   
    [NSThread sleepForTimeInterval:1];
    //创建引导页
    LaunchIntroductionView *launchView =  [LaunchIntroductionView sharedWithImages:@[@"picture",@"picture_2",@"picture_3"]];
    launchView.currentColor = [UIColor blackColor];
    launchView.nomalColor = UIColorRBG(158, 158, 158);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
