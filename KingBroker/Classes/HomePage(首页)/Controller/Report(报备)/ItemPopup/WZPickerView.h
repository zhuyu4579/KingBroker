//
//  WZPickerView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPickerView : UIView

/** array */
@property (nonatomic, strong) NSArray *array;
/** title */
@property (nonatomic, strong) NSString *title;
//返回所选值
@property(nonatomic,strong)void(^pickerBlock)(NSDictionary *names);
//快速创建
+ (instancetype)pickerView;

//弹出
- (void)show;

@end
