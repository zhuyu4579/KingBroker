//
//  WZReportSuccessController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZReportSuccessController : UIViewController
//接收报备成功数据
@property(nonatomic,strong)NSDictionary *reportData;
//签约状态
@property(nonatomic,strong)NSString *status;
//项目负责人电话
@property(nonatomic,strong)NSString *telphone;

@end
