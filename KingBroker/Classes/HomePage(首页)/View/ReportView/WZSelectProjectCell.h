//
//  WZSelectProjectCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZSelcetProjectItem;
@interface WZSelectProjectCell : UITableViewCell
//项目名称
@property (strong, nonatomic) IBOutlet UILabel *projectName;
//是否签约
@property (strong, nonatomic) IBOutlet UILabel *signStatus;

@property (strong, nonatomic) IBOutlet UILabel *companyName;

//项目id
@property(nonatomic,strong)NSString *projectId;

//数据模型
@property(nonatomic,strong)WZSelcetProjectItem *item;
@end
