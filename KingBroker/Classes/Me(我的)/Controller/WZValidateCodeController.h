//
//  WZValidateCodeController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZValidateCodeController : UIViewController
//当前密码
@property(nonatomic,strong)NSString *passWord;
@property (strong, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *code;
@property (strong, nonatomic) IBOutlet UIButton *findCode;
@property (strong, nonatomic) IBOutlet UIButton *telphoneButton;
//验证手机号类型
@property(nonatomic,strong)NSString *type;
- (IBAction)findCodes:(UIButton *)sender;
- (IBAction)playTelphone:(UIButton *)sender;

@end
