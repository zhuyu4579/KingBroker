//
//  WZSharesCollectionView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSharesCollectionView : UICollectionView
//数据源
@property(nonatomic,strong)NSArray *urls;
//类型
@property(nonatomic,strong)NSString *type;
//回调
@property(nonatomic,strong)void(^selectBlock)(NSString *url);
@end
