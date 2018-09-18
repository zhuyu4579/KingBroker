//
//  WZQuestionController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZQuestionController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *QTitle;
@property (weak, nonatomic) IBOutlet UILabel *LabelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (strong, nonatomic) IBOutlet UIButton *buttonFour;
@property (strong, nonatomic) IBOutlet UIButton *buttonFive;
@property (strong, nonatomic) IBOutlet UIButton *buttonSix;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
- (IBAction)actionButton:(UIButton *)sender;



@end
