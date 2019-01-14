//
//  WZHuxingPhotosCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "UIView+Frame.h"
#import "WZHuxingPhotosCell.h"
#import "UIViewController+WZFindController.h"
@interface WZHuxingPhotosCell()<UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    
    CGSize _containerSize;
    BOOL _isZooming;
    BOOL _isDragging;
    BOOL _bodyIsInCenter;
    
    CGPoint _gestureInteractionStartPoint;
    BOOL _isGestureInteraction;
    
    
    UIInterfaceOrientation _statusBarOrientationBefore;
}
@property (nonatomic, assign) BOOL doubleTap;
@end
@implementation WZHuxingPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _doubleTap = NO;
    _mainContentView.delegate = self;
    _mainContentView.showsHorizontalScrollIndicator = NO;
    _mainContentView.showsVerticalScrollIndicator = NO;
    _mainContentView.decelerationRate = UIScrollViewDecelerationRateFast;
    _mainContentView.maximumZoomScale = 3;
    _mainContentView.minimumZoomScale = 1;
    _mainContentView.alwaysBounceHorizontal = NO;
    _mainContentView.alwaysBounceVertical = NO;
    _mainContentView.layer.masksToBounds = NO;
    if (@available(iOS 11.0, *)){ _mainContentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
     self.mainContentView.contentSize = CGSizeMake( self.photo.fWidth, self.photo.fHeight);
    _photo.userInteractionEnabled = YES;//打开用户交互
    [_photo setMultipleTouchEnabled:YES];
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [self.photo addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)hideImageView:(UITapGestureRecognizer *)tap{
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        
    [tap view].transform = CGAffineTransformIdentity;
    self.mainContentView.contentSize = CGSizeMake( self.photo.fWidth, self.photo.fHeight);
    } completion:^(BOOL finished) {
        
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
    
}

#pragma mark - <UIScrollViewDelegate>
//返回需要缩放的视图控件 缩放过程中
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photo;
}

//开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    //NSLog(@"开始缩放");
}
//结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    //NSLog(@"结束缩放");
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 延中心点缩放
    CGFloat imageScaleWidth = scrollView.zoomScale * self.photo.fWidth;
    CGFloat imageScaleHeight = scrollView.zoomScale * self.photo.fHeight;
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    //    if (imageScaleWidth < self.frame.size.width) {
    imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
    //    }
    //    if (imageScaleHeight < self.frame.size.height) {
    imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
    //    }
    self.photo.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
}


@end
