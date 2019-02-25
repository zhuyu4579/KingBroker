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
//运营标签
@property (weak, nonatomic) IBOutlet UILabel *houseLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *houseLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *houseLabelThree;
//佣金
@property (strong, nonatomic) IBOutlet UILabel *houseCommission;
//所在地
@property (strong, nonatomic) IBOutlet UILabel *cityName;
//单价
@property (strong, nonatomic) IBOutlet UILabel *housePrice;
@property (strong, nonatomic) IBOutlet UIButton *houseCollectionButton;
@property (strong, nonatomic) IBOutlet UIButton *JoinStoreButton;
//公司名称view
@property (strong, nonatomic) IBOutlet UIView *companyView;
@property (strong, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *houseTypeLabelOne;
@property (strong, nonatomic) IBOutlet UILabel *houseTypeLabelTwo;
//喜喜直推view
@property (strong, nonatomic) IBOutlet UIView *xxztView;
@property (strong, nonatomic) IBOutlet UILabel *houseTypeOnes;
@property (strong, nonatomic) IBOutlet UILabel *houseTypeTwos;
//悬赏按钮
@property (strong, nonatomic) IBOutlet UIButton *taskButton;

@property(nonatomic,strong)NSString *ID;
//是否是自营
@property(nonatomic,strong)NSString *selfEmployed;
//是否有悬赏
@property(nonatomic,strong)NSString *isTasking;
- (IBAction)JoinStore:(UIButton *)sender;
@property(nonatomic,strong)WZFindHouseListItem *item;
- (IBAction)houseCollectionClick:(id)sender;
- (IBAction)taskButtons:(UIButton *)sender;


@end
