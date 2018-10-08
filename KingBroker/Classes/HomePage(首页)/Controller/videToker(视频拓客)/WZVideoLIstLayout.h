//
//  WZVideoLIstLayout.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/10/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZVideoLIstLayout;

@protocol  WZVideoLIstLayoutDeleaget<NSObject>

@required
/**
 * 每个item的高度
 */
- (CGFloat)waterFallLayout:(WZVideoLIstLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterFallLayout:(WZVideoLIstLayout *)waterFallLayout;

/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInWaterFallLayout:(WZVideoLIstLayout *)waterFallLayout;

/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInWaterFallLayout:(WZVideoLIstLayout *)waterFallLayout;

/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(WZVideoLIstLayout *)waterFallLayout;


@end
@interface WZVideoLIstLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<WZVideoLIstLayoutDeleaget> delegate;
@end
