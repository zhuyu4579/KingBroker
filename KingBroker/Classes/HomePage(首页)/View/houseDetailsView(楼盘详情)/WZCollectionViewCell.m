//
//  WZCollectionViewCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import "WZCollectionViewCell.h"
#import "UIView+Frame.h"
#import "WZAlbumsItem.h"
@interface WZCollectionViewCell ()

@end

@implementation WZCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.fWidth , self.fHeight)];
        _imageV.layer.cornerRadius = 3.0;
        _imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageV];
        
        _buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.fWidth/2.0-15, self.fHeight/2.0-15, 30, 30)];
        _buttonImage.image = [UIImage imageNamed:@"xc_button"];
        [self.contentView addSubview:_buttonImage];
    }
    return self;
}
-(void)setItem:(WZAlbumContensItem *)item{
    _item = item;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zlp_pic"]];
    _ID = item.id;
    NSString *type = item.type;
    if ([type isEqual:@"1"]) {
        [_buttonImage setHidden:YES];
    }else{
        [_buttonImage setHidden:NO];
    }
}

@end
