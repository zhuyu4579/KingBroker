//
//  WZCollectHouseCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZCollectHouseCell.h"
#import "WZFindHouseListItem.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
@implementation WZCollectHouseCell
-(void)setItem:(WZFindHouseListItem *)item{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    _item = item;
    //设置ID
    _ID = item.id;
    _projectName.text = item.name;
    if([commissionFag isEqual:@"0"]){
        if ([realtorStatus isEqual:@"2"]) {
            _commsion.text = item.commission;
        }else{
            _commsion.text = @"加入门店可见佣金";
        }
    }else{
       _commsion.text = @"佣金不可见";
    }
    
    _cityName.text = item.cityName;
    //总价
    NSString *totalPrice = item.totalPrice;
    
    if (totalPrice && ![totalPrice isEqual:@""]) {
         _prices.text = [NSString stringWithFormat:@"总价：%@",totalPrice];
    }else{
         _prices.text = [NSString stringWithFormat:@"均价：%@",item.averagePrice];
    }
    
    [_projectIamge sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"sy_wntj_pic"]];
    if (item.tage.count!=0) {
        for (int i = 0; i<item.tage.count; i++) {
            if (i == 0) {
                _labelOne.text = item.tage[0];
            }else if(i==1){
                _labelTwo.text = item.tage[1];
            }else if(i==2){
                _labelThree.text = item.tage[2];
            }
        }
    }
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _projectName.textColor = UIColorRBG(68, 68, 68);
    _projectName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    _labelOne.backgroundColor = UIColorRBG(240, 246, 236);
    _labelOne.textColor = UIColorRBG(111, 182, 244);
    _labelTwo.backgroundColor = UIColorRBG(240, 246, 236);
    _labelTwo.textColor = UIColorRBG(111, 182, 244);
    _labelThree.backgroundColor = UIColorRBG(240, 246, 236);
    _labelThree.textColor = UIColorRBG(111, 182, 244);
     _commsion.textColor = UIColorRBG(244, 102, 30);
     _prices.textColor = UIColorRBG(255, 127, 19);
    _cityName.textColor = UIColorRBG(153, 153, 153);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
@end
