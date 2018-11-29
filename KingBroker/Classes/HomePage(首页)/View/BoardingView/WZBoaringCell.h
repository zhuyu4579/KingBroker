//
//  WZBoaringCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZBoardingItem;
@class WZBoaringCell;
typedef void (^BoardingBlock) (WZBoaringCell *);

@interface WZBoaringCell : UITableViewCell

@property(nonatomic, copy) BoardingBlock boardingBlock;

@property (strong, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (strong, nonatomic) IBOutlet UIView *viewThree;

@property (strong, nonatomic) IBOutlet UIView *viewFour;

@property (weak, nonatomic) IBOutlet UILabel *nameOne;
@property (weak, nonatomic) IBOutlet UILabel *telephoneOne;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameOne;
@property (weak, nonatomic) IBOutlet UILabel *boaringTimeOne;
@property (weak, nonatomic) IBOutlet UILabel *stateOne;
@property (strong, nonatomic) IBOutlet UILabel *houseTypeOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (strong, nonatomic) IBOutlet UIButton *button_one;
@property (strong, nonatomic) IBOutlet UIButton *button_ones;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ItemOneX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *boardingButtonX;

@property (weak, nonatomic) IBOutlet UILabel *nameTwo;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameTwo;
@property (weak, nonatomic) IBOutlet UILabel *telephoneTwo;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeTwo;
@property (weak, nonatomic) IBOutlet UIButton *button_two;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ItemTwoX;


@property (weak, nonatomic) IBOutlet UILabel *boaringTimeTwo;
@property (weak, nonatomic) IBOutlet UILabel *stateTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTwoX;

@property (weak, nonatomic) IBOutlet UILabel *nameThree;
@property (weak, nonatomic) IBOutlet UILabel *telephoneThree;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameThree;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeThree;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ItemThreeX;

@property (weak, nonatomic) IBOutlet UILabel *boaringTimeThree;
@property (weak, nonatomic) IBOutlet UILabel *nameFour;
@property (weak, nonatomic) IBOutlet UILabel *telephoneFour;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameFour;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeFour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ItemFourX;

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
- (IBAction)varochBoarding:(UIButton *)sender;
- (IBAction)launchDeal:(UIButton *)sender;
//上客按钮点击事件
- (IBAction)boardingButton:(UIButton *)sender;

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
//是否为实号
@property(nonatomic,strong)NSString *orderTelFlag;
//出行人数
@property(nonatomic,strong)NSString *partPersonNum;
//用餐人数
@property(nonatomic,strong)NSString *lunchNum;
//出行方式
@property(nonatomic,strong)NSString *partWay;
//出发城市
@property(nonatomic,strong)NSString *departureCity;
//预计上客时间
@property(nonatomic,strong)NSString *boardingPlane;
//楼盘类型
@property(nonatomic,strong)NSString *selfEmployed;
@end
