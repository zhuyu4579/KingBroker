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
#import "WZNewJionStoreController.h"
#import "WZNavigationController.h"
@implementation WZRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _view.layer.shadowColor = [UIColor blackColor].CGColor;
    //3.设置阴影颜色的透明度
    _view.layer.shadowOpacity = 0.05;
    //4.设置阴影半径
    _view.layer.shadowRadius = 15;
    
    _RecommendImage.layer.cornerRadius = 5.0;
    _RecommendImage.layer.masksToBounds = YES;
    
    _RecommendName.textColor = UIColorRBG(49, 35, 6);
    self.RecommendTitleOne.backgroundColor = UIColorRBG(255, 252, 238);
    self.RecommendTitleTwo.backgroundColor = UIColorRBG(255, 252, 238);
    self.RecommendThree.backgroundColor = UIColorRBG(255, 252, 238);
    self.RecommendTitleOne.textColor = UIColorRBG(255, 202, 118);
    self.RecommendTitleTwo.textColor = UIColorRBG(255, 202, 118);
    self.RecommendThree.textColor = UIColorRBG(255, 202, 118);
    
    _cityName.textColor = UIColorRBG(153, 153, 153);
    _prices.textColor = UIColorRBG(119, 119, 119);
    [_joinButton setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
    _Commission.textColor = UIColorRBG(255, 180, 61);
    [_Commission setHidden:YES];
     _companyName.textColor = UIColorRBG(153, 153, 153);
    
    
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
    if (![uuid isEqual:@""] && uuid) {
        if ([realtorStatus isEqual:@"2"]) {
            [_joinButton setHidden:YES];
            [_joinButton setEnabled:NO];
            [_Commission setHidden:NO];
            if([commissionFag isEqual:@"0"]){
                 _Commission.text = [NSString stringWithFormat:@"佣金：%@" ,item.commission];
            }else{
                _Commission.text = @"请咨询负责人";
            }
        }else{
            [_joinButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
            
            [_joinButton setEnabled:YES];
        }
        
    }else{
        [_joinButton setHidden:NO];
        [_Commission setHidden:YES];
        [_joinButton setTitle:@"登录可见佣金" forState:UIControlStateNormal];
        [_joinButton setEnabled:NO];
    }
   
    //总价
    NSString *totalPrice = item.totalPrice;
    if (totalPrice &&![totalPrice isEqual:@""]) {
        _prices.text = totalPrice;
    }else{
        _prices.text = item.averagePrice;
    }
    
    _cityName.text = item.cityName;
    _companyName.text = item.companyName;
    [_RecommendImage sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"sy_pic-1"]];
    
    _RecommendTitleOne.text = @"";
    _RecommendTitleTwo.text = @"";
    _RecommendThree.text = @"";
    
    if (item.tage.count!=0) {
        for (int i = 0; i<item.tage.count; i++) {
            if (i == 0) {
                _RecommendTitleOne.text = [NSString stringWithFormat:@" %@ " ,item.tage[0]];
            }else if(i == 1){
                _RecommendTitleTwo.text = [NSString stringWithFormat:@" %@ " ,item.tage[1]];
            }else if(i == 2){
                _RecommendThree.text = [NSString stringWithFormat:@" %@ " ,item.tage[2]];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
   
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=10;
    frame.origin.y +=10;
    [super setFrame:frame];
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    if ([realtorStatus isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
        return;
    }
    WZNewJionStoreController *JionStore = [[WZNewJionStoreController alloc] init];
    UIViewController *vc = [UIViewController viewController:self.superview.superview];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    JionStore.jionType = @"1";
    [vc presentViewController:nav animated:YES completion:nil];
}

@end
  
