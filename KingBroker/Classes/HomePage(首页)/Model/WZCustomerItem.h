//
//  WZCustomerItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZCustomerItem : NSObject
//电话号码
@property(nonatomic,strong)NSString *missContacto;
//客户姓名
@property(nonatomic,strong)NSString *name;
//订单
@property(nonatomic,strong)NSString *orderId;
@end
