//
//  WZReportSuccessCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZLikeProjectItem;
@interface WZReportSuccessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet WZLikeProjectItem *item;
@property(nonatomic,strong)NSString *projectId;
@end
