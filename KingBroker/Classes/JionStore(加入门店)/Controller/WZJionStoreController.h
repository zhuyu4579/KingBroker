//
//  WZJionStoreController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZJionStoreController : UIViewController
//将数据传到注册设置密码页面
@property(nonatomic,strong)void(^registarBlock)(NSString *state);
//修改门店
@property(nonatomic,strong)NSString *type;
//判断返回的页面
@property(nonatomic,strong)NSString *types;
@end
