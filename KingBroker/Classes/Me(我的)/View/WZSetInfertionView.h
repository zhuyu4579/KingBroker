//
//  WZSetInfertionView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSetInfertionView : UIView
+(instancetype)setInforation;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeID;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *birthDate;
@property (weak, nonatomic) IBOutlet UILabel *birthAddress;
@property (weak, nonatomic) IBOutlet UILabel *employmentTime;
@property (weak, nonatomic) IBOutlet UILabel *entryTime;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *birthButton;
@property (weak, nonatomic) IBOutlet UIButton *birthAdressButton;
@property (weak, nonatomic) IBOutlet UIButton *employmentTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *entryTimeButton;
//门店位置
@property(nonatomic,strong)NSString *cityName;
//门店地址
@property(nonatomic,strong)NSString *storeAddr;
//身份证认证状态
@property(nonatomic,strong)NSString *idcardStatus;
//认证状态
@property(nonatomic,strong)NSString *realtorStatus;
//门店负责人
@property(nonatomic,strong)NSString *dutyFlag;
//个人信息数据
@property(nonatomic,strong)NSDictionary *datas;
//查询的照片
@property(nonatomic,strong)NSString *url;

- (IBAction)setUpHeadImage:(UIButton *)sender;
- (IBAction)setUpStoreAndId:(UIButton *)sender;
- (IBAction)setUpSex:(UIButton *)sender;
- (IBAction)setUpBirthDate:(UIButton *)sender;
- (IBAction)setUpEmploymentTime:(UIButton *)sender;
- (IBAction)setUpBirthAddress:(UIButton *)sender;
- (IBAction)setUpEntryTime:(UIButton *)sender;


@end
