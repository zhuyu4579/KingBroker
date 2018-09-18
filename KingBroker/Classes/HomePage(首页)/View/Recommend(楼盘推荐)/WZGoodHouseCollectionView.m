//
//  WZGoodHouseCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZGoodHouseCell.h"
#import "WZGoodHouseItem.h"
#import "WZGoodHouseController.h"
#import "NSString+LCExtension.h"
#import "WZGoodHouseCollectionView.h"
#import "UIViewController+WZFindController.h"
static NSString * const ID = @"cell";
@interface WZGoodHouseCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@end
@implementation WZGoodHouseCollectionView
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
    [self setCollectionViewLayout:layout];
    self.frame = frame;
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZGoodHouseCell" bundle:nil] forCellWithReuseIdentifier:ID];
    return self;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _houseArray.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZGoodHouseCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZGoodHouseItem *item = _houseArray[indexPath.row];
    cell.item = item;
    return cell;
}
//点击图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    WZGoodHouseCell *cell = (WZGoodHouseCell *) [collectionView cellForItemAtIndexPath:indexPath];
    WZGoodHouseItem *item = _houseArray[indexPath.row];
    WZGoodHouseController *goodHouse = [[WZGoodHouseController alloc] init];
    goodHouse.ID = cell.ID;
    goodHouse.name = item.labelName;
    UIViewController *Vc = [UIViewController viewController:self.superview];
    if (uuid && ![uuid isEqual:@""]) {
        [Vc.navigationController pushViewController:goodHouse animated:YES];
    }else{
        [NSString isCode:Vc.navigationController code:@"401"];
    }
    
}
@end
