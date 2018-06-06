//
//  WZRegistarView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZRegistarView : UIView
@property (weak, nonatomic) IBOutlet UITextField *regAdminText;
@property (weak, nonatomic) IBOutlet UITextField *regPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *findYZMText;
@property (weak, nonatomic) IBOutlet UIButton *agreenText;
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;
@property (weak, nonatomic) IBOutlet UILabel *labels;
@property (weak, nonatomic) IBOutlet UIButton *XYText;
@property (weak, nonatomic) IBOutlet UIButton *nextText;
+(instancetype)registarView;

- (IBAction)seeAgreement:(id)sender;
//逆传值给注册VC页面
@property(nonatomic,strong)void(^registarBlock)(NSDictionary *registar);

@end
