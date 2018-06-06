//
//  WZAddCustormCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZCustomerItem;
@interface WZAddCustormCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

//数据模型
@property(nonatomic,strong)WZCustomerItem *item;

@end
