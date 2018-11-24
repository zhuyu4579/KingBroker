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
@property (strong, nonatomic) IBOutlet UIImageView *houseTypeImage;

@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *commission;
@property (strong, nonatomic) IBOutlet UILabel *commissionLabel;


@property (strong, nonatomic) WZLikeProjectItem *item;
@property(nonatomic,strong)NSString *projectId;
@end
