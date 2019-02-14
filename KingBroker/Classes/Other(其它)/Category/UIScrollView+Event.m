//
//  UIScrollView+Event.m
//  KingBroker
//
//  Created by 朱玉隆 on 2019/1/23.
//  Copyright © 2019年 朱玉隆. All rights reserved.
//

#import "UIScrollView+Event.h"

@implementation UIScrollView (Event)
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [[[self nextResponder] nextResponder] touchesBegan:touches withEvent:event];
}
@end
