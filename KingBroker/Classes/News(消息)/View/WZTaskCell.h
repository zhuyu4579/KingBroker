//
//  WZTaskCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZAnnNewItem;
@interface WZTaskCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *reads;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UIImageView *imageViews;
@property (strong, nonatomic) IBOutlet UIView *views;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleIne;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentIne;

//展示类型
@property(nonatomic,strong)NSString *viewType;
//url
@property(nonatomic,strong)NSString *url;
//url
@property(nonatomic,strong)NSString *ID;
//跳转指定的页面
@property(nonatomic,strong)NSString *param;
//楼盘ID
@property(nonatomic,strong)NSString *additional;
//数据模型
@property(nonatomic,strong)WZAnnNewItem *item;

@end
