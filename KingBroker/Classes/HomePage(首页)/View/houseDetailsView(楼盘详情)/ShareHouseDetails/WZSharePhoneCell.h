//
//  WZSharePhoneCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZShareDetailsItem;
@interface WZSharePhoneCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIImageView *taskImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videoHeight;
@property(nonatomic,strong)WZShareDetailsItem *item;
@property(nonatomic,strong)NSString *projectTaskId;
//选择的图片
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *type;
@end
