//
//  WZBoaringCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZBoardingItem;
@interface WZBoaringCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameOne;
@property (weak, nonatomic) IBOutlet UILabel *telephoneOne;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameOne;
@property (weak, nonatomic) IBOutlet UILabel *boaringTimeOne;
@property (weak, nonatomic) IBOutlet UILabel *stateOne;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UILabel *nameTwo;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameTwo;
@property (weak, nonatomic) IBOutlet UILabel *telephoneTwo;


@property (weak, nonatomic) IBOutlet UILabel *boaringTimeTwo;
@property (weak, nonatomic) IBOutlet UILabel *stateTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UILabel *nameThree;
@property (weak, nonatomic) IBOutlet UILabel *telephoneThree;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameThree;

@property (weak, nonatomic) IBOutlet UILabel *boaringTimeThree;
@property (weak, nonatomic) IBOutlet UILabel *stateThree;
@property (weak, nonatomic) IBOutlet UILabel *nameFour;
@property (weak, nonatomic) IBOutlet UILabel *telephoneFour;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameFour;

@property (weak, nonatomic) IBOutlet UILabel *boaringTimeFour;
@property (weak, nonatomic) IBOutlet UILabel *stateFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
//楼盘ID
@property(nonatomic,strong)NSString *itemIdOne;
@property(nonatomic,strong)NSString *itemIdTwo;
@property(nonatomic,strong)NSString *itemIdThree;
@property(nonatomic,strong)NSString *itemIdFour;
//订单ID
@property(nonatomic,strong)NSString *boaringId;

- (IBAction)startDealButtonTwo:(id)sender;
- (IBAction)newReportButtonFour:(id)sender;
//数据模型
@property(nonatomic,strong)WZBoardingItem *item;
//审核状态
@property(nonatomic,strong)NSArray *SHStatus;
//二维码图片
@property(nonatomic,strong)NSString *url;
//签约状态
@property(nonatomic,strong)NSString *sginStatus;
//电话
@property(nonatomic,strong)NSString *proTelphone;
//创建时间
@property(nonatomic,strong)NSString *orderCreateTime;
//冷却时间
@property(nonatomic,strong)NSString *boardingLimitTime;
@end
