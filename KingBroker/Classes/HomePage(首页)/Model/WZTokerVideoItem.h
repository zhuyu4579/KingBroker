//
//  WZTokerVideoItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZTokerVideoItem : NSObject
//分类ID
@property(nonatomic,strong)NSString *id;
//分类名称
@property(nonatomic,strong)NSString *name;
//视频数组
@property(nonatomic,strong)NSArray *vclist;

@end
