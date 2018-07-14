//
//  WZShareDetailCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZShareDetailsItem;
@interface WZShareDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UILabel *shareDetailTitle;
@property (strong, nonatomic) IBOutlet UILabel *shareDetailContent;
@property(nonatomic,strong)WZShareDetailsItem *item;


@end
