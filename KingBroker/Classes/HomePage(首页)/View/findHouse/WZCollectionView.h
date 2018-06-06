//
//  WZCollectionView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZCollectionView : UICollectionView
//数据数组字典
@property(nonatomic,strong)NSArray *screenArray;
//选中的所有条件
@property(nonatomic,strong)void(^selectBlock)(NSMutableDictionary *dicty);
//清除选择
-(void)clean;
@end
