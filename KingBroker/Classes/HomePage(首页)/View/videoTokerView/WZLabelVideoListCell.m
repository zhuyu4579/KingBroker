//
//  WZLabelVideoListCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZTokerVItem.h"
#import <UIImageView+WebCache.h>
#import "WZLabelVideoListCell.h"

@implementation WZLabelVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    _title.textColor = UIColorRBG(102, 102, 102);
    self.backgroundColor = [UIColor whiteColor];
}
-(void)setItem:(WZTokerVItem *)item{
    _item = item;
    [_videoImage sd_setImageWithURL:[NSURL URLWithString:item.videoImg] placeholderImage:[UIImage imageNamed:@"lp_pic"]];
    _title.text = item.title;

    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"id"] = item.id;
    dicty[@"title"] = item.title;
    dicty[@"videoUrl"] = item.videoUrl;
    dicty[@"realname"] = item.realname;
    dicty[@"portrait"] = item.portrait;
    _dicty = dicty;
}
@end
