//
//  WZTypeViewCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZTypeItem;
@interface WZTypeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeHouse;
//数据模型
@property(nonatomic,strong)WZTypeItem *item;
//数据的value
@property(nonatomic,strong)NSString *value;

@end
