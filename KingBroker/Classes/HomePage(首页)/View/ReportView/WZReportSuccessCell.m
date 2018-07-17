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
    self.layer.borderColor =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0].CGColor;
    self.layer.borderWidth = 1;
    _labelTwo.textColor = UIColorRBG(40, 180, 230);
    _labelThree.textColor = UIColorRBG(40, 180, 230);
    _labelFour.textColor = UIColorRBG(40, 180, 230);
    _labelTwo.backgroundColor = UIColorRBG(230, 244, 255);
    _labelThree.backgroundColor = UIColorRBG(230, 244, 255);
    _labelFour.backgroundColor = UIColorRBG(230, 244, 255);
    _cityName.textColor = UIColorRBG(153, 153, 153);
    _companyName.textColor = UIColorRBG(102, 102, 102);
    _commission.textColor = UIColorRBG(244, 102, 30);
}
#pragma mark -点击cell做事情
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //点击状态的取消
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=10;
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
    NSArray *array = item.tags;
    if (array.count != 0) {
        _labelTwo.text = array[0];
        if (array.count >1) {
            _labelThree.text = array[1];
        }else if(array.count>2){
            _labelFour.text = array[2];
        }
    }
    _cityName.text = item.cityName;
    if([commissionFag isEqual:@"0"]){
        _commission.text = item.commission;
    }else{
        _commission.text = @"佣金不可见";
    }
    
    _companyName.text = item.companyName;
}
@end
