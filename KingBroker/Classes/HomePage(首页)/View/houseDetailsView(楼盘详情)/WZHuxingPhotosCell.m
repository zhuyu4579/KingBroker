//
//  WZHuxingPhotosCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHuxingPhotosCell.h"
@interface WZHuxingPhotosCell(){
    CGFloat _lastScale;
}

@end
@implementation WZHuxingPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _photo.userInteractionEnabled = YES;//打开用户交互
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    [_photo addGestureRecognizer:pinch];
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    UIGestureRecognizerState state = [recognizer state];
    
    if(state == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        //获取最后的比例
        _lastScale = [recognizer scale];
    }
    
    if (state == UIGestureRecognizerStateBegan ||
        state == UIGestureRecognizerStateChanged) {
        //获取当前的比例
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        //设置最大最小的比例
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 1.0;
        //设置
        
        //获取上次比例减去想去得到的比例
        CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        [recognizer view].transform = transform;
        // Store the previous scale factor for the next pinch gesture call
        //获取最后比例 下次再用
        _lastScale = [recognizer scale];
    }
    
}
@end
