//
//  WZSetNewPassWordController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSetNewPassWordController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *passWordTextFile;
//账号
@property(nonatomic,strong)NSString *phone;
//验证码
@property(nonatomic,strong)NSString *YZM;
@end
