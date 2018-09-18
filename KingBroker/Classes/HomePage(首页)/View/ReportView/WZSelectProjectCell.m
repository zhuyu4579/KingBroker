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
    _signStatus.textColor = UIColorRBG(255, 180, 61);
    _signStatus.backgroundColor = UIColorRBG(255, 247, 205);
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
    if ([type isEqual:@"2"]) {
        [_signStatus setHidden:NO];
    }else {
        [_signStatus setHidden:YES];
    }
}
@end
