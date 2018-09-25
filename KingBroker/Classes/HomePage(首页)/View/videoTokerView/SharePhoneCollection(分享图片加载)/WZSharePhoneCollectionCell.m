//
//  WZSharePhoneCollectionCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZTokerVItem.h"
#import <UIImageView+WebCache.h>
#import "WZSharePhoneCollectionCell.h"

@implementation WZSharePhoneCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}
-(void)setItem:(WZTokerVItem *)item{
    _item = item;
    //转换图片地址
    [_phoneImage sd_setImageWithURL:[NSURL URLWithString:item.videoImg] placeholderImage:[UIImage imageNamed:@""]];
    _id = item.id;
    _title = item.title;
    _videoUrl = item.videoUrl;
    _realname = item.realname;
    _portrait = item.portrait;
}
@end
