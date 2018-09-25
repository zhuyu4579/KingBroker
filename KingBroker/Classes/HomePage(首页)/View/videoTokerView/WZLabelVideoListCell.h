//
//  WZLabelVideoListCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZTokerVItem;
@interface WZLabelVideoListCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *videoImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)WZTokerVItem *item;
@property(nonatomic,strong)NSDictionary *dicty;
@end
