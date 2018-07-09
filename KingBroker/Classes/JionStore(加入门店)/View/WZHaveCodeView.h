//
//  WZHaveCodeView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZHaveCodeView : UIView
+(instancetype)haveCodeView;
//经纪人真实姓名
@property(nonatomic,strong)NSString *JName;
//返回值给上一个页面
@property(nonatomic,strong)void(^stateBlock)(NSString *state);
//修改门店
@property(nonatomic,strong)NSString *type;
//判断返回的页面
@property(nonatomic,strong)NSString *types;
@end
