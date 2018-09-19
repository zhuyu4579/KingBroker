//
//  WZMainUnitCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZMainUnitItem;
@interface WZMainUnitCell : UICollectionViewCell
//户型图
@property (weak, nonatomic) IBOutlet UIImageView *houseImage;
//类型
@property (weak, nonatomic) IBOutlet UILabel *mainUnitLabelOne;
//面积
@property (weak, nonatomic) IBOutlet UILabel *mainUnitLabelThree;
//价格
@property (weak, nonatomic) IBOutlet UILabel *mianUnitLabelFour;
@property (strong, nonatomic) IBOutlet UIView *views;
@property (strong, nonatomic) IBOutlet UIImageView *noItemImage;
- (IBAction)seePhotos:(UIButton *)sender;

//mode
@property(nonatomic,strong)WZMainUnitItem *item;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSString *title;
@end
