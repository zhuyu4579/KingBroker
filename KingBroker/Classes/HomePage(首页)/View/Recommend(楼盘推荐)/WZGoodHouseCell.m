//
//  WZGoodHouseCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import "WZGoodHouseCell.h"
#import "WZGoodHouseItem.h"
@implementation WZGoodHouseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10.0;
}
-(void)setItem:(WZGoodHouseItem *)item{
    //转换图片地址
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureIds] placeholderImage:[UIImage imageNamed:@"sy_pic-1"]];
    _name.text = item.labelName;
    _ID = item.id;
}
@end
