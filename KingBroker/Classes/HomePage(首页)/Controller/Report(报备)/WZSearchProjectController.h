//
//  WZSearchProjectController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSearchProjectController : UITableViewController
//
@property(nonatomic,strong)void(^blockItem)(NSDictionary *dicty);
@end
