//
//  WZTitleCollectionViewCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "UIView+Frame.h"
#import "WZAlbumsItem.h"
#import "WZTitleCollectionViewCell.h"

@implementation WZTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.fHeight/2.0-13, self.fWidth , 13)];
        _title.textColor = UIColorRBG(119, 119, 119);
        _title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.title];
        
        _ineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.fHeight-2, self.fWidth, 2)];
        _ineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_ineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _ineView.backgroundColor = UIColorRBG(255, 224, 0);
        _title.textColor = UIColorRBG(255, 224, 0);
    }else{
        _ineView.backgroundColor = [UIColor whiteColor];
        _title.textColor = UIColorRBG(119, 119, 119);
    }
    
}
-(void)setItem:(WZAlbumsItem *)item{
    _item = item;
    _title.text = item.picColectName;
    
}
@end
