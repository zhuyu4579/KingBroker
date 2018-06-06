//
//  WZCityCollectionCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZCityItem;
@interface WZCityCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityButton;
//城市列表模型
@property(nonatomic,strong)WZCityItem *item;
//城市ID
@property(nonatomic,strong)NSString *cityId;
@end
