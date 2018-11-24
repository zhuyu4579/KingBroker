//
//  WZRecommendCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZFindHouseListItem;
@interface WZRecommendCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *houseType;

@property (weak, nonatomic) IBOutlet UIImageView *RecommendImage;
@property (weak, nonatomic) IBOutlet UILabel *RecommendName;
@property (weak, nonatomic) IBOutlet UILabel *RecommendTitleOne;
@property (weak, nonatomic) IBOutlet UILabel *RecommendTitleTwo;
@property (weak, nonatomic) IBOutlet UILabel *RecommendThree;
@property (weak, nonatomic) IBOutlet UILabel *Commission;

@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *prices;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *cityName;

@property(nonatomic,strong)NSString *ID;

@property(nonatomic,strong)NSString *selfEmployed;

@property(nonatomic,strong)WZFindHouseListItem *item;
- (IBAction)JoinStore:(UIButton *)sender;

@end
