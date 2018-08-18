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
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    
    _labelTwo.textColor = UIColorRBG(255, 202, 118);
    _labelThree.textColor = UIColorRBG(255, 202, 118);
    _labelFour.textColor = UIColorRBG(255, 202, 118);
    
    _labelTwo.backgroundColor = UIColorRBG(255, 249, 220);
    _labelThree.backgroundColor = UIColorRBG(255, 249, 220);
    _labelFour.backgroundColor = UIColorRBG(255, 249, 220);
    
    _cityName.textColor = UIColorRBG(153, 153, 153);
    _companyName.textColor = UIColorRBG(102, 102, 102);
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
    
    [super setFrame:frame];
}
-(void)setItem:(WZLikeProjectItem *)item{
    _item = item;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    
    NSString *url = item.url;
    
    [_image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bb_5_pic"]];
    _labelOne.text = item.name;
    _projectId = item.id;
    _labelTwo.text = @"";
    _labelThree.text = @"";
    _labelFour.text = @"";
    NSArray *array = item.tags;
    if (array.count != 0) {
        _labelTwo.text =[NSString stringWithFormat:@" %@ ", array[0]];
        if (array.count >1) {
            _labelThree.text = [NSString stringWithFormat:@" %@ ", array[1]];
        }else if(array.count>2){
            _labelFour.text =[NSString stringWithFormat:@" %@ ", array[2]];
        }
    }
    _cityName.text = item.cityName;
    if([commissionFag isEqual:@"0"]){
        _commission.text = item.commission;
    }else{
        _commission.text = @"";
    }
    _companyName.text = item.companyName;
}
@end
