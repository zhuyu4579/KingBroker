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
    _content.textColor = UIColorRBG(153, 153, 153);
    _time.textColor = UIColorRBG(153, 153, 153);
    _readFlag.backgroundColor = UIColorRBG(241, 48, 48);
    _readFlag.layer.cornerRadius = 3.5;
    _readFlag.layer.masksToBounds = YES;
    _view.backgroundColor = [UIColor whiteColor];
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
    _annTitleName.text = item.title;
    _content.text = item.content;
    [_imageViews sd_setImageWithURL:[NSURL URLWithString:item.pictureIds] placeholderImage:[UIImage imageNamed:@"gg_pic"]];
    NSString *readType = item.readFlag;
    if ([readType isEqual:@"1"]) {
        [_readFlag setHidden:YES];
    }else{
         [_readFlag setHidden:NO];
    }
    _time.text = item.releaseDateStr;
    _viewType = item.viewType;
    _url = item.url;
    _ID = item.id;
}
@end
