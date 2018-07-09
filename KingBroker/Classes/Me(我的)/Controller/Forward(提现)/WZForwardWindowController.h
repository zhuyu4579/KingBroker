//
//  WZForwardWindowController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZForwardWindowController : UIViewController
//可提现金额
@property(nonatomic,strong)NSString *detailPrice;
//支付宝账号
@property(nonatomic,strong)NSString *ZFBName;
//账号Id
@property(nonatomic,strong)NSString *ID;
@end
