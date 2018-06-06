//
//  WZRegSetPWController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZRegSetPWController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *SetPassWord;
@property(nonatomic,strong)NSMutableDictionary *registar;
//将值传给上一个页面
@property(nonatomic,strong)void(^regBlock)(NSDictionary *regs);
@end
