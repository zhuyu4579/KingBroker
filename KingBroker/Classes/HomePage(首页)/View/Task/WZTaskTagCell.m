//
//  WZTaskTagCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTaskTagCell.h"

@implementation WZTaskTagCell



-(void)setFrame:(CGRect)frame{
    frame.size.height -=3;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.answerTask setTitleColor:[UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.answerTask.layer.cornerRadius = 5.0;
    self.answerTask.layer.masksToBounds = YES;
    [self.answerTask.layer setBorderWidth:1.0];
    self.answerTask.layer.borderColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)upTaskButton:(id)sender {
}
@end
