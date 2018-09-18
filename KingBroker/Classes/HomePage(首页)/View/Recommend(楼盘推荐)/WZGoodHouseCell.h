//
//  WZGoodHouseCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZGoodHouseItem;
@interface WZGoodHouseCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong,nonatomic) NSString *ID;
@property (strong,nonatomic) WZGoodHouseItem *item;
@end
