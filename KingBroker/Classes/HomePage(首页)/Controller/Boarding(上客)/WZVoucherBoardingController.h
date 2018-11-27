//
//  WZVoucherBoardingController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/11/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZVoucherBoardingController : UIViewController
//订单ID
@property(nonatomic,strong)NSString *ID;
//上传图片成功回调
@property(nonatomic,strong)void(^boardingSuccess)(NSString *str);
@end

NS_ASSUME_NONNULL_END
