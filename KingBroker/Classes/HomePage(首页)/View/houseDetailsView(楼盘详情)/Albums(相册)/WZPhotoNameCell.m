//
//  WZPhotoNameCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPhotoNameCell.h"
#import "WZAlbumsItem.h"
@implementation WZPhotoNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _name.textColor = UIColorRBG(204, 204, 204);
    _name.layer.cornerRadius = 2;
    _name.layer.masksToBounds = YES;
}
-(void)setItem:(WZAlbumsItem *)item{
    _item = item;
    _name.text = [NSString stringWithFormat:@" %@(%@) ",item.picColectName,item.num];
    
}
-(void)setSelected:(BOOL)selected{
     [super setSelected:selected];
    if (selected) {
        _name.backgroundColor = UIColorRBG(255, 224, 0);
        _name.textColor = UIColorRBG(49, 35, 6);
    }else{
        _name.backgroundColor = [UIColor clearColor];
        _name.textColor = UIColorRBG(204, 204, 204);
    }
}

@end
