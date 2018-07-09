//
//  WZFrowardDetailedCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZFrowardItem.h"
#import "WZFrowardDetailedCell.h"

@implementation WZFrowardDetailedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    _titleName.textColor = UIColorRBG(33, 33, 33);
    _time.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _time.textColor = UIColorRBG(153, 153, 153);
    _money.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:19];
    _money.textColor = UIColorRBG(3, 133, 219);
}
-(void)setItem:(WZFrowardItem *)item{
    _item = item;
    _titleName.text = item.name;
    _time.text = item.createDate;
    _money.text = item.price;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
@end
