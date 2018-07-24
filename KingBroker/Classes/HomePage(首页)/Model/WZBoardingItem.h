//
//  WZBoardingItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZBoardingItem : NSObject
//订单ID
@property(nonatomic,strong)NSString *id;
//客户名称
@property(nonatomic,strong)NSString *clientName;
//第一个缺失号码
@property(nonatomic,strong)NSString *missContacto;
//订单时间
@property(nonatomic,strong)NSString *updateDate;
//楼盘名
@property(nonatomic,strong)NSString *projectName;
//交易状态
@property(nonatomic,strong)NSString *dealStatus;
//审核状态
@property(nonatomic,strong)NSString *verify;
//标签
@property(nonatomic,strong)NSString *projectType;
//楼盘Id
@property(nonatomic,strong)NSString *projectId;
//二维码
@property(nonatomic,strong)NSString *url;
//签约状态
@property(nonatomic,strong)NSString *sginStatus;
//电话号码
@property(nonatomic,strong)NSString *proTelphone;
//电话号码
@property(nonatomic,strong)NSString *orderCreateTime;
//冷却时间
@property(nonatomic,strong)NSString *boardingLimitTime;
@end
