//
//  WZNewsCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZNewItem.h"
#import "WZNewsCell.h"
#import <UIImageView+WebCache.h>
@implementation WZNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.04f;
    self.layer.shadowRadius = 20.0f;
    self.layer.cornerRadius = 15.0;
    self.layer.masksToBounds = NO;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    _title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _title.textColor = UIColorRBG(68, 68, 68);
    _contens.textColor = UIColorRBG(153, 153, 153);
    _nums.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
}
-(void)setItem:(WZNewItem *)item{
    _item = item;
    [_iconIamge sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"BBS"]];
    if (_array.count != 0) {
        for (NSDictionary *dic in _array) {
            NSString *type = item.type;
            NSString *value = [dic valueForKey:@"value"];
            if ([type isEqual:value]) {
                _title.text = [dic valueForKey:@"label"];
                break;
            }
        }
    }
    
    if ([item.title isEqual:@""]) {
        _contens.text = @"暂无消息";
    }else{
        _contens.text = item.title;
    }
    NSString *count = item.count;
    if(![count isEqual:@"0"]){
        [_nums setHidden:NO];
        [_nums setTitle:item.count forState:UIControlStateNormal];
    }else{
        [_nums setHidden:YES];
    }
    
}
@end
