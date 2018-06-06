//
//  WZFindPWView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZFindPWView : UIView
@property (weak, nonatomic) IBOutlet UITextField *findPSText;
@property (weak, nonatomic) IBOutlet UITextField *findArgeementText;
@property (weak, nonatomic) IBOutlet UIButton *findYZMTextTow;
@property (weak, nonatomic) IBOutlet UIButton *findNextText;

+(instancetype)findPWView;
//判定是修改绑定手机号
@property(nonatomic,strong)NSString *modityId;

@end
