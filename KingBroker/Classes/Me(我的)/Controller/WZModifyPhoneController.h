//
//  WZModifyPhoneController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZModifyPhoneController : UIViewController
//旧手机号
@property(nonatomic,strong)NSString *oldPhone;
//密码
@property(nonatomic,strong)NSString *password;
//密码
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
@property(nonatomic,strong)NSString *oldYZM;
@end
