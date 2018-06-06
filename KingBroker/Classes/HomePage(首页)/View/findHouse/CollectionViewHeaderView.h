//
//  CollectionViewHeaderView.h
//  Linkage
//


#import <UIKit/UIKit.h>
@class WZScreenItem;
@interface CollectionViewHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSArray *dics;

@property (nonatomic, strong) WZScreenItem *item;

@end
