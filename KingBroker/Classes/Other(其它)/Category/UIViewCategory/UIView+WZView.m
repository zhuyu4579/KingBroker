//
//  UIView+WZView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "UIView+WZView.h"
#import "UIView+Frame.h"
#import "UIView+Center.h"
#import <Masonry.h>
@implementation UIView (WZView)
//创建一个占位的view
+(UIView *)createView:(CGRect)rect image:(UIImage *)image titles:(NSString *)title{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [imageView sizeToFit];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(10);
    }];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.fHeight-23,view.fWidth , 13)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    [view addSubview:label];
    return view;
}
@end
