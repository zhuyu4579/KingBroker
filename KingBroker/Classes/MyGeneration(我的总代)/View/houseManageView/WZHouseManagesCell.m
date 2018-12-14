//
//  WZHouseManagesCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHouseManagesCell.h"

@implementation WZHouseManagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)previews:(UIButton *)sender {
}

- (IBAction)editHouse:(UIButton *)sender {
}

- (IBAction)groundHouse:(UIButton *)sender {
}
@end
