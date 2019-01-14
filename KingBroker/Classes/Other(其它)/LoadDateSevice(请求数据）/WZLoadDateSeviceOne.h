//
//  WZLoadDateSeviceOne.h
//  KingBroker
//
//  Created by 朱玉隆 on 2019/1/14.
//  Copyright © 2019年 朱玉隆. All rights reserved.
//  网络请求数据

#import <Foundation/Foundation.h>
//成功
typedef void(^SuccessHandler)(NSDictionary *dic);
//失败
typedef void(^FailHandler)(NSString *str);
NS_ASSUME_NONNULL_BEGIN

@interface WZLoadDateSeviceOne : NSObject
/**
 *  Service 用来做数据获取工作等，发起网络请求，并且返回数据，这个算是Model
 */
+(void)getUserInfosSuccess:(SuccessHandler)success andFail:(FailHandler) fail parament:(NSDictionary *)parament URL:(NSString *)url;
+(void)postUserInfosSuccess:(SuccessHandler)success andFail:(FailHandler) fail parament:(NSDictionary *)parament URL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
