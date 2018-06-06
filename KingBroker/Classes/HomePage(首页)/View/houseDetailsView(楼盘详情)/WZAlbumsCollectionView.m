//
//  WZAlbumsCollectionView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAlbumsCollectionView.h"
#import "WZCollectionViewCell.h"
#import "WZAlbumsItem.h"
#import "WZCollectionHeaderView.h"
#import "NSObject+Property.h"
#import <UIImageView+WebCache.h>
static NSString * const ID = @"AlCell";
@interface WZAlbumsCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
@property(nonatomic,strong)NSArray *albumType;
@end
@implementation WZAlbumsCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     self.frame = frame;
    self.bounces = YES;
    [self setCollectionViewLayout:layout];
    
    //注册cell
    [self registerClass:[WZCollectionViewCell class] forCellWithReuseIdentifier:ID];
    //注册分区头标题
    [self registerClass:[WZCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WZCollectionHeaderView"];
    self.backgroundColor = [UIColor whiteColor];
    //获取字典
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"dictGroup.plist"];
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    
    for (NSDictionary *obj in result) {
        NSString *code = [obj valueForKey:@"code"];
        //类型
        if ([code isEqual:@"tplx"]) {
            NSArray *itemArray = [obj valueForKey:@"dicts"];
            _albumType = itemArray;
            break;
        }
        
    }
   
    return self;
}


#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albumArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WZAlbumsItem *model = self.albumArray[section];
    return model.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZAlbumsItem *mdel = self.albumArray[indexPath.section];
    NSString *url = mdel.pictures[indexPath.row];
    //转换图片地址
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zlp_pic"]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    { // header
        reuseIdentifier = @"WZCollectionHeaderView";
    }
    WZCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        WZAlbumsItem *model = self.albumArray[indexPath.section];
        view.pictures = model.pictures;
        NSString *type = model.type;
        for (NSDictionary *dicty in _albumType) {
            NSString *value = [dicty valueForKey:@"value"];
            if (![value isEqual:@"5"] && [type isEqual:value]) {
                view.headerTitle.text = [dicty valueForKey:@"label"];
                break;
            }
        }
        if ([type isEqual:@"5"]) {
            view.headerTitle.text = model.name;
        }
        
    }
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 34);
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[collectionView indexPathsForVisibleItems] lastObject]).row){
        self.isLoaded = @"1";
    }
}
//滑动到底部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y+height;
    
    UIButton *button = [self.superview.superview viewWithTag:11];
    UIButton *button1 = [self.superview.superview viewWithTag:10];
    UIButton *button2 = [self.superview.superview viewWithTag:12];
    
    CGFloat offsets1 = [self offsets:3];
    CGFloat offsets2 = [self offsets:(_albumArray.count-1)];
 
    if (contentYoffset >= 0 && contentYoffset < offsets1) {
        button1.selected = YES;
        button.selected = NO;
        button2.selected = NO;
    }
    if (contentYoffset >= offsets1 && contentYoffset<offsets2) {
        button1.selected = NO;
        button.selected = YES;
        button2.selected = NO;
    }
    
    if (contentYoffset >= offsets2) {
        button.selected = NO;
        button1.selected = NO;
        button2.selected = YES;
    }
    
} 
-(CGFloat)offsets:(NSInteger)n{
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:n];
    
    UICollectionViewLayoutAttributes *attr = [self.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
    UIEdgeInsets insets = self.scrollIndicatorInsets;
    
    CGRect rect = attr.frame;
    rect.size = self.frame.size;
    rect.size.height -= insets.top + insets.bottom;
    CGFloat offset = rect.origin.y;
    
    return offset;
}
@end
