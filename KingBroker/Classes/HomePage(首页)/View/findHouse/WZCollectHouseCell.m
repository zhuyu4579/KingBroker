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
#import "UIButton+WZEnlargeTouchAre.h"
#import "UIViewController+WZFindController.h"
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
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
    
    _distance.text = item.distance;
    
    if ([realtorStatus isEqual:@"2"]) {
        [_JoinStoreButton setHidden:YES];
        [_JoinStoreButton setEnabled:NO];
        [_commissionImage setHidden:NO];
        [_commsion setHidden:NO];
        if([commissionFag isEqual:@"0"]){
            _commsion.text = item.commission;
        }else{
            _commsion.text = @"";
        }
    }else{
        [_JoinStoreButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
        [_JoinStoreButton setEnabled:YES];
    }
    
    _cityName.text = item.cityName;
    _companyName.text = item.companyName;
    //总价
    NSString *totalPrice = item.totalPrice;
    
    if (totalPrice && ![totalPrice isEqual:@""]) {
        _prices.text = totalPrice;
    }else{
        _prices.text = item.averagePrice;
    }
    
    NSString *collect = item.collect;
    if ([collect isEqual:@"0"]) {
        _houseCollectionButton.selected = NO;
    }else{
        _houseCollectionButton.selected = YES;
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
 
    _labelOne.backgroundColor = UIColorRBG(230, 244, 255);
    _labelOne.textColor = UIColorRBG(40, 180, 230);
    _labelTwo.backgroundColor = UIColorRBG(230, 244, 255);
    _labelTwo.textColor = UIColorRBG(40, 180, 230);
    _labelThree.backgroundColor = UIColorRBG(230, 244, 255);
    _labelThree.textColor = UIColorRBG(40, 180, 230);
     _commsion.textColor = UIColorRBG(244, 102, 30);
    [_JoinStoreButton setTitleColor:UIColorRBG(244, 102, 30) forState:UIControlStateNormal];
    [_commissionImage setHidden:YES];
    [_commsion setHidden:YES];
     _prices.textColor = UIColorRBG(255, 127, 19);
    _cityName.textColor = UIColorRBG(153, 153, 153);
    _companyName.textColor = UIColorRBG(102, 102, 102);
    _distance.textColor = UIColorRBG(203, 203, 203);
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
                if (_deleteblock) {
                    _deleteblock(self);
                }
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
