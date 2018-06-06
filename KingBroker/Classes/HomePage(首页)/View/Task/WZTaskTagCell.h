//
//  WZTaskTagCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZTaskTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *taskImage;
@property (weak, nonatomic) IBOutlet UILabel *taskDescribe;
@property (weak, nonatomic) IBOutlet UILabel *reward;
@property (weak, nonatomic) IBOutlet UIButton *answerTask;
- (IBAction)upTaskButton:(id)sender;

@end
