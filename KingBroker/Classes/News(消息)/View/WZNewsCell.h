//
//  WZNewsCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZNewItem;
@interface WZNewsCell : UICollectionViewCell
@property(nonatomic,strong)WZNewItem *item;
@property(nonatomic,strong)NSArray *array;
@property (strong, nonatomic) IBOutlet UIImageView *iconIamge;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *contens;
@property (strong, nonatomic) IBOutlet UIButton *nums;

@end
