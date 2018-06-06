//
//  WZSetPassWordView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSetPassWordView : UIView
@property (weak, nonatomic) IBOutlet UITextField *passWordOne;
@property (weak, nonatomic) IBOutlet UITextField *passWordTwo;
@property (weak, nonatomic) IBOutlet UIButton *showPassWordS;
@property (weak, nonatomic) IBOutlet UIButton *setRegistarButton;
@property (weak, nonatomic) IBOutlet UIButton *showPassWordOne;
@property(nonatomic,strong)NSMutableDictionary *registDictionary;

+(instancetype)SetPWView;
//传值给注册view页面
@property(nonatomic,strong)void(^setPWBlock)(NSMutableDictionary *regs);
//加入门店的状态
@property(nonatomic,assign)NSString *storeStare;
@end
