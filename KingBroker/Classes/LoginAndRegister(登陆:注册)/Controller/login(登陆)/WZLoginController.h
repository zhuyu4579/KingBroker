//
//  WZLoginController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/16.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  登陆页面

#import <UIKit/UIKit.h>

@interface WZLoginController : UIViewController
- (IBAction)closeLogin:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *millerLogin;
//给数据传给我的页面
@property (strong, nonatomic)void(^loginBlock)(NSDictionary *loginItem);

@end
