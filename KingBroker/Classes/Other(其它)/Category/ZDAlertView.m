//
//  ZDAlertView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAlertView.h"
#import "UIView+Frame.h"
#import "GKCover.h"
#import "UIViewController+WZFindController.h"
#import "WZPhonesController.h"
#import <SVProgressHUD.h>
@interface ZDAlertView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end
@implementation ZDAlertView
//创建view
-(void)layoutSubviews{
    //创建第一个UIButton
    UIButton *buttons = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.fWidth, 50)];
    buttons.backgroundColor = [UIColor whiteColor];
    [buttons setTitle:@"预览" forState:UIControlStateNormal];
    _buttons = buttons;
    [buttons setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    buttons.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttons addTarget:self action:@selector(seePhone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttons];
    
    UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 51, self.fWidth, 50)];
    buttonOne.backgroundColor = [UIColor whiteColor];
    [buttonOne setTitle:@"拍照" forState:UIControlStateNormal];
    _cancel = buttonOne;
    [buttonOne setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttonOne addTarget:self action:@selector(confirmAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonOne];
    //创建第二个UIButton
    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(0, 102, self.fWidth, 50)];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    _phone = buttonTwo;
    [buttonTwo setTitle:@"手机相册选择" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttonTwo addTarget:self action:@selector(selectPhone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonTwo];
    //创建第二个UIButton
    UIButton *buttonThree = [[UIButton alloc] initWithFrame:CGRectMake(0, 162, self.fWidth, 50)];
    buttonThree.backgroundColor = [UIColor whiteColor];
    [buttonThree setTitle:@"取消" forState:UIControlStateNormal];
    [buttonThree setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    buttonThree.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttonThree addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonThree];
    
}
//预览图片
-(void)seePhone{
    WZPhonesController *phone = [[WZPhonesController alloc] init];
    phone.url = _url;
     _Vc = [UIViewController viewController:[self superview]];
    [_Vc.navigationController pushViewController:phone animated:YES];
}

//拍照
-(void)confirmAlert{
    _picker = [[UIImagePickerController alloc] init];
    _picker.view.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    
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
        [SVProgressHUD showInfoWithStatus:@"没有找到摄像头"];
        
    }
}
#pragma mark -选择照片后执行
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self cancelAlert];
    if (_imageBlock) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        _imageBlock(image);
    }
}
//用于上传图片到服务器
#pragma mark -  图片处理
+(NSData *)imageProcessWithImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
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
//手机相册选择
-(void)selectPhone{
    _picker = [[UIImagePickerController alloc] init];
    _picker.view.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _Vc = [UIViewController viewController:[self superview]];
    [_Vc presentViewController:_picker animated:YES completion:nil];
}
//取消
-(void)cancelAlert{
    [GKCover hide];
}
@end
