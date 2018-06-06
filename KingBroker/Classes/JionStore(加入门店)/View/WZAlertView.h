//
//  WZAlertView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZAlertView : UIView
@property(nonatomic,strong)UIButton *cancel;
//view中的事例图片
@property(nonatomic,strong)NSString *imageName;
//获取拍照的照片回传
@property(nonatomic,strong)void(^imageBlock)(UIImage *image);
+(NSData *)imageProcessWithImage:(UIImage *)image;
@end
