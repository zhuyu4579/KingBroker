//
//  WZAllPhotoCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SelPlayerConfiguration.h"
#import <UIImageView+WebCache.h>
#import "WZAllPhotoCell.h"
#import "SelVideoPlayer.h"
#import "WZAlbumsItem.h"

@interface WZAllPhotoCell(){
    CGFloat _lastScale;
}

@property (nonatomic, strong) SelVideoPlayer *player;

@property(nonatomic,strong) SelPlayerConfiguration *configuration;

@end
@implementation WZAllPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.userInteractionEnabled = YES;//打开用户交互
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    [_imageView addGestureRecognizer:pinch];
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    UIGestureRecognizerState state = [recognizer state];
    
    if(state == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        //获取最后的比例
        _lastScale = [recognizer scale];
    }
    
    if (state == UIGestureRecognizerStateBegan ||
        state == UIGestureRecognizerStateChanged) {
        //获取当前的比例
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        //设置最大最小的比例
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 1.0;
        //设置
        
        //获取上次比例减去想去得到的比例
        CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        [recognizer view].transform = transform;
        // Store the previous scale factor for the next pinch gesture call
        //获取最后比例 下次再用
        _lastScale = [recognizer scale];
    }
    
}
-(void)setItem:(WZAlbumContensItem *)item{
    _item = item;
    NSString *type = item.type;
    if ([type isEqual:@"1"]) {
        [_imageView setHidden:NO];
        [_voidView setHidden:YES];
        [_playButton setHidden:YES];
    }else{
        [_imageView setHidden:YES];
        [_voidView setHidden:NO];
        [_playButton setHidden:NO];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"lp_pic"]];
    NSString *videoPictureUrl = item.videoPictureUrl;
    if (![videoPictureUrl isEqual:@""]) {
        [self createAVPlayer:videoPictureUrl];
    }
    _ID = item.id;
    _title = item.title;
    _titleLabel.text = _title;
}
#pragma mark - MPMoviePlayerController
- (void)createAVPlayer:(NSString *)url{
    //在使用 AVPlayer 播放视频时，提供视频信息的是 AVPlayerItem，一个 AVPlayerItem 对应着一个URL视频资源
    // 1、得到视频的URL
    if (_voidView.subviews.count>0) {
        [_voidView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSURL *movieURL = [NSURL URLWithString:url];
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    _configuration = configuration;
    configuration.shouldAutoPlay = NO;
    configuration.supportedDoubleTap = YES;
    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = NO;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.sourceUrl = movieURL;
    configuration.videoGravity = SelVideoGravityResizeAspect;
    _player = [[SelVideoPlayer alloc] initWithFrame:_voidView.bounds configuration:configuration];
    [_voidView addSubview:_player];
    
}
- (IBAction)playVoid:(UIButton *)sender {
    _playButton = sender;
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
        _configuration.repeatPlay = YES;
        [_player _playVideo];
    }else{
         _configuration.repeatPlay = NO;
        [_player _pauseVideo];
    }
}
-(void)dealloc{
    [_player _deallocPlayer];
}
@end
