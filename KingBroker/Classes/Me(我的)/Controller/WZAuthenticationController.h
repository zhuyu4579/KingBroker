//
//  WZAuthenticationController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZAuthenticationController : UIViewController
//真实姓名
@property (weak, nonatomic) IBOutlet UITextField *name;
//身份证号
@property (weak, nonatomic) IBOutlet UITextField *idCode;
//身份证照片标题
@property (weak, nonatomic) IBOutlet UILabel *codeImageTitle;
//身份证照片
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
//提交
@property (weak, nonatomic) IBOutlet UIButton *getUpButton;
@property (strong, nonatomic) IBOutlet UIView *viewOne;
@property (strong, nonatomic) IBOutlet UIView *viewTwo;

- (IBAction)comfireButton:(id)sender;

//回调实名认证状态
@property(nonatomic,strong)void(^statusBlock)(NSString *status);
@end
