//
//  WZOSSImageUploader.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZOSSImageUploader.h"
#import <AliyunOSSiOS/OSSService.h>
static NSString *const AccessKey = @"STS.NK45o4PVrDsvSLAU7HVCTU9oT";
static NSString *const SecretKey = @"phQxZA7EVFQPJGZXpra5wKdmnFJGhyEx8hViZWQSSYp";
static NSString *const BucketName = @"jingfuapp";
static NSString *const AliYunHost = @"https://oss-cn-hangzhou.aliyuncs.com";
static NSString *kTempFolder = @"upload/2018/12/17";

@implementation WZOSSImageUploader
+ (void)asyncUploadImage:(UIImage *)image data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete
{
    [self uploadImages:@[image] isAsync:YES data:data complete:complete];
}

+ (void)syncUploadImage:(UIImage *)image data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names,UploadImageState state))complete
{
    [self uploadImages:@[image] isAsync:NO data:data complete:complete];
}

+ (void)asyncUploadImages:(NSArray<UIImage *> *)images data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [self uploadImages:images isAsync:YES data:data complete:complete];
}

+ (void)syncUploadImages:(NSArray<UIImage *> *)images data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    [self uploadImages:images isAsync:NO data:data complete:complete];
}

+ (void)uploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync data:(NSDictionary *)data complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:[data valueForKey:@"accessKeyId"] secretKeyId:[data valueForKey:@"accessKeySecret"] securityToken:[data valueForKey:@"securityToken"]];
  
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    
    NSString *backetNames = [data valueForKey:@"bucketName"];
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
   
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                //put.bucketName = [data valueForKey:@"bucketName"];
                put.bucketName = backetNames;
                //文件路径及名称拼接
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                formatter1.dateFormat = @"yyyy";
                NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                formatter2.dateFormat = @"MM";
                NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
                formatter3.dateFormat = @"dd";
                NSString *name = [NSString stringWithFormat:@"upload/%@/%@/%@",[formatter1 stringFromDate:[NSDate date]],[formatter2 stringFromDate:[NSDate date]],[formatter3 stringFromDate:[NSDate date]]];
                
                 NSMutableString *randomString = [NSMutableString stringWithCapacity: 18];
                for (NSInteger i = 0; i < 18; i++) {
                    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
                }
                
                NSString *imageName = [NSString stringWithFormat:@"%@/%@.jpg",name,randomString];
                put.objectKey = imageName;
                put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                    NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
                };
                put.contentType = @"image/jpeg";
    
                //上传date
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                // 阻塞直到上传完成
                OSSTask * putTask = [client putObject:put];
                [putTask continueWithBlock:^id(OSSTask *task) {
                    task = [client presignPublicURLWithBucketName:backetNames withObjectKey:imageName];
                    if (!task.error) {
                        NSLog(@"upload object success!");
                        NSLog(@"%@",task.result);
                        //添加到数组回传
                        [callBackNames addObject:task.result];
                        if (isAsync) {
                            if (image == images.lastObject) {
                                NSLog(@"upload object finished!");
                                if (complete) {
                                    complete([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                                }
                            }
                        }
                    } else {
                        NSLog(@"upload object failed, error: %@" , task.error);
                        
                    }
                    return nil;
                }];
                [putTask waitUntilFinished];
                
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        NSLog(@"haha");
        if (complete) {
            if (complete) {
                complete([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
            }
        }
    }
}

@end
