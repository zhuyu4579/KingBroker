//
//  WZDetailsViewTwo.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/11/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZDetailsViewTwo.h"
#import <SVProgressHUD.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"
#import "WZNavigationController.h"
#import "WZHDMapController.h"
#import "UIViewController+WZFindController.h"
@implementation WZDetailsViewTwo
+(instancetype)detailViewTwo{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
-(void)layoutSubviews{
    
    self.itemName.textColor = UIColorRBG(68, 68, 68);
    _price.textColor =UIColorRBG(153, 153, 153);
    
    _runTageOne.backgroundColor = UIColorRBG(218, 240, 255);
    _runTageOne.textColor = UIColorRBG(155, 214, 255);
    _runTageTwo.backgroundColor = UIColorRBG(218, 240, 255);
    _runTageTwo.textColor = UIColorRBG(155, 214, 255);
    self.itemLabel.backgroundColor = UIColorRBG(255, 252, 238);
    self.itemLabel.textColor = UIColorRBG(255, 202, 118);
    self.itemLabelTwo.backgroundColor = UIColorRBG(255, 252, 238);
    self.itemLabelTwo.textColor = UIColorRBG(255, 202, 118);
    self.itemLabelThree.backgroundColor = UIColorRBG(255, 252, 238);
    self.itemLabelThree.textColor = UIColorRBG(255, 202, 118);
    _houseSum.textColor = UIColorRBG(153, 153, 153);
    self.Commission.textColor = UIColorRBG(255, 180, 61);
    [self.JoinButton setTitleColor:UIColorRBG(255, 180, 61) forState:UIControlStateNormal];
    
    self.address.textColor = UIColorRBG(68, 68, 68);
    self.houseTypeLabel.layer.cornerRadius = 9;
    self.houseTypeLabel.layer.masksToBounds = YES;
    self.developerName.textColor = UIColorRBG(68, 68, 68);
}
- (IBAction)addressButton:(UIButton *)sender {
    WZHDMapController *map = [[WZHDMapController alloc] init];
    map.navigationItem.title = _projectName;
    map.lnglat = _lnglat;
    map.address = _addr;
    UIViewController *vc = [UIViewController viewController:self.superview];
    [vc.navigationController pushViewController:map animated:YES];
}

- (IBAction)JoinStore:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    if ([realtorStatus isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
        return;
    }
    WZNewJionStoreController *JionStore = [[WZNewJionStoreController alloc] init];
    UIViewController *vc = [UIViewController viewController:self.superview];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    JionStore.jionType = @"1";
    [vc presentViewController:nav animated:YES completion:nil];
}
@end
