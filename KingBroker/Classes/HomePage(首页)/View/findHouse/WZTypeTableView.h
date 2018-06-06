//
//  WZTypeTableView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZTypeTableView : UITableView
//数据模型
@property (nonatomic,strong)NSArray *array;
//传递点选值
@property(nonatomic,strong)void(^typeBlock)(NSMutableDictionary *typeDic);
@end
