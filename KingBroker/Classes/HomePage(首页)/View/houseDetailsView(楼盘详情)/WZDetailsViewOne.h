//
//  WZDetailsViewOne.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZDetailsViewOne : UIView
+(instancetype)detailViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelThree;
@property (weak, nonatomic) IBOutlet UILabel *Commission;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIButton *JoinButton;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
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
