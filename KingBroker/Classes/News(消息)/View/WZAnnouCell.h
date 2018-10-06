//
//  WZAnnouCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZAnnNewItem;
@interface WZAnnouCell : UITableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *annTitleName;
//内容
@property (weak, nonatomic) IBOutlet UILabel *content;
//图片
@property (strong, nonatomic) IBOutlet UIImageView *imageViews;
//未读标识
@property (strong, nonatomic) IBOutlet UIButton *readFlag;
//展示类型
@property(nonatomic,strong)NSString *viewType;
//时间
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleY;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentY;
//未读/已读
@property(nonatomic,strong)NSString *readType;

//url
@property(nonatomic,strong)NSString *url;
//ID
@property(nonatomic,strong)NSString *ID;
//数据模型
@property(nonatomic,strong)WZAnnNewItem *item;

@end
