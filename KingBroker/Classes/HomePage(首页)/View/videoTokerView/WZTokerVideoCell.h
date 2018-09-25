//
//  WZTokerVideoCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZTokerVideoItem;
@interface WZTokerVideoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *videoView;
- (IBAction)findMore:(UIButton *)sender;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *vclist;
@property(nonatomic,strong)WZTokerVideoItem *item;
@property(nonatomic,strong)NSDictionary *dicty;
@end
