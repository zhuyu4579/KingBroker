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
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import "WZNEWHTMLController.h"
#import "WZTaskController.h"
#import "WZNavigationController.h"
#import "WZSystemController.h"
#import "WZBoardingDetailsController.h"
#import "NSString+LCExtension.h"
#import <WXApi.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UMCommon/UMCommon.h>

API_AVAILABLE(ios(10.0))
@interface AppDelegate()<WXApiDelegate,UNUserNotificationCenterDelegate>{
    UNUserNotificationCenter * _notificationCenter;
}

@property(nonatomic,strong)NSString *registerid;

@end
//正式 appkey & AppSecret
static NSString *const appKey = @"25264385";
static NSString *const appSecret = @"b5a606ec885dd1ed01abdece86a9322b";
@implementation AppDelegate

//程序启动时就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    //友盟统计
    //测试：5b766107a40fa379e70000bd
    //正式：5b7bcec0f29d986f34000286
    [UMConfigure initWithAppkey:@"5b7bcec0f29d986f34000286" channel:@"App Store"];

    //注册微信
    [WXApi registerApp:@"wx03f7c2825a2266a4"];
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口根控制器
    WZTabBarController *tabBarVc = [[WZTabBarController alloc] init];
    self.window.rootViewController = tabBarVc;
    //3.显示窗口
    [self.window makeKeyAndVisible];
   
    [NSThread sleepForTimeInterval:1];
    //创建引导页
    LaunchIntroductionView *launchView =  [LaunchIntroductionView sharedWithImages:@[@"picture",@"picture_2",@"picture_3",@"picture_4"]];
    launchView.currentColor = [UIColor blackColor];
    launchView.nomalColor = UIColorRBG(158, 158, 158);
    [self setloadData];
    
    //阿里推送
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    
    // 监听推送消息到达
    [self registerMessageReceive];
    
    // 点击通知将 App 从关闭状态启动时，将通知打开回执上报 // 计算点击 OpenCount
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    // 主动获取设备通知是否授权 (iOS 10+)
    [self getNotificationSettingStatus];
    
    return YES;
}
//初始化推送
- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:appKey appSecret:appSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[CloudPushSDK getDeviceId] forKey:@"deviceId"];
            [defaults synchronize];
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}
//注册苹果推送，获取deviceToken用于推送
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        
        // iOS 10 notifications
        if (@available(iOS 10.0, *)) {
            _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        }
        // 创建 category，并注册到通知中心
        [self createCustomNotificationCategory];
        
        // 遵循协议
        _notificationCenter.delegate = self;
        
        // 请求客户推送通知权限，以及推送的类型
        if (@available(iOS 10.0, *)) {
            [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (granted) {
                    // granted
                    NSLog(@"\n ====== User authored notification.");
                    
                    // 向APNs注册，获取deviceToken  // 要求在主线程中
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [application registerForRemoteNotifications];
                    });
                    
                } else {
                    // not granted
                    NSLog(@"\n ====== User denied notification.");
                    
                    // 即使客户不允许通知也想让它通知 // 待测试
                    // 向APNs注册，获取deviceToken  // 要求在主线程中
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [application registerForRemoteNotifications];
                    });
                    
                }}];
            /**
             *  主动获取设备通知是否授权 (iOS 10+)
             */
            [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                // 进行判断做出相应的处理
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                    NSLog(@"\n ====== 未选择是否允许通知");
                } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                    NSLog(@"\n ====== 未授权允许通知");
                } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                    NSLog(@"\n ====== 已授权允许通知");
                }
            }];
        }
        
    } else if (systemVersionNum >= 8.0) { // 适配 iOS_8, iOS_10.0
        
        // iOS 8 Notifications
        // 不会有黄色叹号
        
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
}
// 主动获取设备通知是否授权(iOS 10+)
- (void)getNotificationSettingStatus {
    if (@available(iOS 10.0, *)) {
        [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"User authed.");
            } else {
                NSLog(@"User denied.");
            }
        }];
    }
}
// 创建并注册通知category(iOS 10+)
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    if (@available(iOS 10.0, *)) {
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
        // 创建id为`test_category`的category，并注册两个action到category
        // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        // 注册category到通知中心
        [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
    }
    
}

//苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
//苹果推送注册失败回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}
//注册推送通道 打开 监听
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChannelOpened:) name:@"CCPDidChannelConnectedSuccess" object:nil];
    
}
/**
 *   推送通道打开回调
 *
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"\n ====== 温馨提示,消息通道建立成功,该通道创建成功表示‘在线’，可以接收到推送的消息");
}

//注册推送消息到来监听
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:@"CCPDidReceiveMessageNotification" object:nil];
}
//处理到来推送消息
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    [self setloadData];
    
    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:message.body options:NSJSONReadingMutableContainers error:nil];
    
    NSString *param = [userInfo valueForKey:@"param"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRefresh" object:nil];
//    NSLog(@"%@",userInfo);
    
    if ([param isEqual:@"100"]||[param isEqual:@"101"]) {
        //通知二维码关闭
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BoaringVC" object:nil];
    }else if([param isEqual:@"104"] || [param isEqual:@"105"] || [param isEqual:@"106"]){
        // NSLog(@"%@",userInfo);
        //通知刷新我的页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MeRefresh" object:nil];
    }
    
}
//  App处于启动状态时，通知打开回调
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *viewType = [userInfo valueForKey:@"viewType"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, viewType);
    
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 跳转页面
    [self setControllers:userInfo];
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
    
}
//userNotificationCenter代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSString *userAction = response.actionIdentifier;
    
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"\n ====== User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category 创建时传入 UNNotificationCategoryOptionCustomDismissAction 才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"\n ====== User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"\n ====== App 处于前台时收到通知 (iOS 10+ ) Receive a notification in foregound.");
    
    //音效文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PushSound" ofType:@"caf"];
    // 这里是指你的音乐名字和文件类型
    NSLog(@"path-----------------------%@",path);
    
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:notification];
    
    
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}
/**
 *  处理App 处于前台时收到通知 (iOS 10+ )
 */
- (void)handleiOS10Notification:(UNNotification *)notification  API_AVAILABLE(ios(10.0)){
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    //NSDate *noticeDate = notification.date;
    // 标题
    //NSString *title = content.title;
    // 副标题
    //NSString *subtitle = content.subtitle;
    // 内容
    // NSString *body = content.body;
    // 角标
    // int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    // NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端 SDK1.9.5 以后才支持
    [self syncBadgeNum:0];
    // 跳转页面
    [self setControllers:userInfo];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    // NSLog(@"\n ====== App 处于前台时收到通知 (iOS 10+ ) Notification, == date: %@, == title: %@, == subtitle: %@, == body: %@, == badge: %d, == extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}
/* 同步通知角标数到服务端 */
- (void)syncBadgeNum:(NSUInteger)badgeNum {
    [CloudPushSDK syncBadgeNum:badgeNum withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"\n ====== Sync badge num: [%lu] success.", (unsigned long)badgeNum);
        } else {
            NSLog(@"\n ====== Sync badge num: [%lu] failed, error: %@", (unsigned long)badgeNum, res.error);
        }
    }];
}

#pragma mark 获取自定义消息内容
//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//
//    [self setloadData];
//
//    NSDictionary *userInfo = [notification userInfo];
//
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//
//    NSString *param = [extras valueForKey:@"param"];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRefresh" object:nil];
//    //NSLog(@"%@",userInfo);
//    if ([param isEqual:@"100"]||[param isEqual:@"101"]) {
//        //通知二维码关闭
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"BoaringVC" object:nil];
//    }else if([param isEqual:@"104"] || [param isEqual:@"105"] || [param isEqual:@"106"]){
//       // NSLog(@"%@",userInfo);
//        //通知刷新我的页面
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MeRefresh" object:nil];
//    }
//
//}
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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    [self setloadData];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
    [self setloadData];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber != 0) {
        // 发起请求获取未读消息的内容
        // 点击 icon 从后台进入应用时, 对 badge 的处理
        application.applicationIconBadgeNumber = 0;
        
        // 清除导航栏未读的通知
        [_notificationCenter removeAllDeliveredNotifications];
        
    }
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
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"taskShare" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"tasks" object:nil];
            }
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"分享取消"];
        }
    }
    
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
    NSLog(@"%@",userInfo);
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
