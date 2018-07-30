//
//  WZShareVideoCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZShareVideoCell.h"
#import "WZShareDetailsItem.h"
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WZHouseShareDetailController.h"
#import "UIViewController+WZFindController.h"
@interface WZShareVideoCell()

@property (nonatomic, strong) SelVideoPlayer *player;

@property(nonatomic,strong) SelPlayerConfiguration *configuration;
//点击的按钮
@property (nonatomic, strong) UIButton *button;

@end
@implementation WZShareVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    [_shareButton setEnlargeEdge:44];
    _videoHeight.constant = 220*n;
    
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
   
}
#pragma mark - MPMoviePlayerController
- (void)createAVPlayer:(NSString *)url{
    //在使用 AVPlayer 播放视频时，提供视频信息的是 AVPlayerItem，一个 AVPlayerItem 对应着一个URL视频资源
    // 1、得到视频的URL
    if (_videoView.subviews.count>0) {
        [_videoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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
    _player = [[SelVideoPlayer alloc] initWithFrame:_videoView.bounds configuration:configuration];
    [_videoView addSubview:_player];
    
}
-(void)setItem:(WZShareDetailsItem *)item{
    _item = item;
    _playButton.selected = NO;
    _projectTaskId = item.projectTaskId;
    NSArray *urls = item.attachmentIds;
    if (urls.count>0) {
        [self createAVPlayer:urls[0]];
        _url = urls[0];
    }
    _title.text = item.title;
    NSString *type = item.type;
    _type = type;
    if ([type isEqual:@"1"]) {
        _taskImage.image = [UIImage imageNamed:@""];
    }else if([type isEqual:@"2"]){
        _taskImage.image = [UIImage imageNamed:@"label"];
    }
}
//播放视频
- (IBAction)playVideo:(UIButton *)sender {
    _button = sender;
    sender.selected = !sender.selected;
    if (sender.selected==YES) {
       [_player _playVideo];
    }else{
       [_player _pauseVideo];
    }
    
}
-(void)dealloc{
    [_player _deallocPlayer];
}
@end
