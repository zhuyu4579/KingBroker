//
//  UIImageView+JMCyclePhotoViewExt.m
//  JMCyclePhotoView
//
//  Created by DJM on 2018/3/16.
//  Copyright © 2018年 DJM. All rights reserved.
//

#import <objc/runtime.h>
#import <CommonCrypto/CommonHMAC.h>
#import "UIImageView+JMCyclePhotoViewExt.h"

@interface UIImageView () <NSURLSessionDataDelegate>
/** session */
@property (nonatomic, strong) NSURLSession *session;
/** task */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/** image data */
@property (nonatomic, strong) NSMutableData *data;
/** name */
@property (nonatomic, copy) NSString *name;
/** sand box path */
@property (nonatomic, copy) NSString *path;

@end

@implementation UIImageView (JMCyclePhotoViewExt)

- (void)downImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholder {
    
    [self cancelDownload];
    
    if (placeholder) {
        self.image = placeholder;
    }
    
    if (!urlString || ![urlString hasPrefix:@"http"]) {
        return;
    }
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.name = [urlString MD5value];
        
        UIImage *image = [self loadDisk];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
            return;
        }
        
        NSURL *url = urlString.URLvalue;
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
        self.task = [self.session dataTaskWithRequest:request];
        [self.task resume];

    });
}


#pragma mark - NSURLSessionDelegate
// 服务器开始响应，准备返回数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    completionHandler(NSURLSessionResponseAllow);
    self.data = [NSMutableData data];
}

// 客户端接收数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data {
    
    [self.data appendData:data];
}

// 数据请求完成网络请求成功，当error不为空，说明响应出错
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (error) {
        NSLog(@"down image error = %@", error);
    } else {
        UIImage *image = [UIImage imageWithData:self.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
        [self saveDisk:image];
    }
}





#pragma mark - Method
// 从沙盒中取出图片
- (UIImage *)loadDisk {
    
    if (!self.name) return nil;
    
    NSString *path = [self.path stringByAppendingPathComponent:self.name];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data ? [UIImage imageWithData:data] : nil;
}

//保存图片到沙盒
- (void)saveDisk:(UIImage *)image {
    
    if (!self.name) return;
    
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    if (!data) return;
    
    NSString *path = [self.path stringByAppendingPathComponent:self.name];
    [data writeToFile:path atomically:YES];
}

// 取消下载
- (void)cancelDownload {
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}



#pragma mark - element
/** session */
- (void)setSession:(NSURLSession *)session {
    objc_setAssociatedObject(self, @selector(session), session, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURLSession *)session {
    NSURLSession *s = objc_getAssociatedObject(self, @selector(session));
    if (!s) s = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    return s;
}

/** task */
- (void)setTask:(NSURLSessionDataTask *)task {
    objc_setAssociatedObject(self, @selector(task), task, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSURLSessionDataTask *)task {
    return objc_getAssociatedObject(self, @selector(task));
}

/** image data */
- (void)setData:(NSMutableData *)data {
    objc_setAssociatedObject(self, @selector(dataWithBytes:length:), data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableData *)data {
    return objc_getAssociatedObject(self, @selector(data));
}

/** name */
- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)name {
    return objc_getAssociatedObject(self, @selector(name));
}

/** sand box path */
- (void)setPath:(NSString *)path {
    objc_setAssociatedObject(self, @selector(path), path, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)path {
    NSString *p = objc_getAssociatedObject(self, @selector(path));
    if (!p) {
        NSString *basePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"JMCyclePhotoViewExt"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:basePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        p = basePath;
    }
    return p;
}

@end





@implementation NSString (JMCyclePhotoViewExt)

- (NSString *)MD5value {
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSURL *)URLvalue {
    NSURL *url = [NSURL URLWithString:self];
    if (!url) {
        NSString *utf8String = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:utf8String];
    }
    return url;
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(NSInteger)length {
    NSMutableString *mutableString = @"".mutableCopy;
    for (NSInteger i = 0; i < length; i++) {
        [mutableString appendFormat:@"%02x", bytes[i]];
    }
    return mutableString.copy;
}

@end
