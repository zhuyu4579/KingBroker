//
//  WZNODataView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2019/1/14.
//  Copyright © 2019年 朱玉隆. All rights reserved.
//  无数据展示View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZNODataView : UIView
/**
 无图表View初始化
 */
-(instancetype)initNoDataView:(CGRect)rect imageName:(NSString *)imageName titleName:(NSString *)titleName;
@end

NS_ASSUME_NONNULL_END
