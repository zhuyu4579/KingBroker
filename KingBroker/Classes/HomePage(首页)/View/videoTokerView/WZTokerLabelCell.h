//
//  WZTokerLabelCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZTokerTitleItem;
@interface WZTokerLabelCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property(nonatomic,strong)WZTokerTitleItem *item;
@property(nonatomic,strong)NSString *name;
@end
