//
//  WZCollectionViewCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZAlbumContensItem;

@interface WZCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UIImageView *buttonImage;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic,strong) WZAlbumContensItem *item;
@end
