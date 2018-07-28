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
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>
#import "WZNEWHTMLController.h"
#import "WZTaskController.h"
#import "WZNavigationController.h"
#import "WZSystemController.h"
#import "WZBoardingDetailsController.h"
#import "NSString+LCExtension.h"
#import <WXApi.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
@interface AppDelegate()<JPUSHRegisterDelegate,WXApiDelegate>

@property(nonatomic,strong)NSString *registerid;

@end

@implementation AppDelegate

//程序启动时就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"2c971480b42a2584471eaadb"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:advertisingId];
    
   
    //获取自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //注册微信
    [WXApi registerApp:@"wx9a6d0860823a1151"];
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
    [self setloadData];
    return YES;
}

#pragma mark 获取自定义消息内容
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    [self setloadData];
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    
    NSString *param = [extras valueForKey:@"param"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRefresh" object:nil];
    if ([param isEqual:@"100"]) {
        //通知二维码关闭
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BoaringVC" object:nil];
    }else if([param isEqual:@"104"] || [param isEqual:@"105"] || [param isEqual:@"106"]){
       // NSLog(@"%@",userInfo);
        //通知刷新我的页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MeRefresh" object:nil];
    }
   
}
//查询未读消息
-(void)setloadData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/read/notreadCount",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *count = [data valueForKey:@"count"] ;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:count forKey:@"newCount"];
            [defaults synchronize];
            UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
            //获取指定item
            UITabBarItem *item = [[[tabBarVC tabBar] items] objectAtIndex:1];
        
            NSInteger counts = [count integerValue];
            
            if (counts<100&&counts>0) {
                item.badgeValue= [NSString stringWithFormat:@"%ld",(long)counts];
            }else if(counts>=100){
                item.badgeValue= [NSString stringWithFormat:@"99+"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
     [JPUSHService registerDeviceToken:deviceToken];
    //获得注册后的regist_id，此值一般传给后台做推送的标记用,先存储起来
    _registerid = [JPUSHService registrationID];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [self setloadData];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    [self setloadData];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//分享
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *shareSuccessType = [defaults valueForKey:@"shareSuccessType"];
        
        if (resp.errCode == 0) {
            //通知回调
            if ([shareSuccessType isEqual:@"0"]) {
                [SVProgressHUD showInfoWithStatus:@"分享成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"taskShare" object:nil];
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:@"分享取消"];
        }
    }
    
}
//点击推送条幅
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
        
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    //自定义内容
    //NSLog(@"收到的推送消息 userinfo %@",userInfo);
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        // NSLog(@"前台收到消息1");
       [self setControllers:userInfo]; //收到推送消息，需要调整的界面
        
    }
    completionHandler();
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self setloadData];
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

-(void)setControllers:(NSDictionary *)userInfo{
    //自定义的内容
    //参数跳转
    NSString *param = [userInfo valueForKey:@"param"];
    //楼盘ID或订单ID
    NSString *additional = [userInfo valueForKey:@"additional"];
    //展示类型
    NSString *viewType = [userInfo valueForKey:@"viewType"];
    //h5地址
    NSString *url = [userInfo valueForKey:@"url"];
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    if (!uuid) {
        [NSString isCode:self.window.rootViewController.navigationController code:@"401"];
        return;
    }
    //跳转页面
    if([viewType isEqual:@"1"]){
        if([param isEqual:@"111"]){
            //跳转H5
            WZTaskController *task = [[WZTaskController alloc] init];
            task.url = [NSString stringWithFormat:@"%@&uuid=%@",url,uuid];
           WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:task];
           [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
            
        }else{
            //跳转H5
            WZNEWHTMLController *new = [[WZNEWHTMLController alloc] init];
            new.url = url;
            WZTabBarController *tabBarVc =(WZTabBarController *) self.window.rootViewController;
            tabBarVc.selectedViewController = [tabBarVc.viewControllers objectAtIndex:0];
            if ([tabBarVc isKindOfClass:[WZTabBarController class]]) {
                WZNavigationController *nav =(WZNavigationController *) tabBarVc.selectedViewController;
                
                [nav.topViewController.navigationController pushViewController:new animated:YES];
            }
        }
        
    }else if([viewType isEqual:@"2"]){
        //跳转原生
        if ([param isEqual:@"108"]) {
            //系统列表页面
            WZSystemController *system = [[WZSystemController alloc] init];
            WZTabBarController *tabBarVc =(WZTabBarController *) self.window.rootViewController;
            tabBarVc.selectedViewController = [tabBarVc.viewControllers objectAtIndex:1];
            if ([tabBarVc isKindOfClass:[WZTabBarController class]]) {
                WZNavigationController *nav =(WZNavigationController *) tabBarVc.selectedViewController;
                
                [nav.topViewController.navigationController pushViewController:system animated:YES];
            }
            
        }else if([param isEqual:@"102"]){
            WZBoardingDetailsController *boaring = [[WZBoardingDetailsController alloc] init];
            boaring.ID = additional;
            WZTabBarController *tabBarVc =(WZTabBarController *) self.window.rootViewController;
            if ([tabBarVc isKindOfClass:[WZTabBarController class]]) {
                WZNavigationController *nav =(WZNavigationController *) tabBarVc.selectedViewController;
                [nav.topViewController.navigationController pushViewController:boaring animated:YES];
            }
        }
    }
}
@end
