//
//  WZAnnouCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/31.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAnnouCell.h"
#import "WZAnnNewItem.h"
#import <UIImageView+WebCache.h>
@implementation WZAnnouCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.annTitleName.textColor = UIColorRBG(68, 68, 68);
    _content.textColor = UIColorRBG(102, 102, 102);
    _readFlag.backgroundColor = UIColorRBG(241, 48, 48);
    _readFlag.layer.cornerRadius = 3.5;
    _readFlag.layer.masksToBounds = YES;
//    _readFlag.layer.shadowColor = [UIColor grayColor].CGColor;
//    _readFlag.layer.shadowOpacity = 0.8f;
//    _readFlag.layer.shadowRadius = 3.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
-(void)setItem:(WZAnnNewItem *)item{
    _item = item;
    _annTitleName.text = item.title;
    _content.text = item.content;
    [_imageViews sd_setImageWithURL:[NSURL URLWithString:item.pictureIds] placeholderImage:[UIImage imageNamed:@"gg_pic"]];
    NSString *readType = item.readFlag;
    if ([readType isEqual:@"1"]) {
        [_readFlag setHidden:YES];
    }
    _viewType = item.viewType;
    _url = item.url;
    _ID = item.id;
}
@end
