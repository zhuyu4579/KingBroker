//
//  WZNewViewCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZNewViewCell.h"
#import "WZNewItem.h"
#import <UIImageView+WebCache.h>
@implementation WZNewViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    _title.textColor = UIColorRBG(68, 68, 68);
    _newsTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _newsTitle.textColor = UIColorRBG(153, 153, 153);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
-(void)setItem:(WZNewItem *)item{
    _item = item;
    [_image sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:[UIImage imageNamed:@"BBS"]];
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
        _newsTitle.text = @"暂无消息";
    }else{
        _newsTitle.text = item.title;
    }
    NSString *count = item.count;
    if(![count isEqual:@"0"]){
         [_sumButton setHidden:NO];
         [_sumButton setTitle:item.count forState:UIControlStateNormal];
    }else{
        [_sumButton setHidden:YES];
    }
   
}
@end
