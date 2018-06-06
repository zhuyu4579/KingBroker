//
//  NSString+LCExtension.m
//  QQMusic
//
//  Created by Liu-Mac on 5/1/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "NSString+LCExtension.h"
#import "WZLoginController.h"
#import "WZNavigationController.h"
@implementation NSString (LCExtension)

+ (instancetype)musicTimeFormater:(NSInteger)time {
    
    if (time <= 0) { return @"00:00"; }
    
    // 分钟
    NSInteger min = time / 60;
    // 秒
    NSInteger second = time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd", min, second];
}
+ (NSString *)getFilePathWithFileName:(NSString *)fileName
{
    //  path 想要返回的文件路径
    //    fileNmae 想要查找的文件名字，没有文件则创建文件，并返回文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:fileName];
    // 判断文件是否存在，文件不存在 使用 NSFileManager 创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO)
    {
        NSFileManager *fileManage = [NSFileManager defaultManager];
        [fileManage createFileAtPath:path contents:nil attributes:nil];
        NSMutableArray *arr = [NSMutableArray array];
        [arr writeToFile:path atomically:YES];
    }
    // 返回文件路径
    return path;
}
//判断code码
+(void)isCode:(id)target code:(NSString *)code{
    if ([code isEqual:@"401"]) {
        WZLoginController *login = [[WZLoginController alloc] init];
        WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:login];
        [target presentViewController:nav animated:YES completion:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *dic = [userDefaults dictionaryRepresentation];
        for (NSString *key in dic) {
            if (![key isEqual:@"oldName"]&&![key isEqual:@"appVersion"]) {
                [userDefaults removeObjectForKey:key];
            }
        }
        [userDefaults synchronize];
    }
}
@end
