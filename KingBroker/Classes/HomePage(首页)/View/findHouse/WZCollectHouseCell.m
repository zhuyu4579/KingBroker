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
#import "WZNewJionStoreController.h"
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
        
        [_commsion setHidden:NO];
        if([commissionFag isEqual:@"0"]){
            _commsion.text = [NSString stringWithFormat:@"佣金：%@" ,item.commission];
        }else{
            _commsion.text = @"请咨询负责人";
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
    
    [_projectIamge sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zw_icon2"]];
    if (item.tage.count!=0) {
        for (int i = 0; i<item.tage.count; i++) {
            if (i == 0) {
                _labelOne.text = [NSString stringWithFormat:@" %@ " ,item.tage[0]];
            }else if(i==1){
                _labelTwo.text = [NSString stringWithFormat:@" %@ " ,item.tage[1]];
            }else if(i==2){
                _labelThree.text = [NSString stringWithFormat:@" %@ " ,item.tage[2]];
            }
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    _projectName.textColor = UIColorRBG(51, 51, 51);
    _labelOne.backgroundColor = UIColorRBG(255, 252, 238);
    _labelOne.textColor = UIColorRBG(255, 202, 118);
    _labelTwo.backgroundColor = UIColorRBG(255, 252, 238);
    _labelTwo.textColor = UIColorRBG(255, 202, 118);
    _labelThree.backgroundColor = UIColorRBG(255, 252, 238);
    _labelThree.textColor = UIColorRBG(255, 202, 118);
    
     _commsion.textColor = UIColorRBG(254, 193, 0);
    [_JoinStoreButton setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
    
    [_commsion setHidden:YES];
     _prices.textColor = UIColorRBG(102, 102, 102);
    _cityName.textColor = UIColorRBG(102, 102, 102);
    _companyName.textColor = UIColorRBG(153,153,153);
    _distance.textColor = UIColorRBG(170, 170, 170);
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
            }else{
                but.selected = NO;
                if (_deleteblock) {
                    _deleteblock(self);
                }
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
    UIViewController *vc = [UIViewController viewController:self.superview.superview.superview.superview];
    WZNewJionStoreController *JionStore = [[WZNewJionStoreController alloc] init];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    JionStore.jionType = @"1";
    [vc presentViewController:nav animated:YES completion:nil];
}
@end
