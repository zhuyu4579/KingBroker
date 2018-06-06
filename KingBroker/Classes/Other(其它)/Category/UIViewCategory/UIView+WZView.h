//
//  UIView+WZView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  创建占位图

#import <UIKit/UIKit.h>

@interface UIView (WZView)

+(UIView *)createView:(CGRect)rect image:(UIImage *)image titles:(NSString *)title;

@end
