//
//  WZFindHouseCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/3.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "WZFindHouseCell.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZFindHouseListItem.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZNewJionStoreController.h"
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
    if(item.name.length>11){
        [_houseItemName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(174);
        }];
    }
    
    if ([realtorStatus isEqual:@"2"]) {
        [_JoinStoreButton setHidden:YES];
        [_JoinStoreButton setEnabled:NO];
        
        [_houseCommission setHidden:NO];
        if([commissionFag isEqual:@"0"]){
            _houseCommission.text = [NSString stringWithFormat:@"佣：%@" ,item.commission];
        }else{
            _houseCommission.text = @"请咨询负责人";
        }
    }else{
        [_JoinStoreButton setTitle:@"加入门店可见佣金" forState:UIControlStateNormal];
        [_JoinStoreButton setEnabled:YES];
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
    _cityName.text = item.areaName;
    _companyName.text = item.companyName;
    NSString *houseType = item.selfEmployed;
    _selfEmployed = houseType;
    if ([houseType isEqual:@"1"]) {
        [_xxztView setHidden:YES];
        [_companyView setHidden:NO];
    }else if([houseType isEqual:@"2"]){
        [_xxztView setHidden:NO];
        [_companyView setHidden:YES];
    }
    [_houseImage sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zw_icon2"]];
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
    NSString *runTag = item.runTag;
    if (![runTag isEqual:@""]&&runTag) {
        [_labelTag setHidden:NO];
        _labelTag.text = [runTag substringToIndex:1];
    }else{
        [_labelTag setHidden:YES];
    }
    _isTasking = item.isTasking;
    if ([_isTasking isEqual:@"1"]) {
        [_taskButton setHidden:NO];
        [_taskButton setEnabled:YES];
    }else{
        [_taskButton setHidden:YES];
        [_taskButton setEnabled:NO];
    }
    _houseTypeOnes.text = @"";
    _houseTypeTwos.text = @"";
    _houseTypeLabelOne.text = @"";
    _houseTypeLabelTwo.text = @"";
    if (item.typeList.count >0) {
        _houseTypeOnes.text = [NSString stringWithFormat:@" %@ ",item.typeList[0]];
        _houseTypeLabelOne.text = [NSString stringWithFormat:@" %@ ",item.typeList[0]];
        if (item.typeList.count>1) {
            _houseTypeTwos.text = [NSString stringWithFormat:@" %@ ",item.typeList[0]];
            _houseTypeLabelTwo.text = [NSString stringWithFormat:@" %@ ",item.typeList[0]];
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    _houseImage.layer.cornerRadius = 2.0;
    _houseImage.layer.masksToBounds = YES;
    _houseItemName.textColor = UIColorRBG(51, 51, 51);
    _houseLabelOne.backgroundColor = UIColorRBG(255, 252, 238);
    _houseLabelOne.textColor = UIColorRBG(255, 202, 118);
    _houseLabelTwo.backgroundColor = UIColorRBG(255, 252, 238);
    _houseLabelTwo.textColor = UIColorRBG(255, 202, 118);
    _houseLabelThree.backgroundColor = UIColorRBG(255, 252, 238);
    _houseLabelThree.textColor = UIColorRBG(255, 202, 118);
    
    _labelTag.backgroundColor = UIColorRBG(135, 148, 227);
    _labelTag.layer.cornerRadius = 2.0;
    _labelTag.layer.masksToBounds = YES;
    
    _houseCommission.textColor = UIColorRBG(250, 87, 65);
    [_JoinStoreButton setTitleColor:UIColorRBG(254, 193, 0) forState:UIControlStateNormal];
    [_houseCommission setHidden:YES];
    
    _housePrice.textColor = UIColorRBG(102, 102, 102);
    _companyName.textColor = UIColorRBG(153, 153, 153);
    _cityName.textColor = UIColorRBG(102, 102, 102);
    [_houseCollectionButton setEnlargeEdge:40];
    
    _houseTypeLabelOne.textColor = UIColorRBG(109, 122, 128);
    _houseTypeLabelOne.layer.borderWidth = 1.0;
    _houseTypeLabelOne.layer.borderColor = UIColorRBG(109, 122, 128).CGColor;
    _houseTypeLabelTwo.textColor = UIColorRBG(109, 122, 128);
    _houseTypeLabelTwo.layer.borderWidth = 1.0;
    _houseTypeLabelTwo.layer.borderColor = UIColorRBG(109, 122, 128).CGColor;
    _houseTypeOnes.textColor = UIColorRBG(109, 122, 128);
    _houseTypeOnes.layer.borderWidth = 1.0;
    _houseTypeOnes.layer.borderColor = UIColorRBG(109, 122, 128).CGColor;
    _houseTypeTwos.textColor = UIColorRBG(109, 122, 128);
    _houseTypeTwos.layer.borderWidth = 1.0;
    _houseTypeTwos.layer.borderColor = UIColorRBG(109, 122, 128).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
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
                    [SVProgressHUD showInfoWithStatus:@"收藏楼盘成功"];
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

- (IBAction)taskButtons:(UIButton *)sender {
}
- (IBAction)JoinStore:(UIButton *)sender {
    UIViewController *vc = [UIViewController viewController:self.superview.superview.superview.superview.superview];
    WZNewJionStoreController *JionStore = [[WZNewJionStoreController alloc] init];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    JionStore.jionType = @"1";
    [vc presentViewController:nav animated:YES completion:nil];
}
@end
