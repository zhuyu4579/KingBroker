//
//  WZNewReportController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZNewReportController : UIViewController
//楼盘ID
@property(nonatomic,strong)NSString *itemId;
//楼盘名
@property (nonatomic, copy)UILabel *ItemName;
//楼盘是否签约
@property(nonatomic,strong)NSString *sginStatu;
//楼盘负责人电话
@property(nonatomic,strong)NSString *dutyTelphone;
//电话是否为实号
@property(nonatomic,strong)NSString *realTelFlag;
@end
