//
//  UIColor+Tools.h
//  01-第一个综合楼盘
//
//  Created by Liu-Mac on 14/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tools)

/**
 *  返回随机颜色
 */
+ (instancetype)randColor;

/**
 *  将16进制字符串转换成UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
/*
 设置按钮背景颜色
 */
+ (UIImage *) imageWithColor: (UIColor *)color;
//
//字符串替换部分颜色
+(NSMutableAttributedString *)changeSomeText:(NSString *)str inText:(NSString *)result withColor:(UIColor *)color;
@end
