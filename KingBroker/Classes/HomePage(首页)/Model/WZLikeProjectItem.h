//
//  WZLikeProjectItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/16.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZLikeProjectItem : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,strong)NSString *commission;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *companyName;
@property(nonatomic,strong)NSString *selfEmployed;
@end
