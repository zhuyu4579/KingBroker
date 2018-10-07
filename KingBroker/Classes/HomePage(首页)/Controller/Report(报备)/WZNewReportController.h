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
@property (nonatomic, copy)NSString *ItemNames;
//楼盘是否签约
@property(nonatomic,strong)NSString *sginStatu;
//楼盘负责人电话
@property(nonatomic,strong)NSString *dutyTelphone;
//电话是否为实号
@property(nonatomic,strong)NSString *orderTelFlag;
//默认第一个客户姓名
@property (nonatomic, strong)UITextField *custormName;
@property (nonatomic, copy)NSString *custormNames;
//默认第一个客户电话前半部分
@property (nonatomic, strong)UITextField *telphone;
//默认第一个客户电话后半部分
@property (nonatomic, strong)UITextField *afterTelphone;

@property (nonatomic, copy)NSString *telphones;
//其他报备入口类型
@property(nonatomic,strong)NSString *types;

@end
