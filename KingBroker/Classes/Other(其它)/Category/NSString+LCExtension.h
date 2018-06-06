//
//  NSString+LCExtension.h
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LCExtension)

+ (instancetype)musicTimeFormater:(NSInteger)time;
+ (NSString *)getFilePathWithFileName:(NSString *)fileName;
//判断状态码返回登录
+(void)isCode:(id)target code:(NSString *)code;
@end
