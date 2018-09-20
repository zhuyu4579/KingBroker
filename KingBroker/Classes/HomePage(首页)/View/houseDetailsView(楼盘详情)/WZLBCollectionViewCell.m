//
//  WZLBCollectionViewCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZLBCollectionViewCell.h"
#import "WZHouseDetilItem.h"
#import <UIImageView+WebCache.h>
@implementation WZLBCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setItem:(WZLunBoItems *)item{
    _item = item;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zlp_pic"]];
    _ID = item.id;
    NSString *type = item.type;
    if ([type isEqual:@"1"]) {
        [_playBUtton setHidden:YES];
    }else{
         [_playBUtton setHidden:NO];
    }
}


@end
