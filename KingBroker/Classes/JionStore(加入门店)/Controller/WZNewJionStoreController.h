//
//  WZNewJionStoreController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  加入门店

#import <UIKit/UIKit.h>

@interface WZNewJionStoreController : UIViewController
//判断返回的页面
@property(nonatomic,strong)NSString *types;
//判断是加入门店还是门店负责人
@property(nonatomic,strong)NSString *jionType;
@end
