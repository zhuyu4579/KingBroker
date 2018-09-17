//
//  WZTitleCollectionViewCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZAlbumsItem;
@interface WZTitleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIView *ineView;

@property (nonatomic, strong) WZAlbumsItem *item;
@end
