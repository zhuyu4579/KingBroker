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
    _views.layer.shadowColor = [UIColor grayColor].CGColor;
    _views.layer.shadowOpacity = 0.8f;
    _views.layer.shadowRadius = 4.0f;
    [_seeButton setEnlargeEdgeWithTop:20 right:15 bottom:20 left:100];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(WZAnnNewItem *)item{
    _item = item;
    _time.text = item.releaseDateStr;
    NSString *readFlag = item.readFlag;
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
        [_imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"xx_2、3_pic"]];
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
