//
//  WZHuxingPhotosCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "UIView+Frame.h"
#import "WZHuxingPhotosCell.h"
@interface WZHuxingPhotosCell(){
    CGFloat _lastScale;
    float _lastTransX, _lastTransY;
}

@end
@implementation WZHuxingPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _photo.userInteractionEnabled = YES;//打开用户交互
    [_photo setMultipleTouchEnabled:YES];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    [_photo addGestureRecognizer:pinch];
    // 移动手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [panGestureRecognizer setMinimumNumberOfTouches:1];
//    [panGestureRecognizer setMaximumNumberOfTouches:1];
//    [_photo addGestureRecognizer:panGestureRecognizer];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [_photo addGestureRecognizer:tapGestureRecognizer];
}

//-(void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    CGPoint translatedPoint = [panGestureRecognizer translationInView:self];
//
//    if([panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
//        _lastTransX = 0.0;
//        _lastTransY = 0.0;
//    }
//
//    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
//    CGAffineTransform newTransform = CGAffineTransformConcat(_photo.transform, trans);
//    _lastTransX = translatedPoint.x;
//    _lastTransY = translatedPoint.y;
//    _photo.transform = newTransform;
//
//
//}
- (void)hideImageView:(UITapGestureRecognizer *)tap{
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        
    [tap view].transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
    
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    UIView *view = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    }
    
}
@end
