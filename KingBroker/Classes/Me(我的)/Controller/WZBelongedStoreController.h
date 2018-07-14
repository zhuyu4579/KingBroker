//
//  WZBelongedStoreController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZBelongedStoreController : UIViewController
//身份证认证状态
@property(nonatomic,strong)NSString *idcardStatus;
//门店认证
@property(nonatomic,strong)NSString *realtorStatus;
//门店编码
@property(nonatomic,strong)NSString *storeCode;
//门店名称
@property(nonatomic,strong)NSString *storeName;
//门店位置
@property(nonatomic,strong)NSString *cityName;
//门店地址
@property(nonatomic,strong)NSString *cityAdder;
//门店负责人
@property(nonatomic,strong)NSString *dutyFlag;

@end
