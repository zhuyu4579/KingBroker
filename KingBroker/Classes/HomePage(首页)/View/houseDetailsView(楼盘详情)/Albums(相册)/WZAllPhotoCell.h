//
//  WZAllPhotoCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZAlbumContensItem;
@interface WZAllPhotoCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *voidView;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)playVoid:(UIButton *)sender;

@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *videoPictureUrl;
@property(nonatomic,strong)WZAlbumContensItem *item;
@end
