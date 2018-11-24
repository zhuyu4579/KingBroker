//
//  WZSelectProjectCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSelectProjectCell.h"
#import "WZSelcetProjectItem.h"
@implementation WZSelectProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _signStatus.textColor = UIColorRBG(255, 255, 255);
    _signStatus.backgroundColor = UIColorRBG(178, 193, 255);
    _signStatus.layer.cornerRadius = 3.0;
    _signStatus.layer.masksToBounds = YES;
    _companyName.textColor = UIColorRBG(153, 153, 153);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
-(void)setItem:(WZSelcetProjectItem *)item{
    _item = item;
    _projectId = item.projectId;
    _projectName.text = item.projectName;
    _companyName.text = item.companyName;
    NSString *type = item.signStatus;
    NSString *houseType = item.selfEmployed;
    if ([houseType isEqual:@"2"]) {
        [_signStatus setHidden:NO];
        _signStatus.text = @" 喜喜直推 ";
        _signStatus.backgroundColor = UIColorRBG(255, 217, 114);
    }else{
        if ([type isEqual:@"2"]) {
            [_signStatus setHidden:NO];
            _signStatus.text = @" 已签约 ";
            _signStatus.backgroundColor = UIColorRBG(178, 193, 255);
        }else {
            [_signStatus setHidden:YES];
        }
    }
    
}
@end
