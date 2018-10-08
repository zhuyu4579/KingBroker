//
//  WZTaskCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTaskCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZAnnNewItem.h"
#import <UIImageView+WebCache.h>
@implementation WZTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _time.textColor = UIColorRBG(153, 153, 153);
    _reads.backgroundColor = UIColorRBG(241, 48, 48);
    _reads.layer.cornerRadius = 3.5;
    _title.textColor = UIColorRBG(68, 68, 68);
    _content.textColor = UIColorRBG(153, 153, 153);
    _views.backgroundColor = [UIColor whiteColor];
    _views.layer.shadowColor = [UIColor blackColor].CGColor;
    _views.layer.shadowOpacity = 0.05f;
    _views.layer.shadowRadius = 15.0f;
    _views.layer.cornerRadius = 3.0;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(WZAnnNewItem *)item{
    _item = item;
    _time.text = item.releaseDateStr;
    NSString *readFlag = item.readFlag;
    _readType = readFlag;
    if ([readFlag isEqual:@"0"]) {
        [_reads setHidden:NO];
    }else{
        [_reads setHidden:YES];
    }
    _title.text = item.title;
    _content.text = item.content;
    _ID = item.id;
    _param = item.param;
    _additional = item.additional;
    _viewType = item.viewType;
    NSString *url = item.pictureIds;
    
    if (![url isEqual:@""]) {
        [_imageViews setHidden:NO];
        [_imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zw_icon4"]];
        _titleIne.constant = 122;
        _contentIne.constant = 122;
    }else{
        [_imageViews setHidden:YES];
        _titleIne.constant = 18;
        _contentIne.constant = 18;
    }
    _url = item.url;
}
@end
