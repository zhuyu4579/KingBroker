//
//  UIBarButtonItem+Item.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
@implementation UIBarButtonItem (Item)

#pragma mark -给导航条添加一个按钮
+(UIBarButtonItem *)itemWithButtons:(id)target action:(SEL)action title:(NSString *)title {
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 15)];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorRBG(102, 221, 85) forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action{
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:image	 forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    //调整按钮位置
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    //[btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
    
}
#pragma mark -给导航条添加一个按钮
+(UIBarButtonItem *)itemWithButton:(id)target action:(SEL)action title:(NSString *)title {
    //创建一个button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:3/255.0 green:133/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    //调整按钮位置
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
    
}
#pragma mark -创建一个返回按钮
+(UIBarButtonItem *)backItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    //设置返回按钮样式
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    //[backButton setTitle:title forState:UIControlStateNormal];
    //设置字体状态颜色
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    //设置图片
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    //调整按钮位置
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    //适应图片
    //[backButton sizeToFit];
    //返回上一个控制器
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
@end
