//
//  WZFindHouseCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/3.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZFindHouseCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZFindHouseListItem.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
@implementation WZFindHouseCell
-(void)setItem:(WZFindHouseListItem *)item{
    _item = item;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    //设置ID
    _ID = item.id;
    _houseItemName.text = item.name;
    _distance.text = item.distance;
    if([commissionFag isEqual:@"0"]){
        if ([realtorStatus isEqual:@"2"]) {
            _houseCommission.text = item.commission;
        }else{
            _houseCommission.text = @"加入门店可见佣金";
        }
    }else{
        _houseCommission.text = @"佣金不可见";
    }
    //总价
    NSString *totalPrice = item.totalPrice;
    if (totalPrice && ![totalPrice isEqual:@""]) {
        _housePriceLabel.text = @"总价：";
        _housePrice.text = [NSString stringWithFormat:@"%@",totalPrice];
    }else{
        _housePriceLabel.text = @"均价：";
        _housePrice.text = [NSString stringWithFormat:@"%@",item.averagePrice];
    }
    
    NSString *collect = item.collect;
    if ([collect isEqual:@"0"]) {
        _houseCollectionButton.selected = NO;
    }else{
        _houseCollectionButton.selected = YES;
    }
    _cityName.text = item.cityName;
    _houseCollectionSum.text = [NSString stringWithFormat:@"%@",item.collectNum];
    [_houseImage sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zlp_pic"]];
    _houseLabelOne.text = @"";
    _houseLabelTwo.text = @"";
    _houseLabelThree.text = @"";
    if (item.tage.count != 0) {
        _houseLabelOne.text = item.tage[0];
        if(item.tage.count > 1){
            _houseLabelTwo.text = item.tage[1];
        }else if(item.tage.count > 2){
            _houseLabelThree.text = item.tage[2];
        }
        
        
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _houseItemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    _houseItemName.textColor = UIColorRBG(68, 68, 68);
    _houseLabelOne.backgroundColor = UIColorRBG(240, 246, 236);
    _houseLabelOne.textColor = UIColorRBG(111, 182, 244);
    _houseLabelTwo.backgroundColor = UIColorRBG(240, 246, 236);
    _houseLabelTwo.textColor = UIColorRBG(111, 182, 244);
    _houseLabelThree.backgroundColor = UIColorRBG(240, 246, 236);
    _houseLabelThree.textColor = UIColorRBG(111, 182, 244);
    _houseCommission.textColor = UIColorRBG(244, 102, 30);
    _housePriceLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _housePriceLabel.textColor = UIColorRBG(255, 127, 19);
    _housePrice.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _housePrice.textColor = UIColorRBG(255, 127, 19);
    _houseCollectionSum.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _houseCollectionSum.textColor = UIColorRBG(153, 153, 153);
    _distance.textColor = UIColorRBG(203, 203, 203);
    _cityName.textColor = UIColorRBG(153, 153, 153);
    [_houseCollectionButton setEnlargeEdge:40];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
- (IBAction)houseCollectionClick:(id)sender {
    UIButton *but = sender;
    //请求数据
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 30;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
        NSString *url = [NSString stringWithFormat:@"%@/proProject/collectProject",URL];
        but.enabled = NO;
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSString *collect = [data valueForKey:@"collect"];
                if ([collect isEqual:@"1"]) {
                    but.selected = YES;
                    [SVProgressHUD showInfoWithStatus:@"加入我的项目成功"];
                }else{
                    but.selected = NO;
                }
                NSString *collectNum = [data valueForKey:@"collectNum"];
                UILabel *label =  [but.superview viewWithTag:40];
                label.text = [NSString stringWithFormat:@"%@",collectNum];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            }
             but.enabled = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
             but.enabled = YES;
        }];
    
    
}
@end
