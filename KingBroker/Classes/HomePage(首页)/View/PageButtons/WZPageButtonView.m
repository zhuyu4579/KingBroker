//
//  WZPageButtonView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPageButtonView.h"
#import "WZReportController.h"
#import "UIViewController+WZFindController.h"
#import "WZBoaringController.h"
#import "WZHousePageController.h"
#import "NSString+LCExtension.h"
#import <SVProgressHUD.h>
#import "WZTaskNotificationController.h"
#import "WZAnnouncemeController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZTaskController.h"
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
#import "WZNavigationController.h"
@interface WZPageButtonView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1X;
@property(nonatomic,strong) UIViewController *VC;
@end

@implementation WZPageButtonView
-(void)layoutSubviews{
    _line1X.constant =(SCREEN_WIDTH - 210)/3-2;
    _line2X.constant =(SCREEN_WIDTH - 210)/3-2;
    [_newsLable setEnlargeEdge:20];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
}

#pragma mark -接悬赏
- (IBAction)answerTask:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    _VC = [UIViewController viewController:[self superview]];
    if(uuid){
        if([realtorStatus isEqual:@"2"]){
            //跳转
            WZTaskController *task = [[WZTaskController alloc] init];
            task.url = [NSString stringWithFormat:@"%@/apptask/getuuid.html",HTTPH5];
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:task];
            [_VC.navigationController presentViewController:nav animated:YES completion:nil];
            
        }else if([realtorStatus isEqual:@"0"] ||[realtorStatus isEqual:@"3"]){
            [self store:_VC];
        }else{
            [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
            [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
        }
    }else{
        [NSString isCode:_VC.navigationController code:@"401"];
    }
    
}
#pragma mark -找楼盘
- (IBAction)findHouses:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    _VC = [UIViewController viewController:[self superview]];
    if(uuid){
        //跳转找楼盘页面
        WZHousePageController *house = [[WZHousePageController alloc] init];
        house.status = 0;
        [_VC.navigationController pushViewController:house animated:YES];
    }else{
        [NSString isCode:_VC.navigationController code:@"401"];
    }
   
}
#pragma mark -报备
- (IBAction)Report:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
     _VC = [UIViewController viewController:[self superview]];
    if (uuid) {
        if([realtorStatus isEqual:@"2"]){
            //跳转报备页面
            WZReportController *reportVC = [[WZReportController alloc] init];
            [_VC.navigationController pushViewController:reportVC animated:YES];
        } else if([realtorStatus isEqual:@"0"] ||[realtorStatus isEqual:@"3"]){
            [self store:_VC];
        }else{
            [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
            [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
        }
       
    }else{
        [NSString isCode:_VC.navigationController code:@"401"];
    }
    
    
}
#pragma mark -上客
- (IBAction)Boarding:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    _VC = [UIViewController viewController:[self superview]];
    if (uuid) {
        if([realtorStatus isEqual:@"2"]){
            WZBoaringController *bVC = [[WZBoaringController alloc] init];
            [_VC.navigationController pushViewController:bVC animated:YES];
        }else if([realtorStatus isEqual:@"0"] ||[realtorStatus isEqual:@"3"]){
            
            [self store:_VC];
        }else{
            [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
            [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
        }
    }else{
        [NSString isCode:_VC.navigationController code:@"401"];
    }
    
}
#pragma mark -查看新消息
- (IBAction)seeNews:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    _VC = [UIViewController viewController:[self superview]];
    if (uuid) {
        WZAnnouncemeController *html = [[WZAnnouncemeController alloc] init];
        _VC = [UIViewController viewController:[self superview]];
        [_VC.navigationController pushViewController:html animated:YES];
    }else{
        [NSString isCode:_VC.navigationController code:@"401"];
    }
   
}
//认证门店
-(void)store:(UIViewController *)vc{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"未加入门店" message:@"你还没有加入经纪门店，不能进行更多操作"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不加入" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"加入门店" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               WZJionStoreController *JionStore = [[WZJionStoreController alloc] init];
                                                               WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
                                                               JionStore.type = @"1";
                                                               [vc presentViewController:nav animated:YES completion:nil];
                                                           }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [vc presentViewController:alert animated:YES completion:nil];
}
+(instancetype)pageButtons{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
