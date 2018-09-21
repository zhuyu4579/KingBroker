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
#import "UIView+Frame.h"
@interface WZAllPhotoCell(){
    CGFloat _lastScale;
    CGPoint _gestureInteractionStartPoint;
    
    float _lastTransX, _lastTransY;
}

@property (nonatomic, strong) SelVideoPlayer *player;

@property(nonatomic,strong) SelPlayerConfiguration *configuration;

@property(nonatomic,assign)CGPoint sourcePoint;
@end
@implementation WZAllPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.userInteractionEnabled = YES;//打开用户交互
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];

    [_imageView addGestureRecognizer:pinch];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [_imageView addGestureRecognizer:tapGestureRecognizer];
    
}
- (void)hideImageView:(UITapGestureRecognizer *)tap{
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        
       [tap view].transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {

    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
    
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
//
//    UIGestureRecognizerState state = [recognizer state];
//    if (state == UIGestureRecognizerStateBegan ||
//        state == UIGestureRecognizerStateChanged) {
//        //获取当前的比例
//        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
//
//        // Constants to adjust the max/min values of zoom
//        //设置最大最小的比例
//        const CGFloat kMaxScale = 3.0;
//        const CGFloat kMinScale = 1.0;
//        //设置
//
//        //获取上次比例减去想去得到的比例
//        CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
//        newScale = MIN(newScale, kMaxScale / currentScale);
//        newScale = MAX(newScale, kMinScale / currentScale);
//        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
//        [recognizer view].transform = transform;
//        // Store the previous scale factor for the next pinch gesture call
//        //获取最后比例 下次再用
//        _lastScale = [recognizer scale];
//
//    }
    UIView *view = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    }

    
}
-(void)setItem:(WZAlbumContensItem *)item{
    _item = item;
   
    NSString *type = item.type;
    if ([type isEqual:@"1"]) {
        _imageView.userInteractionEnabled = YES;
        [_imageView setHidden:NO];
        [_voidView setHidden:YES];
        [_playButton setHidden:YES];
    }else{
        [_imageView setHidden:NO];
        _imageView.userInteractionEnabled = NO;
        [_voidView setHidden:NO];
        [_playButton setHidden:NO];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"lp_pic"]];
    _videoPictureUrl = item.videoPictureUrl;
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
    configuration.repeatPlay = YES;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.sourceUrl = movieURL;
    configuration.videoGravity = SelVideoGravityResize;
    _player = [[SelVideoPlayer alloc] initWithFrame:_voidView.bounds configuration:configuration];
    [_voidView addSubview:_player];
    
}
- (IBAction)playVoid:(UIButton *)sender {
    _playButton = sender;
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
        if (![_videoPictureUrl isEqual:@""]) {
            [self createAVPlayer:_videoPictureUrl];
        }
        [_player _playVideo];
        [_imageView setHidden:YES];
    }else{
        [_imageView setHidden:NO];
         _configuration.repeatPlay = NO;
        [_player _pauseVideo];
    }
}
-(void)dealloc{
    [_player _deallocPlayer];
}
@end
