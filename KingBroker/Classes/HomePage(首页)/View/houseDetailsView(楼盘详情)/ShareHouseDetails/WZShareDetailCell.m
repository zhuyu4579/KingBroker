//
//  WZShareDetailCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZShareDetailCell.h"
#import "WZShareDetailsItem.h"
#import <UIImageView+WebCache.h>
@implementation WZShareDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _shareDetailTitle.textColor = UIColorRBG(68, 68, 68);
    _shareDetailContent.textColor = UIColorRBG(102, 102, 102);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
-(void)setItem:(WZShareDetailsItem *)item{
    _item = item;
    [_detailImageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"gg_pic"]];
    _shareDetailTitle.text = item.name;
    _shareDetailContent.text = item.outlining;
}

@end
