//
//  WZHouseManagesCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZHouseManageItem;
NS_ASSUME_NONNULL_BEGIN

@interface WZHouseManagesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *houseImageView;
@property (strong, nonatomic) IBOutlet UILabel *houseName;
@property (strong, nonatomic) IBOutlet UILabel *prices;
@property (strong, nonatomic) IBOutlet UILabel *stutas;
@property (strong, nonatomic) IBOutlet UILabel *commission;
@property (strong, nonatomic) IBOutlet UIButton *previewButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *groundingButton;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)WZHouseManageItem *item;

- (IBAction)previews:(UIButton *)sender;
- (IBAction)editHouse:(UIButton *)sender;
- (IBAction)groundHouse:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
