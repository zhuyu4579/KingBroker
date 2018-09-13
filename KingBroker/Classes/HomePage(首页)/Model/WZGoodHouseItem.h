//
//  WZGoodHouseItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  优质楼盘列表数据

#import <Foundation/Foundation.h>

@interface WZGoodHouseItem : NSObject
//图片
@property(nonatomic,strong)NSString *pictureIds;
//名称
@property(nonatomic,strong)NSString *labelName;
//id
@property(nonatomic,strong)NSString *id;
@end
