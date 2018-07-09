//
//  WZSharesCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSharesCollectionView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIImageView+WebCache.h>
#import "WZSharesCell.h"
static NSString * const ID = @"AlCell";
@interface WZSharesCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@end
@implementation WZSharesCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    [self setCollectionViewLayout:layout];
    self.frame = frame;
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZSharesCell" bundle:nil] forCellWithReuseIdentifier:ID];
    return self;
}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _urls.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSharesCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if ([_type isEqual:@"1"]) {
        [cell.voidView setHidden:YES];
        [cell.playButton setHidden:YES];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:_urls[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zlp_xq_pic"]];
    }else{
        [cell.photo setHidden:YES];
        [self createAVPlayer:_urls[indexPath.row] view:cell.voidView];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectBlock) {
        _selectBlock(_urls[indexPath.row]);
    }
}
#pragma mark - MPMoviePlayerController
- (void)createAVPlayer:(NSString *)url view:(UIView *)view{
    //在使用 AVPlayer 播放视频时，提供视频信息的是 AVPlayerItem，一个 AVPlayerItem 对应着一个URL视频资源
    // 1、得到视频的URL
    NSURL *movieURL = [NSURL URLWithString:url];
    // 2、根据URL创建AVPlayerItem
    self.playerItem   = [AVPlayerItem playerItemWithURL:movieURL];
    // 3、把AVPlayerItem 提供给 AVPlayer
    self.player     = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 4、AVPlayerLayer 显示视频。
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame  = view.bounds;
    //设置边界显示方式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [view.layer addSublayer:playerLayer];
}
@end
