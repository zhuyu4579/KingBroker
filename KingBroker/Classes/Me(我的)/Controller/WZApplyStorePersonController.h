//
//  WZApplyStorePersonController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZApplyStorePersonController : UIViewController
//实名认证状态
@property(nonatomic,strong)NSString *idCardstatus;
//门店负责人审核状态
@property(nonatomic,strong)void(^statusBlock)(NSString *status);
@end
