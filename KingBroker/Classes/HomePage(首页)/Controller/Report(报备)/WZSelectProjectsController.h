//
//  WZSelectProjectsController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSelectProjectsController : UITableViewController
//返回数据
@property(nonatomic,strong)void(^projectBlock)(NSDictionary *dicty);
@end
