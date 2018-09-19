//
//  WZMainUnitCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZMainUnitCell.h"
#import "WZMainUnitItem.h"
#import <UIImageView+WebCache.h>
#import "UIViewController+WZFindController.h"
#import "WZHuxingPhotosController.h"
@implementation WZMainUnitCell
//参数赋值
-(void)setItem:(WZMainUnitItem *)item{
    [_noItemImage setHidden:YES];
    _array = item.pictures;
    if (_array.count <= 1) {
        [_views setHidden:YES];
    }else{
        [_views setHidden:NO];
    }
    [_houseImage sd_setImageWithURL:[NSURL URLWithString:item.pictures[0]] placeholderImage:[UIImage imageNamed:@"lp_pic"]];
    NSInteger room = [item.room integerValue];
    NSInteger living = [item.living integerValue];
    NSInteger toilet = [item.toilet integerValue];
    NSString *str = [NSString stringWithFormat:@"%ld室%ld厅%ld卫",(long)room,(long)living,(long)toilet];
    _mainUnitLabelOne.text = str;
    if (item.area) {
         _mainUnitLabelThree.text = [NSString stringWithFormat:@"%@平",item.area];
    }
    if (item.price) {
        _mianUnitLabelFour.text = [NSString stringWithFormat:@"%@万元",item.price];
    }
    _title = [NSString stringWithFormat:@"%@ %@ %@平",item.name,str,item.area];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _mainUnitLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _mainUnitLabelOne.textColor = UIColorRBG(68, 68, 68);
    _mainUnitLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _mainUnitLabelThree.textColor = UIColorRBG(153, 153, 153);
    _mianUnitLabelFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _mianUnitLabelFour.textColor = UIColorRBG(255, 105, 114);
    _views.layer.cornerRadius = 9;
    _views.layer.masksToBounds = YES;
}

- (IBAction)seePhotos:(UIButton *)sender {
    if (_array.count == 0) {
        return;
    }
    WZHuxingPhotosController *photos = [[WZHuxingPhotosController alloc] init];
    photos.item = _array;
    photos.titles = _title;
    UIViewController *vc = [UIViewController viewController:self.superview];
    [vc.navigationController pushViewController:photos animated:YES];
}
@end
