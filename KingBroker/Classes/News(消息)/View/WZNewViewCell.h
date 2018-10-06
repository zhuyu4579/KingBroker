//
//  WZNewViewCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZAnnNewItem;
@interface WZNewViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UIButton *sumButton;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewH;

@property(nonatomic,strong)WZAnnNewItem *item;

@property(nonatomic,strong)NSArray *array;
//未读/已读
@property(nonatomic,strong)NSString *readType;
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
@end
