//
//  WZFindHouseCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/3.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZFindHouseListItem;
@interface WZFindHouseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (weak, nonatomic) IBOutlet UILabel *houseItemName;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *houseLabelThree;
//佣金
@property (weak, nonatomic) IBOutlet UILabel *houseCommission;
//单价
@property (weak, nonatomic) IBOutlet UILabel *housePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *housePrice;
@property (weak, nonatomic) IBOutlet UIButton *houseCollectionButton;
@property (weak, nonatomic) IBOutlet UILabel *houseCollectionSum;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
//距离
@property (strong, nonatomic) IBOutlet UILabel *distance;

@property(nonatomic,strong)NSString *ID;

@property(nonatomic,strong)WZFindHouseListItem *item;
- (IBAction)houseCollectionClick:(id)sender;

@end
