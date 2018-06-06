//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by zhuyulong on 16/8/22.
//  Copyright © 2016年 zhuyulong. All rights reserved.
//

#import "CollectionViewHeaderView.h"
#import "WZScreenItem.h"
@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *ine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        ine.backgroundColor = UIColorRBG(242, 242, 242);
        [self addSubview:ine];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, frame.size.width, 14)];
        self.title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        self.title.textColor = UIColorRBG(102, 102, 102);
        self.title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.title];
    }
    return self;
}
-(void)setItem:(WZScreenItem *)item{
    _item = item;
    _title.text = item.name;
    _dics = item.dicts;
    _code = item.code;
}
@end
