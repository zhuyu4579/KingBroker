//
//  WZTokerLabelCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTokerLabelCell.h"
#import "WZTokerTitleItem.h"
@implementation WZTokerLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _title.layer.borderColor = UIColorRBG(255, 239, 131).CGColor;
    _title.layer.borderWidth = 1.0;
    _title.layer.cornerRadius = 2.0;
}
-(void)setItem:(WZTokerTitleItem *)item{
    _item = item;
    _name = item.name;
    _title.text = [NSString stringWithFormat:@" %@  ",_name];
}

@end
