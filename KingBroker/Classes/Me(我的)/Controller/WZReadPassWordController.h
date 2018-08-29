//
//  WZReadPassWordController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZReadPassWordController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *showPassWord;
@property (strong, nonatomic) IBOutlet UIButton *telphoneButton;

- (IBAction)showPW:(UIButton *)sender;
- (IBAction)nextAction:(UIButton *)sender;
- (IBAction)playTelphone:(UIButton *)sender;

@end
