//
//  WZDetailsViewOne.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZDetailsViewOne.h"
#import <SVProgressHUD.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZNewJionStoreController.h"
#import "WZNavigationController.h"
#import "WZHDMapController.h"
#import "UIViewController+WZFindController.h"
@implementation WZDetailsViewOne

+(instancetype)detailViewTwo{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
-(void)layoutSubviews{
    
    self.itemName.textColor = UIColorRBG(68, 68, 68);
    _price.textColor =UIColorRBG(153, 153, 153);
    
    self.itemLabel.backgroundColor = UIColorRBG(255, 252, 238);
    self.itemLabel.textColor = UIColorRBG(255, 202, 118);
    self.itemLabelTwo.backgroundColor = UIColorRBG(255, 252, 238);
    self.itemLabelTwo.textColor = UIColorRBG(255, 202, 118);
    self.itemLabelThree.backgroundColor = UIColorRBG(255, 252, 238);
    self.itemLabelThree.textColor = UIColorRBG(255, 202, 118);
    
    self.Commission.textColor = UIColorRBG(255, 180, 61);
    [self.JoinButton setTitleColor:UIColorRBG(255, 180, 61) forState:UIControlStateNormal];
 
    self.address.textColor = UIColorRBG(68, 68, 68);
    self.companyName.textColor = UIColorRBG(68, 68, 68);
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
