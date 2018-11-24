//
//  WZDetailsViewTwo.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/11/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZDetailsViewTwo : UIView
+(instancetype)detailViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *runTageOne;
@property (strong, nonatomic) IBOutlet UILabel *runTageTwo;

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelThree;
@property (strong, nonatomic) IBOutlet UILabel *houseSum;

@property (weak, nonatomic) IBOutlet UILabel *Commission;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *developerName;

@property (weak, nonatomic) IBOutlet UIView *ineViewOne;
@property (weak, nonatomic) IBOutlet UIView *ineViewTwo;
@property(nonatomic,strong)NSArray *lnglat;
@property(nonatomic,strong)NSString *projectName;
//位置
@property(nonatomic,strong)NSString *addr;

- (IBAction)addressButton:(UIButton *)sender;

- (IBAction)JoinStore:(id)sender;
@end

NS_ASSUME_NONNULL_END
