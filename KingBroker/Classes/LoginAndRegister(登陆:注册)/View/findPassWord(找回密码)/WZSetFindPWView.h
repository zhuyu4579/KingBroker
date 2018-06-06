//
//  WZSetFindPWView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSetFindPWView : UIView
@property (weak, nonatomic) IBOutlet UITextField *NewPassWordText;
@property (weak, nonatomic) IBOutlet UIButton *NewPWShowOne;
@property (weak, nonatomic) IBOutlet UITextField *AgainPassWordText;
@property (weak, nonatomic) IBOutlet UIButton *NewPWShow;
@property (weak, nonatomic) IBOutlet UIButton *FromNewPassWord;

+(instancetype)SetNewPW;
//账号
@property(nonatomic,strong)NSString *phone;
//验证码
@property(nonatomic,strong)NSString *YZM;
@end
