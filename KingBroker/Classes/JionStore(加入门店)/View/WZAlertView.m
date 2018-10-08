//
//  WZAlertView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAlertView.h"
#import "UIView+Frame.h"
#import "GKCover.h"
#import "UIViewController+WZFindController.h"
#import "WZNavigationController.h"
#import <SVProgressHUD.h>
@interface WZAlertView()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic,strong)UIViewController *Vc;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation WZAlertView

-(void)layoutSubviews{
    self.backgroundColor = [UIColor clearColor];
    //创建第一个view
    UIView *alertView = [[UIView alloc] init];
    alertView.frame = CGRectMake(10,0,SCREEN_WIDTH-20,252);
    alertView.backgroundColor =UIColorRBG(255, 255, 255);
    alertView.layer.cornerRadius = 8.0;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake((alertView.fWidth-260)/2.0,18,260,160);
    _imageView.image = [UIImage imageNamed:_imageName];
    [alertView addSubview:_imageView];
    //绘制线
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,193, alertView.fWidth, 2)];
    ineView.backgroundColor =[UIColor blackColor];
    ineView.alpha = 0.5;
    [alertView addSubview:ineView];
    //创建第二个view中的按钮
    _cancel = [[UIButton alloc] init];
    _cancel.frame = CGRectMake(10,260,SCREEN_WIDTH-20,57);
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    _cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancel setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_cancel setBackgroundColor:[UIColor whiteColor]];
    _cancel.layer.cornerRadius = 5.0;
    _cancel.layer.masksToBounds = YES;
    [_cancel addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancel];
    
    //创建第一个view中的按钮
    UIButton *confirm = [[UIButton alloc] init];
    confirm.frame = CGRectMake(0,195,SCREEN_WIDTH-20,57);
    [confirm setTitle:@"拍照" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirm setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
     [confirm setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
   
    [confirm addTarget:self action:@selector(confirmAlert) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:confirm];
    
}
#pragma mark -取消按钮
-(void)cancelAlert{
    [GKCover hide];

}
#pragma mark -拍照按钮
-(void)confirmAlert{
    [self openCamera];
}
#pragma mark -调用照相机
- (void)openCamera

{
   
    _picker = [[UIImagePickerController alloc] init];
    
    _picker.delegate = self;
    
    _picker.allowsEditing = NO; //可编辑
    
    //判断是否可以打开照相机
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        //摄像头
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _Vc = [UIViewController viewController:[self superview]];
      
        [_Vc presentViewController:_picker animated:YES completion:nil];
        
    }
    
    else
        
    {
        [SVProgressHUD showInfoWithStatus:@"没有摄像头"];
        
    }
    
}
#pragma mark -选择照片后执行
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
     [self cancelAlert];
    if (_imageBlock) {
         UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
         _imageBlock(image);
    }
}
#pragma mark -  图片处理
+(NSData *)imageProcessWithImage:(UIImage *)image {
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    NSData *imageData = [NSData data];
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            imageData=UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            imageData=UIImageJPEGRepresentation(image, 0.4);
        }else if (data.length>200*1024) {//0.25M-0.5M
            imageData=UIImageJPEGRepresentation(image, 0.6);
        }
    }
    return imageData;
}
//压缩图片质量
-(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
