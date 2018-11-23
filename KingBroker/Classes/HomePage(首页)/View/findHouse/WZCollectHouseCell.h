//
//  WZCollectHouseCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZFindHouseListItem;
@interface WZCollectHouseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *projectIamge;
@property (strong, nonatomic) IBOutlet UILabel *projectName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *houseTypeY;
@property (strong, nonatomic) IBOutlet UIImageView *houseTypeImage;
@property (strong, nonatomic) IBOutlet UIView *companyView;

@property (strong, nonatomic) IBOutlet UILabel *labelTag;

@property (strong, nonatomic) IBOutlet UILabel *prices;
@property (strong, nonatomic) IBOutlet UILabel *labelOne;
@property (strong, nonatomic) IBOutlet UILabel *labelTwo;
@property (strong, nonatomic) IBOutlet UILabel *labelThree;
@property (strong, nonatomic) IBOutlet UILabel *commsion;
@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *companyName;
//距离
@property (strong, nonatomic) IBOutlet UILabel *distance;

@property (strong, nonatomic) IBOutlet UIButton *JoinStoreButton;
@property (strong, nonatomic) IBOutlet UIButton *houseCollectionButton;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)WZFindHouseListItem *item;
- (IBAction)JoinStore:(UIButton *)sender;
- (IBAction)houseCollectionClick:(id)sender;
@property(nonatomic,strong)void(^deleteblock)(UITableViewCell *cell);
@end
