//
//  WZOSSImageUploader.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};
NS_ASSUME_NONNULL_BEGIN

@interface WZOSSImageUploader : NSObject
+ (void)asyncUploadImage:(UIImage *)image data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;

+ (void)syncUploadImage:(UIImage *)image data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete;

+ (void)asyncUploadImages:(NSArray<UIImage *> *)images data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

+ (void)syncUploadImages:(NSArray<UIImage *> *)images data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

@end

NS_ASSUME_NONNULL_END
