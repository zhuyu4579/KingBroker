//
//  WZNewViewCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZNewViewCell.h"
#import "WZAnnNewItem.h"
#import <UIImageView+WebCache.h>
@implementation WZNewViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _newsTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _newsTitle.textColor = UIColorRBG(68, 68, 68);
    _title.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    _title.textColor = UIColorRBG(153, 153, 153);
    _view.layer.shadowColor = [UIColor blackColor].CGColor;
    _view.layer.shadowOpacity = 0.05f;
    _view.layer.shadowRadius = 15.0f;
    _view.layer.cornerRadius = 3.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setItem:(WZAnnNewItem *)item{
    _item = item;
    _item = item;
    _time.text = item.releaseDateStr;
    NSString *readFlag = item.readFlag;
    if ([readFlag isEqual:@"0"]) {
        [_sumButton setHidden:NO];
    }else{
        [_sumButton setHidden:YES];
    }
    _newsTitle.text = item.title;
    _title.text = item.content;
    _ID = item.id;
    _param = item.param;
    _additional = item.additional;
    _viewType = item.viewType;
     _url = item.url;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:item.pictureIds] placeholderImage:[UIImage imageNamed:@"gg_pic"]];
    
}
@end
