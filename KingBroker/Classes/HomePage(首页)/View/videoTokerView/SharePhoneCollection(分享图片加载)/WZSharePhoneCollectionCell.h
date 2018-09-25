//
//  WZSharePhoneCollectionCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZTokerVItem;
@interface WZSharePhoneCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *phoneImage;
@property(nonatomic,strong)WZTokerVItem *item;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *portrait;
@end
