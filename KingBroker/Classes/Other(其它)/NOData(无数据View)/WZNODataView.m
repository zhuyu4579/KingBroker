//
//  WZNODataView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2019/1/14.
//  Copyright © 2019年 朱玉隆. All rights reserved.
//

#import "WZNODataView.h"
#import <Masonry.h>
@interface WZNODataView()
//图片
@property(nonatomic,strong)UIImageView *imageViews;
//标题
@property(nonatomic,strong)UILabel *titleLabel;
//照片数据
@property(nonatomic,strong)NSString *imageName;
//标题数据
@property(nonatomic,strong)NSString *titleName;
@end
@implementation WZNODataView
#pragma mark -init
-(instancetype)initNoDataView:(CGRect)rect imageName:(NSString *)imageName titleName:(NSString *)titleName{
    
    self = [super init];
    if (self) {
        self.frame = rect;
    }
    _imageName = imageName;
    _titleName = titleName;
    [self addSubview:_imageViews];
    [self addSubview:_titleLabel];
    return self;
}
#pragma maek -life cycle
-(void)layoutSubviews{
    [_imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kApplicationStatusBarHeight+90);
        make.width.offset(180);
        make.height.offset(150);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_imageViews.mas_bottom).offset(29);
    }];
}
#pragma mark -getter
-(UIImageView *)imageViews{
    if (!_imageViews) {
        _imageViews = [[UIImageView alloc] init];
        _imageViews.image = [UIImage imageNamed:_imageName];
    }
    return _imageViews;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _titleName;
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        _titleLabel.textColor = UIColorRBG(158, 158, 158);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
@end
