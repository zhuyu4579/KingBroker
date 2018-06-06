//
//  WZLoginRegistar.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/16.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZLoginRegistar : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginAdmin;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet UIButton *showHIdePassWord;
@property (weak, nonatomic) IBOutlet UIButton *findPassWord;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registarButton;

//模型数组
@property(nonatomic,strong)NSDictionary *loginItem;
//将值传入上个页面
@property (strong, nonatomic)void(^login)(NSDictionary *login);

+(instancetype)loginRegistar;

- (IBAction)findPassWordAction:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)registar:(id)sender;

@end

