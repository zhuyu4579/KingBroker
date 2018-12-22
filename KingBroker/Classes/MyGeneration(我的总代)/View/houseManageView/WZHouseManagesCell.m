//
//  WZHouseManagesCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "WZHouseManageItem.h"
#import "WZHouseManagesCell.h"
#import "NSString+LCExtension.h"
#import "WZEditHouseController.h"
#import "WZNavigationController.h"
#import "WZPreviewHouseController.h"
#import "WZGroundSuccessController.h"
#import "UIViewController+WZFindController.h"
@implementation WZHouseManagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _previewButton.layer.cornerRadius = 12.0;
    _previewButton.layer.masksToBounds = YES;
    _previewButton.layer.borderColor = UIColorRBG(251, 221, 49).CGColor;
    _previewButton.layer.borderWidth = 1.0;
    _editButton.layer.cornerRadius = 12.0;
    _editButton.layer.masksToBounds = YES;
    _editButton.layer.borderColor = UIColorRBG(251, 221, 49).CGColor;
    _editButton.layer.borderWidth = 1.0;
    _groundingButton.layer.cornerRadius = 12.0;
    _groundingButton.layer.masksToBounds = YES;
    _groundingButton.layer.borderColor = UIColorRBG(251, 221, 49).CGColor;
    _groundingButton.layer.borderWidth = 1.0;
}
-(void)setItem:(WZHouseManageItem *)item{
    _item = item;
    [_houseImageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zw_icon2"]];
    _houseName.text = item.name;
    if ([item.averagePrice isEqual:@""]) {
        _prices.text = item.totalPrice;
    }else{
         _prices.text = item.averagePrice;
    }
    [_editButton setEnabled:YES];
    [_editButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _editButton.layer.borderColor = UIColorRBG(251, 221, 49).CGColor;
    [_groundingButton setEnabled:YES];
    [_groundingButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _groundingButton.layer.borderColor = UIColorRBG(251, 221, 49).CGColor;
    
    NSString *stuta = item.status;
    if ([stuta isEqual:@"0"]||[stuta isEqual:@"3"]) {
        _stutas.text = @"未上架";
    }else if ([stuta isEqual:@"1"]) {
        _stutas.text = @"上架审核中";
        [_editButton setEnabled:NO];
        [_editButton setTitleColor:UIColorRBG(204, 204, 204) forState:UIControlStateNormal];
        _editButton.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
        [_groundingButton setEnabled:NO];
        [_groundingButton setTitleColor:UIColorRBG(204, 204, 204) forState:UIControlStateNormal];
        _groundingButton.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
    }else if ([stuta isEqual:@"2"]) {
        _stutas.text = @"已上架";
        [_editButton setEnabled:NO];
        [_editButton setTitleColor:UIColorRBG(204, 204, 204) forState:UIControlStateNormal];
        _editButton.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
        [_groundingButton setTitle:@"下架" forState:UIControlStateNormal];
    }
    _commission.text = item.commission;
    _ID = item.id;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)previews:(UIButton *)sender {
    UIViewController *vc = [UIViewController viewController:self.superview];
    WZPreviewHouseController *houseThree = [[WZPreviewHouseController alloc] init];
    houseThree.ID = _ID;
    [vc.navigationController pushViewController:houseThree animated:YES];
}

- (IBAction)editHouse:(UIButton *)sender {
    UIViewController *vc = [UIViewController viewController:self.superview];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    
    NSString *url = [NSString stringWithFormat:@"%@/proProject/userCompanyProjectInfo",HTTPURL];
    NSLog(@"%@",paraments);
    
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            WZEditHouseController *editHouse = [[WZEditHouseController alloc] init];
            editHouse.data = data;
            [vc.navigationController pushViewController:editHouse animated:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                
                [NSString isCode:vc.navigationController code:code];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
   
   
}

- (IBAction)groundHouse:(UIButton *)sender {
    NSString *test = sender.titleLabel.text;
     UIViewController *vc = [UIViewController viewController:self.superview];
    if ([test isEqual:@"申请上架"]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
      
        NSString *url = [NSString stringWithFormat:@"%@/proProject/uprojectputawayApply",HTTPURL];
        NSLog(@"%@",paraments);
        
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                WZGroundSuccessController *addHouseThree = [[WZGroundSuccessController alloc] init];
                WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:addHouseThree];
                [vc.navigationController presentViewController:nav animated:YES completion:nil];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                if ([code isEqual:@"401"]) {
                    
                    [NSString isCode:vc.navigationController code:code];
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }];
    }else if([test isEqual:@"下架"]){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确认楼盘下架" message:@"你确认要下架铂金公馆楼盘吗？下架后，楼盘信息将不在经喜APP展示"  preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确认下架" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *uuid = [ user objectForKey:@"uuid"];
            
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            
            mgr.requestSerializer.timeoutInterval = 20;
            //防止返回值为null
            ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
            mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
            [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
            //2.拼接参数
            NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
            paraments[@"id"] = _ID;
            
            NSString *url = [NSString stringWithFormat:@"%@/proProject/uprojectDownApply",HTTPURL];
            NSLog(@"%@",paraments);
            
            [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqual:@"200"]) {
                    
                }else{
                    NSString *msg = [responseObject valueForKey:@"msg"];
                    if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                        [SVProgressHUD showInfoWithStatus:msg];
                    }
                    if ([code isEqual:@"401"]) {
                        
                        [NSString isCode:vc.navigationController code:code];
                    }
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }];
                                                              }];
        UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"暂不下架" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                       
                                                               }];
        [cancelAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
        [defaultAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [vc presentViewController:alert animated:YES completion:nil];
        
        
    }
}
@end
