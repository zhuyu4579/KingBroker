//
//  WZFrowardDetailedCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZFrowardItem;
@interface WZFrowardDetailedCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleName;
@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property(nonatomic,strong)WZFrowardItem *item;
@end
