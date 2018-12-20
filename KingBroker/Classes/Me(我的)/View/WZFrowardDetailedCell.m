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
    _title.textColor = UIColorRBG(51, 51, 51);
    _titleName.textColor = UIColorRBG(51, 51, 51);
    _time.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _time.textColor = UIColorRBG(153, 153, 153);
    _money.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:19];
    _money.textColor = UIColorRBG(255, 162, 0);
}
-(void)setItem:(WZFrowardItem *)item{
    _item = item;
    _titleName.text = item.name;
    _title.text = item.title;
    _time.text = item.createDate;
    _money.text = item.price;
    if ([item.price containsString:@"+"]) {
        _money.textColor = UIColorRBG(255, 162, 0);
    } else {
        _money.textColor = UIColorRBG(51, 51, 51);
    }
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
