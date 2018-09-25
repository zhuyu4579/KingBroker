//
//  WZAnnNewItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZAnnNewItem : NSObject

@property(nonatomic,strong)NSString *id;
//h5地址
@property(nonatomic,strong)NSString *url;
//图片
@property(nonatomic,strong)NSString *pictureIds;
//biaot
@property(nonatomic,strong)NSString *title;
//已读未读
@property(nonatomic,strong)NSString *readFlag;
//内容
@property(nonatomic,strong)NSString *content;
//用户ID
@property(nonatomic,strong)NSString *userId;
//时间
@property(nonatomic,strong)NSString *releaseDateStr;
//展示类型
@property(nonatomic,strong)NSString *viewType;
//跳转指定的页面
@property(nonatomic,strong)NSString *param;
//楼盘ID
@property(nonatomic,strong)NSString *additional;

@end
