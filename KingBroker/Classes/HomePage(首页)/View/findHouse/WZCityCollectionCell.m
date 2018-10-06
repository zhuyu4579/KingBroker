//
//  WZCityCollectionCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZCityCollectionCell.h"
#import "WZCityItem.h"
@interface WZCityCollectionCell()

@end
@implementation WZCityCollectionCell
-(void)setItem:(WZCityItem *)item{
    _item = item;
    _cityButton.text = item.cityName;
    _cityId = item.cityId;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _cityButton.textColor = UIColorRBG(102, 102, 102);
    [_cityButton setBackgroundColor:UIColorRBG(242, 242, 242)];
    _cityButton.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _cityButton.layer.cornerRadius = 4;
    _cityButton.clipsToBounds = YES;
    _cityButton.userInteractionEnabled = NO;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _cityButton.textColor = UIColorRBG(49, 35, 6);
        _cityButton.backgroundColor = UIColorRBG(255, 216, 0);
    }else{
        _cityButton.textColor = UIColorRBG(102, 102, 102);
        [_cityButton setBackgroundColor:UIColorRBG(242, 242, 242)];
    }
    
}
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    
    CGRect frame = [self.cityButton.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.cityButton.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.cityButton.font,NSFontAttributeName, nil] context:nil];
    
    frame.size.height = 25;
    attributes.frame = frame;
    return attributes;
}
@end
