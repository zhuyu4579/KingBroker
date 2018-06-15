//
//  WZCollectionView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZCollectionView.h"
#import "WZScreenItem.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeaderView.h"
#import "NSObject+Property.h"
#import <MJExtension.h>
@interface WZCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
//每个分区的数组
@property(nonatomic,strong)NSArray *dicts;
//获取选中的数据
@property(nonatomic,strong)NSMutableDictionary *selectLabel;
//获取选中数据的下标
@property(nonatomic,strong)NSMutableDictionary *selectLilte;
@end

@implementation WZCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
//    self.bounces = NO;
    [self setCollectionViewLayout:layout];
    self.frame = frame;
    //注册cell
    [self registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
    //注册分区头标题
    [self registerClass:[CollectionViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeaderView"];
    self.backgroundColor = [UIColor whiteColor];
    NSMutableDictionary *selectLabel = [NSMutableDictionary dictionary];
    _selectLabel = selectLabel;
    NSMutableDictionary *selectLilte = [NSMutableDictionary dictionary];
    _selectLilte = selectLilte;
    
    return self;
}

#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.screenArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WZScreenItem *model = self.screenArray[section];
    return model.dicts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionView forIndexPath:indexPath];
    WZScreenItem *model = self.screenArray[indexPath.section];
    SubCategoryModel *scModel = model.dicts[indexPath.row];
    cell.model = scModel;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        WZScreenItem *model = self.screenArray[indexPath.section];
        view.item = model;
        
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 34);
}
//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell =(CollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    WZScreenItem *model = self.screenArray[indexPath.section];
    SubCategoryModel *scModel = model.dicts[indexPath.row];
    scModel.flag = !scModel.flag;
    cell.model = scModel;
    
    NSString *name = model.code;
    
    NSMutableArray *array = [_selectLabel valueForKey:name];
    
    NSString *value = scModel.value;
   
    BOOL isbool = [array containsObject:value];
    if (array.count == 0) {
        array = [NSMutableArray array];
    }
    if (scModel.flag) {
        if (!isbool) {
             [array addObject:value];
        }
    }else{
        if (array.count !=0) {
            for (int n = 0 ;n<array.count;n++) {
                if ([array[n] isEqual:value]) {
                    [array removeObject:array[n]];
                }
            }
        }
       
    }
    //获取选中数据
    _selectLabel[name] = array;
    
    if (_selectBlock) {
        _selectBlock(_selectLabel);
    }
}
-(void)clean{
    for (int i=0; i<_screenArray.count; i++) {
        WZScreenItem *model = self.screenArray[i];
        for (SubCategoryModel *sub in model.dicts) {
             sub.flag = NO;
             [self reloadData];
        }
    }
    [_selectLabel removeAllObjects];
    if (_selectBlock) {
        _selectBlock(_selectLabel);
    }
    
}
@end
