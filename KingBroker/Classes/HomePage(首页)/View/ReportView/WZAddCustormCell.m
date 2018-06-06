//
//  WZAddCustormCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAddCustormCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZCustomerItem.h"
@implementation WZAddCustormCell
-(void)setItem:(WZCustomerItem *)item{
    _item = item;
    _name.text = item.name;
    _telephone.text = item.missContacto;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.name.textColor = UIColorRBG(68, 68, 68);
    self.telephone.textColor = UIColorRBG(68, 68, 68);
    [_selectButton setEnlargeEdge:10];
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
#pragma mark -点击
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

@end
