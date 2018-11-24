//
//  WZReportSuccessCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZReportSuccessCell.h"
#import <UIImageView+WebCache.h>
#import "WZLikeProjectItem.h"
@implementation WZReportSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowColor = UIColorRBG(0, 0, 0).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.08f;
    self.layer.shadowRadius = 5.0f;
    self.layer.shouldRasterize = YES;
    self.layer.cornerRadius = 7.0;
    self.layer.masksToBounds = NO;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _image.layer.cornerRadius = 7.0;
    _image.layer.masksToBounds = YES;
    [_houseTypeImage setHidden:YES];
    _cityName.textColor = UIColorRBG(153, 153, 153);
    _commission.textColor = UIColorRBG(255, 180, 61);
    _commissionLabel.backgroundColor = UIColorRBG(255, 216, 0);
    _commissionLabel.textColor = [UIColor whiteColor];
}
#pragma mark -点击cell做事情
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //点击状态的取消
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=15;
    frame.origin.y +=15;
    frame.size.width -=20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
-(void)setItem:(WZLikeProjectItem *)item{
    _item = item;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    
    NSString *url = item.url;
    NSString *houseType = item.selfEmployed;
    _selfEmployed = houseType;
    if ([houseType isEqual:@"2"]) {
        [_houseTypeImage setHidden:NO];
    }else{
         [_houseTypeImage setHidden:YES];
    }
    [_image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bb_5_pic"]];
    _labelOne.text = item.name;
    _projectId = item.id;
   
    _cityName.text = item.cityName;
    if([commissionFag isEqual:@"0"]){
        _commission.text = item.commission;
    }else{
        _commission.text = @"请咨询负责人";
    }
    
}
@end
