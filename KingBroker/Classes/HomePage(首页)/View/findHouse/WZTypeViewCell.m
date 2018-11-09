//
//  WZTypeViewCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTypeViewCell.h"
#import "WZTypeItem.h"
@implementation WZTypeViewCell

-(void)setItem:(WZTypeItem *)item{
    _item = item;
    _typeHouse.text = item.label;
    _value = item.value;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (selected) {
      _typeHouse.textColor = UIColorRBG(254, 193, 0);
    }else{
      _typeHouse.textColor = UIColorRBG(102, 102, 102);
    }
    
    
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
@end
