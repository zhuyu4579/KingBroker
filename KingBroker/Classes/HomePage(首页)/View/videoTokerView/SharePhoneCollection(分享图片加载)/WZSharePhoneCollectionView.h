//
//  WZSharePhoneCollectionView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSharePhoneCollectionView : UICollectionView

@property(nonatomic,strong)NSArray *array;
//选择图片
@property(nonatomic,strong)void(^selectPhone)(NSDictionary *dicty);
@end
