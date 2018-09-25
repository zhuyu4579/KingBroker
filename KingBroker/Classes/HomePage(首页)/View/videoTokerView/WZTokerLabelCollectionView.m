//
//  WZTokerLabelCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZTokerTitleItem.h"
#import "WZTokerLabelCell.h"
#import "WZVideoListLabelController.h"
#import "UIViewController+WZFindController.h"
#import "WZTokerLabelCollectionView.h"
@interface WZTokerLabelCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@end
static NSString * const ID = @"cell";

@implementation WZTokerLabelCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.backgroundColor = [UIColor clearColor];
    [self setCollectionViewLayout:layout];
    self.frame = frame;
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZTokerLabelCell" bundle:nil] forCellWithReuseIdentifier:ID];
    return self;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _albumArray.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZTokerLabelCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZTokerTitleItem *item = _albumArray[indexPath.row];
    cell.item = item;
    return cell;
}
//点击图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZTokerLabelCell *cell = (WZTokerLabelCell *) [collectionView cellForItemAtIndexPath:indexPath];
    WZVideoListLabelController *videoView = [[WZVideoListLabelController alloc] init];
    videoView.name = cell.name;
    videoView.type = @"0";
    videoView.navigationItem.title = cell.name;
    UIViewController *Vc = [UIViewController viewController:self.superview];
    [Vc.navigationController pushViewController:videoView animated:YES];
}

@end
