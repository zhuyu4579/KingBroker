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

@property (strong, nonatomic) IBOutlet UILabel *manSex;

@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *birthDate;
@property (weak, nonatomic) IBOutlet UILabel *birthAddress;
@property (weak, nonatomic) IBOutlet UILabel *employmentTime;
@property (weak, nonatomic) IBOutlet UILabel *entryTime;
@property (strong, nonatomic) IBOutlet UIButton *selectSexMan;
@property (strong, nonatomic) IBOutlet UIButton *selectWomanSex;

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
- (IBAction)selectSex:(UIButton *)sender;

- (IBAction)setUpBirthDate:(UIButton *)sender;
- (IBAction)setUpEmploymentTime:(UIButton *)sender;
- (IBAction)setUpBirthAddress:(UIButton *)sender;
- (IBAction)setUpEntryTime:(UIButton *)sender;


@end
