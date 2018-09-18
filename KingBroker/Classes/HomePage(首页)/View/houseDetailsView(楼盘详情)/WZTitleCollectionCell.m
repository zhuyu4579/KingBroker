//
//  WZTitleCollectionCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTitleCollectionCell.h"
#import "WZHouseDetilItem.h"
@implementation WZTitleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _view.layer.cornerRadius = 9;
    _view.layer.masksToBounds = YES;
}
-(void)setItem:(WZHouseDetilItem *)item{
    _item = item;
    _title.text = item.title;
    _pcdNum = item.pcdNum;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _view.backgroundColor = [UIColor whiteColor];
}
@end
