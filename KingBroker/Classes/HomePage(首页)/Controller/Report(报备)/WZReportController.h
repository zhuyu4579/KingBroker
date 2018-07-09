//
//  WZReportController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZReportController : UIViewController
//项目ID
@property(nonatomic,strong)NSString *itemID;
//项目名称
@property(nonatomic,strong)NSString *itemName;
//项目报备标识
@property(nonatomic,strong)NSString *types;
//项目是否签约
@property(nonatomic,strong)NSString *sginStatus;
//项目负责人电话
@property(nonatomic,strong)NSString *telphone;
//客户姓名
@property(nonatomic,strong)NSString *name;
//客户电话
@property(nonatomic,strong)NSString *phone;
@end
