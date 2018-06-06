//
//  UIImageView+JMCyclePhotoViewExt.h
//  JMCyclePhotoView
//
//  Created by DJM on 2018/3/16.
//  Copyright © 2018年 DJM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JMCyclePhotoViewExt)

- (void)downImageWithUrlString:(NSString *)urlString placeholder:(UIImage *)placeholder;

@end

@interface NSString (JMCyclePhotoViewExt)

- (NSString *)MD5value;

- (NSURL *)URLvalue;

@end
