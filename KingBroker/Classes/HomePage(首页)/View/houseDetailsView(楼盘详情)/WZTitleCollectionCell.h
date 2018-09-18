//
//  WZTitleCollectionCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZHouseDetilItem;
@interface WZTitleCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)WZHouseDetilItem *item;
@property(nonatomic,strong)NSString *pcdNum;
@end
