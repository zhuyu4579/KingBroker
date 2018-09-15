//
//  WZHouseDetilItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZHouseDetilItem : NSObject
//图片数组
@property(nonatomic,strong)NSArray *pcd;
//数量
@property(nonatomic,strong)NSString *pcdNum;
//标题
@property(nonatomic,strong)NSString *title;

@end
@interface WZLunBoItems : NSObject

@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSString *id;

@property(nonatomic,strong)NSString *type;
@end
