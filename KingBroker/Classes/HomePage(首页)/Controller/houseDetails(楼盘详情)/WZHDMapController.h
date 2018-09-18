//
//  WZHDMapController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZHDMapController : UIViewController
//坐标点
@property(nonatomic,strong)NSArray *lnglat;
//位置
@property(nonatomic,strong)NSString *address;
@end
