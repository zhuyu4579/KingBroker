//
//  WZSharesCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSharesCell.h"

@implementation WZSharesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.layer.borderColor = UIColorRBG(0, 160, 233).CGColor;
    self.layer.borderWidth = 0;
}
@end
