//
//  WZFindHouseListItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/16.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZFindHouseListItem : NSObject
//项目id
@property(nonatomic,strong)NSString *id;
//项目照片
@property(nonatomic,strong)NSString *url;
//项目名称
@property(nonatomic,strong)NSString *name;
//均价
@property(nonatomic,strong)NSString *averagePrice;
//佣金
@property(nonatomic,strong)NSString *commission;
//是否已被收藏(0.否1.是)
@property(nonatomic,strong)NSString *collect;
//收藏人数
@property(nonatomic,strong)NSString *collectNum;
//标签
@property(nonatomic,strong)NSArray *tage;
//城市名称
@property(nonatomic,strong)NSString *cityName;
//总价
@property(nonatomic,strong)NSString *totalPrice;
//距离
@property(nonatomic,strong)NSString *distance;
//公司名称
@property(nonatomic,strong)NSString *companyName;

@end
