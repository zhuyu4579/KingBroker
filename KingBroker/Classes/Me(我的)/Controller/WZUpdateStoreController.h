//
//  WZUpdateStoreController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZUpdateStoreController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *telphone;
@property (strong, nonatomic) IBOutlet UITextField *verificationCode;
@property (strong, nonatomic) IBOutlet UIButton *verifictionButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
- (IBAction)ObtainVerificationCode:(UIButton *)sender;
- (IBAction)nextAction:(UIButton *)sender;

@end
