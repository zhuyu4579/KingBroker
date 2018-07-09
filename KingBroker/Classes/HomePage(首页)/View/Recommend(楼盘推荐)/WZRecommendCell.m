//
//  WZRecommendCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZRecommendCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZFindHouseListItem.h"
#import "UIViewController+WZFindController.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "NSString+LCExtension.h"
#import "WZJionStoreController.h"
#import "WZNavigationController.h"
@implementation WZRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    self.backgroundColor = [UIColor clearColor];
    self.RecommendTitleOne.backgroundColor = UIColorRBG(230, 244, 255);
    self.RecommendTitleTwo.backgroundColor = UIColorRBG(230, 244, 255);
    self.RecommendThree.backgroundColor = UIColorRBG(230, 244, 255);
    self.RecommendTitleOne.textColor = UIColorRBG(40, 180, 230);
    self.RecommendTitleTwo.textColor = UIColorRBG(40, 180, 230);
    self.RecommendThree.textColor = UIColorRBG(40, 180, 230);
    _cityName.textColor = UIColorRBG(153, 153, 153);
    _prices.textColor = UIColorRBG(255, 127, 19);
    [_joinButton setTitleColor:UIColorRBG(244, 102, 30) forState:UIControlStateNormal];
    [_commissonImage setHidden:YES];
    [_Commission setHidden:YES];
     _companyName.textColor = UIColorRBG(102, 102, 102);
     [self.Collection setEnlargeEdge:44];
    _imageHeight.constant = 210*n;
}
-(void)setItem:(WZFindHouseListItem *)item{
    _item = item;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    NSString *commissionFag = [ user objectForKey:@"commissionFag"];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //设置ID
    _ID = item.id;
    _RecommendName.text = item.name;
    if (uuid) {
        if ([realtorStatus isEqual:@"2"]) {
            [_joinButton setHidden:YES];
            [_joinButton setEnabled:NO];
            [_commissonImage setHidden:NO];
            [_Commission setHidden:NO];
            if([commissionFag isEqual:@"0"]){
                 _Commission.text = item.commission;
            }else{
                _Commission.text = @"佣金不可见";
            }
        }else{
            [_joinButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
            [_joinButton setEnabled:YES];
        }
        
    }else{
        [_joinButton setTitle:@"登录可见佣金" forState:UIControlStateNormal];
        [_joinButton setEnabled:NO];
    }
   
    //总价
    NSString *totalPrice = item.totalPrice;
    if (totalPrice &&![totalPrice isEqual:@""]) {
        _prices.text = [NSString stringWithFormat:@"总价：%@",totalPrice];
    }else{
        _prices.text = [NSString stringWithFormat:@"均价：%@",item.averagePrice];
    }
    
    NSString *collect = item.collect;
    
    if ([collect isEqual:@"0"]) {
        _Collection.selected = NO;
    }else{
        _Collection.selected = YES;
    }
    _cityName.text = item.cityName;
    _companyName.text = item.companyName;
    [_RecommendImage sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"sy_wntj_pic"]];
    
    if (item.tage.count!=0) {
        for (int i = 0; i<item.tage.count; i++) {
            if (i == 0) {
                _RecommendTitleOne.text = item.tage[0];
            }else if(i == 1){
                _RecommendTitleTwo.text = item.tage[1];
            }else if(i == 2){
                _RecommendThree.text = item.tage[2];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
   
}
- (IBAction)collection:(UIButton *)sender {
        UIButton *but = sender;
        but.enabled = NO;
        //请求数据
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        UIViewController *Vc = [UIViewController viewController:self.superview.superview];
        if(!uuid){
            [NSString isCode:Vc.navigationController code:@"401"];
            but.enabled = YES;
            return;
        }
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 30;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
        NSString *url = [NSString stringWithFormat:@"%@/proProject/collectProject",HTTPURL];
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
                UILabel *label =  [but.superview viewWithTag:100];
                label.text = [NSString stringWithFormat:@"%@",collectNum];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:Vc.navigationController code:code];
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
  
