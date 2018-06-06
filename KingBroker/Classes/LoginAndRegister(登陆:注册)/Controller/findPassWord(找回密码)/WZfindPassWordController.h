//
//  WZfindPassWordController.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZfindPassWordController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *textFindPassWord;
- (IBAction)artificialService:(id)sender;
//判定是修改绑定手机号
@property(nonatomic,strong)NSString *modityID;

@end
