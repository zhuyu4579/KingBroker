//
//  WZAddCustomerController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZAddCustomerController : UITableViewController
//数据数组
@property(nonatomic,strong)NSArray *arrayData;
//报备的方式
@property(nonatomic,strong)NSString *type;
//回调选择的数据
@property(nonatomic,strong)void(^cusBlock)(NSArray *cusArray);
@end
