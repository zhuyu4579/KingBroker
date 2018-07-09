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
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
#import "UIViewController+WZFindController.h"

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
   
    if ([realtorStatus isEqual:@"2"]) {
        [_JoinStoreButton setHidden:YES];
        [_JoinStoreButton setEnabled:NO];
        [_commissionImage setHidden:NO];
        [_houseCommission setHidden:NO];
        if([commissionFag isEqual:@"0"]){
            _houseCommission.text = item.commission;
        }else{
            _houseCommission.text = @"佣金不可见";
        }
    }else{
        [_JoinStoreButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
        [_JoinStoreButton setEnabled:YES];
    }
    //总价
    NSString *totalPrice = item.totalPrice;
    if (totalPrice && ![totalPrice isEqual:@""]) {
        _housePrice.text = [NSString stringWithFormat:@"总价：%@",totalPrice];
    }else{
        _housePrice.text = [NSString stringWithFormat:@"单价：%@",item.averagePrice];
    }
    
    NSString *collect = item.collect;
    if ([collect isEqual:@"0"]) {
        _houseCollectionButton.selected = NO;
    }else{
        _houseCollectionButton.selected = YES;
    }
    _cityName.text = item.cityName;
    _companyName.text = item.companyName;
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
    
    _houseItemName.textColor = UIColorRBG(68, 68, 68);
    _houseLabelOne.backgroundColor = UIColorRBG(230, 244, 255);
    _houseLabelOne.textColor = UIColorRBG(40, 180, 230);
    _houseLabelTwo.backgroundColor = UIColorRBG(230, 244, 255);
    _houseLabelTwo.textColor = UIColorRBG(40, 180, 230);
    _houseLabelThree.backgroundColor = UIColorRBG(230, 244, 255);
    _houseLabelThree.textColor = UIColorRBG(40, 180, 230);
    _houseCommission.textColor = UIColorRBG(244, 102, 30);
    [_JoinStoreButton setTitleColor:UIColorRBG(244, 102, 30) forState:UIControlStateNormal];
    [_commissionImage setHidden:YES];
    [_houseCommission setHidden:YES];
    _housePrice.textColor = UIColorRBG(255, 127, 19);
    _companyName.textColor = UIColorRBG(102, 102, 102);
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
        NSString *url = [NSString stringWithFormat:@"%@/proProject/collectProject",HTTPURL];
        but.enabled = NO;
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSString *collect = [data valueForKey:@"collect"];
                if ([collect isEqual:@"1"]) {
                    but.selected = YES;
                    [SVProgressHUD showInfoWithStatus:@"加入我的楼盘成功"];
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
- (IBAction)JoinStore:(UIButton *)sender {
    WZJionStoreController *JionStore = [[WZJionStoreController alloc] init];
    UIViewController *vc = [UIViewController viewController:self.superview.superview];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    JionStore.type = @"1";
    [vc presentViewController:nav animated:YES completion:nil];
}
@end
