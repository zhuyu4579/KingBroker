//
//  WZAlbumsItem.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZAlbumsItem : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *picColectName;

@property (nonatomic, copy) NSArray *picCollect;

@end
@interface WZAlbumContensItem : NSObject

@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSString *id;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *title;

@end
