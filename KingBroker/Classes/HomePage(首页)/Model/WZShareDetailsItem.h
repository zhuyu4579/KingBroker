//
//  WZShareDetailsItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZShareDetailsItem : NSObject
//悬赏ID
@property(nonatomic,strong)NSString *projectTaskId;
//标题(图片，视频返回值)
@property(nonatomic,strong)NSString *title;
//url(图片，视频返回值)
@property(nonatomic,strong)NSArray *attachmentIds;
//楼盘名称（楼盘返回值）
@property(nonatomic,strong)NSString *name;
//图片url（楼盘返回值）
@property(nonatomic,strong)NSString *url;
//楼盘介绍（楼盘返回值）
@property(nonatomic,strong)NSString *outlining;
//类型
@property(nonatomic,strong)NSString *type;
//分享标题
@property(nonatomic,strong)NSString *shareName;
//分享楼盘url
@property(nonatomic,strong)NSString *shareUrl;
@end
