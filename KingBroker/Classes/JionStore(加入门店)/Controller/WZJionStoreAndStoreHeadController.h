//
//  WZJionStoreAndStoreHeadController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZJionStoreAndStoreHeadController : UIViewController
//修改门店
@property(nonatomic,strong)NSString *type;
//判断返回的页面
@property(nonatomic,strong)NSString *types;
//判断是加入门店还是门店负责人
@property(nonatomic,strong)NSString *jionType;
@end
