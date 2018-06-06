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
@implementation WZDetailsViewOne

+(instancetype)detailViewTwo{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
-(void)layoutSubviews{
    self.itemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    self.itemName.textColor = UIColorRBG(68, 68, 68);
    _price.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _price.textColor =UIColorRBG(255, 127, 19);
    self.itemLabel.backgroundColor = UIColorRBG(240, 246, 236);
    self.itemLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.itemLabel.textColor = UIColorRBG(111, 182, 244);
    self.itemLabelTwo.backgroundColor = UIColorRBG(240, 246, 236);
    self.itemLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.itemLabelTwo.textColor = UIColorRBG(111, 182, 244);
    self.itemLabelThree.backgroundColor = UIColorRBG(240, 246, 236);
    self.itemLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.itemLabelThree.textColor = UIColorRBG(111, 182, 244);
    self.Commission.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    self.Commission.textColor = UIColorRBG(244, 102, 30);
    self.ineViewOne.backgroundColor = UIColorRBG(242, 242, 242);
    self.ineViewTwo.backgroundColor = UIColorRBG(242, 242, 242);
    self.ineViewThree.backgroundColor = UIColorRBG(242, 242, 242);
    self.ineViewFour.backgroundColor = UIColorRBG(242, 242, 242);
    self.addressTitle.textColor = UIColorRBG(153, 153, 153);
    self.phoneTitle.textColor = UIColorRBG(153, 153, 153);
    self.seeHouse.textColor = UIColorRBG(153, 153, 153);
    self.fareTitle.textColor = UIColorRBG(153, 153, 153);
    self.address.textColor = UIColorRBG(68, 68, 68);
    self.phone.textColor = UIColorRBG(68, 68, 68);
    self.seeHouseTime.textColor = UIColorRBG(68, 68, 68);
    self.isReimbursementfare.textColor = UIColorRBG(68, 68, 68);
    [self.playButton setEnlargeEdge:44];
}
- (IBAction)playPhone:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];

    NSString *phone = _phone.text;
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"号码为空"];
    }
}
@end
