//
//  CollectionViewCell.h
//  Linkage
//


#import <UIKit/UIKit.h>

#define kCellIdentifier_CollectionView @"CollectionViewCell"

@class SubCategoryModel;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SubCategoryModel *model;


@property (nonatomic, strong) UILabel *name;

@end
