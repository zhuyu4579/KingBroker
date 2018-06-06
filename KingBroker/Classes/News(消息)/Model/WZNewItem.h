//
//  WZNewItem.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>
//图片image
//名称titleName
//内容标题title
//最新动态数目sum
@interface WZNewItem : NSObject

@property(nonatomic,strong)NSString *iconUrl;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *title;

@property(nonatomic,weak)NSString *count;

@end
