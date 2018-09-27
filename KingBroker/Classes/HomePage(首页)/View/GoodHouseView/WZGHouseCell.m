//
//  WZGHouseCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZGHouseCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZFindHouseListItem.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZNewJionStoreController.h"
#import "WZNavigationController.h"
#import "UIViewController+WZFindController.h"

@implementation WZGHouseCell

-(void)setItem:(WZFindHouseListItem *)item{
    _item = item;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    //设置ID
    _ID = item.id;
    _houseItemName.text = item.name;
    
    if ([realtorStatus isEqual:@"2"]) {
        [_commissionButton setEnabled:NO];
        if([commissionFag isEqual:@"0"]){
            [_commissionButton setTitle:[NSString stringWithFormat:@" 佣金：%@ " ,item.commission] forState:UIControlStateNormal];
        }else{
             [_commissionButton setTitle:@" 佣金结给门店 " forState:UIControlStateNormal];
        }
    }else{
        [_commissionButton setTitle:@" 加入门店可见佣金 " forState:UIControlStateNormal];
        [_commissionButton setEnabled:YES];
    }
    //总价
    NSString *totalPrice = item.totalPrice;
    if (totalPrice && ![totalPrice isEqual:@""]) {
        _housePrice.text = totalPrice;
    }else{
        _housePrice.text = item.averagePrice;
    }
    
    NSString *collect = item.collect;
    if ([collect isEqual:@"0"]) {
        _houseCollectionButton.selected = NO;
    }else{
        _houseCollectionButton.selected = YES;
    }
    _cityName.text = item.cityName;
    _companyName.text = item.companyName;
    [_houseImage sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"lp_pic"]];
    _houseLabelOne.text = @"";
    _houseLabelTwo.text = @"";
    _houseLabelThree.text = @"";
    if (item.tage.count != 0) {
        _houseLabelOne.text = [NSString stringWithFormat:@" %@ " ,item.tage[0]];
        if(item.tage.count > 1){
            _houseLabelTwo.text = [NSString stringWithFormat:@" %@ " ,item.tage[1]];
        }else if(item.tage.count > 2){
            _houseLabelThree.text = [NSString stringWithFormat:@" %@ " ,item.tage[2]];
        }
        
        
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
    _houseImage.layer.cornerRadius = 5.0;
    _houseImage.layer.masksToBounds = YES;
    _collenView.layer.cornerRadius = 25.0;
    _houseItemName.textColor = UIColorRBG(51, 51, 51);
    _houseLabelOne.backgroundColor = UIColorRBG(255, 252, 238);
    _houseLabelOne.textColor = UIColorRBG(255, 202, 118);
    _houseLabelTwo.backgroundColor = UIColorRBG(255, 252, 238);
    _houseLabelTwo.textColor = UIColorRBG(255, 202, 118);
    _houseLabelThree.backgroundColor = UIColorRBG(255, 252, 238);
    _houseLabelThree.textColor = UIColorRBG(255, 202, 118);
    
    [_commissionButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    _commissionButton.layer.cornerRadius = 5.0;
    _commissionButton.layer.borderColor = UIColorRBG(102, 102, 102).CGColor;
    _commissionButton.layer.borderWidth = 1.0;
    
    _housePrice.textColor = UIColorRBG(153, 153, 153);
    _companyName.textColor = UIColorRBG(153, 153, 153);
    _cityName.textColor = UIColorRBG(153, 153, 153);
    [_houseCollectionButton setEnlargeEdge:40];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=8;
    frame.origin.y +=8;
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
    UIViewController *vc = [UIViewController viewController:self.superview.superview];
    WZNewJionStoreController *JionStore = [[WZNewJionStoreController alloc] init];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    JionStore.jionType = @"1";
    [vc presentViewController:nav animated:YES completion:nil];
}

@end
