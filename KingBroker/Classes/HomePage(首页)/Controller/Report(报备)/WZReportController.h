//
//  WZReportController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZReportController : UIViewController
//楼盘ID
@property(nonatomic,strong)NSString *itemID;
//楼盘名称
@property(nonatomic,strong)NSString *itemName;
//楼盘报备标识
@property(nonatomic,strong)NSString *types;
//楼盘是否签约
@property(nonatomic,strong)NSString *sginStatus;
//楼盘负责人电话
@property(nonatomic,strong)NSString *telphone;
//客户姓名
@property(nonatomic,strong)NSString *name;
//客户电话
@property(nonatomic,strong)NSString *phone;
@end
