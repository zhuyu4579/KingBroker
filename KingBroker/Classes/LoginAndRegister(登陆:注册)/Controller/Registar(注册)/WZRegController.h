//
//  WZRegController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZRegController : UIViewController
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
@property (weak, nonatomic) IBOutlet UIView *registarOne;
//逆传值给我的界面
@property (nonatomic,strong)void(^registarDataBlock)(NSDictionary *registarData);
@end
