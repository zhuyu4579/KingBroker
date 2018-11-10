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
@property (strong, nonatomic) IBOutlet UILabel *labelTag;

@property (weak, nonatomic) IBOutlet UILabel *houseItemName;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *houseLabelThree;
//佣金
@property (strong, nonatomic) IBOutlet UILabel *houseCommission;
//单价
@property (strong, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *housePrice;
@property (strong, nonatomic) IBOutlet UIButton *houseCollectionButton;
@property (strong, nonatomic) IBOutlet UIButton *JoinStoreButton;

@property (strong, nonatomic) IBOutlet UILabel *cityName;
//距离
@property (strong, nonatomic) IBOutlet UILabel *distance;

@property(nonatomic,strong)NSString *ID;

- (IBAction)JoinStore:(UIButton *)sender;
@property(nonatomic,strong)WZFindHouseListItem *item;
- (IBAction)houseCollectionClick:(id)sender;

@end
