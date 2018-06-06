//
//  WZScreenItem.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZScreenItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSArray *dicts;


@end
@interface SubCategoryModel : NSObject

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, assign) BOOL flag;

@end
