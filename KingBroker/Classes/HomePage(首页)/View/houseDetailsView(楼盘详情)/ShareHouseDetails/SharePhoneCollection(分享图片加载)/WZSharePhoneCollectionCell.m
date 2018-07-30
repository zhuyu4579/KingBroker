//
//  WZSharePhoneCollectionCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSharePhoneCollectionCell.h"

@implementation WZSharePhoneCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = UIColorRBG(242, 242, 242).CGColor;
    self.layer.borderWidth = 1.0;
   
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _phoneImage.layer.borderWidth = 0;
    _phoneImage.layer.borderColor = [UIColor clearColor].CGColor;
}
@end
