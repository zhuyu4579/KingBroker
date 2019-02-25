//
//  WZLoadDateSeviceOne.m
//  KingBroker
//
//  Created by 朱玉隆 on 2019/1/14.
//  Copyright © 2019年 朱玉隆. All rights reserved.
//

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZAlertView.h"
#import "WZLoadDateSeviceOne.h"

@implementation WZLoadDateSeviceOne
#pragma mark -请求数据
+(void)getUserInfosSuccess:(SuccessHandler)success andFail:(FailHandler)fail parament:(NSDictionary *)parament URL:(NSString *)url{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //防止返回值为null
    //((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *urls = [NSString stringWithFormat:@"%@%@",HTTPURL,url];
    [mgr GET:urls parameters:parament progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        fail(@"1001");
    }];
}
+(void)postUserInfosSuccess:(SuccessHandler)success andFail:(FailHandler)fail parament:(NSDictionary *)parament URL:(NSString *)url{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //防止返回值为null
    //((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
   NSString *urls = [NSString stringWithFormat:@"%@%@",HTTPURL,url];
    [mgr POST:urls parameters:parament progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        fail(@"1001");
    }];
}
+(void)postUpdatePhotoSuccess:(SuccessHandler)success andFail:(FailHandler)fail parament:(NSDictionary *)parament URL:(NSString *)url imageArray:(NSArray *)imageArray{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //防止返回值为null
    //((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *urls = [NSString stringWithFormat:@"%@%@",HTTPURL,url];
    
    [mgr POST:urls parameters:parament constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i<imageArray.count; i++) {
            NSData *imageData = [WZAlertView imageProcessWithImage:imageArray[i]];//进行图片压缩
            // 使用日期生成图片名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            // 任意的二进制数据MIMEType application/octet-stream
            [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        success(data);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        fail(@"1001");
    }];
    
}
@end
