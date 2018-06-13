//
//  WZSettingController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSettingController : UIViewController
//修改密码
@property (weak, nonatomic) IBOutlet UIButton *modifyPassWord;
//修改绑定手机
@property (weak, nonatomic) IBOutlet UIButton *modifyTelephone;
//清除缓存
@property (weak, nonatomic) IBOutlet UIButton *cleanCache;
//缓存数据
@property (weak, nonatomic) IBOutlet UILabel *cacha;
//实名认证
@property (strong, nonatomic) IBOutlet UILabel *authenStatus;
@property (strong, nonatomic) IBOutlet UIButton *authen;
//关于我们
@property (weak, nonatomic) IBOutlet UIButton *aboutUs;
//退出登录
@property (weak, nonatomic) IBOutlet UIButton *ExitLogon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
//退出登录
- (IBAction)exitLogin:(id)sender;
//关于我们
- (IBAction)aboutus:(UIButton *)sender;
//清除缓存
- (IBAction)cacha:(UIButton *)sender;
//修改电话
- (IBAction)modifyTelephone:(UIButton *)sender;
- (IBAction)modifyPassWord:(UIButton *)sender;
- (IBAction)authenAction:(UIButton *)sender;

@end
