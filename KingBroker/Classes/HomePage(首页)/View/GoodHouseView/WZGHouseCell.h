//
//  WZGHouseCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZFindHouseListItem;
@interface WZGHouseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
@property (strong, nonatomic) IBOutlet UIImageView *houseTypeImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *houseTypeY;

@property (strong, nonatomic) IBOutlet UIView *collenView;
@property (weak, nonatomic) IBOutlet UILabel *houseItemName;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *houseLabelThree;
//公司名称
@property (strong, nonatomic) IBOutlet UILabel *companyName;
//单价
@property (strong, nonatomic) IBOutlet UILabel *housePrice;
//收藏按钮
@property (strong, nonatomic) IBOutlet UIButton *houseCollectionButton;
//佣金
@property (strong, nonatomic) IBOutlet UIButton *commissionButton;
//城市名称
@property (strong, nonatomic) IBOutlet UILabel *cityName;

@property(nonatomic,strong)NSString *ID;

- (IBAction)JoinStore:(UIButton *)sender;
@property(nonatomic,strong)WZFindHouseListItem *item;
- (IBAction)houseCollectionClick:(id)sender;

@end
