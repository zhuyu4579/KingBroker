//
//  WZSharePhoneCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import "WZSharePhoneCollectionView.h"
#import "WZSharePhoneCollectionCell.h"
static NSString * const ID = @"Cell";
@interface WZSharePhoneCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@end
@implementation WZSharePhoneCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.frame = frame;
    self.bounces = YES;
    [self setCollectionViewLayout:layout];
    
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZSharePhoneCollectionCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZSharePhoneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //转换图片地址
    [cell.phoneImage sd_setImageWithURL:[NSURL URLWithString:_array[indexPath.row]] placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSharePhoneCollectionCell *cell = (WZSharePhoneCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    cell.phoneImage.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    cell.phoneImage.layer.borderWidth = 2.0;
    
    NSString *url = _array[indexPath.row];
    if (_selectPhone) {
        _selectPhone(url);
    }
}


@end
