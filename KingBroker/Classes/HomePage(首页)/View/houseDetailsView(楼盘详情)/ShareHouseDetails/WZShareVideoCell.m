//
//  WZShareVideoCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZShareVideoCell.h"
#import "WZShareDetailsItem.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WZHouseShareDetailController.h"
#import "UIViewController+WZFindController.h"
@interface WZShareVideoCell()
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@end
@implementation WZShareVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    _content.textColor = UIColorRBG(102, 102, 102);
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
    [_videoView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    NSURL *movieURL = [NSURL URLWithString:url];
    // 2、根据URL创建AVPlayerItem
    self.playerItem   = [AVPlayerItem playerItemWithURL:movieURL];
    // 3、把AVPlayerItem 提供给 AVPlayer
    self.player     = [AVPlayer playerWithPlayerItem:self.playerItem];
    // 4、AVPlayerLayer 显示视频。
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame  = _videoView.bounds;
    //设置边界显示方式
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [_videoView.layer addSublayer:playerLayer];
}
-(void)setItem:(WZShareDetailsItem *)item{
    _item = item;
    _projectTaskId = item.projectTaskId;
    _content.text = item.title;
    NSArray *urls = item.attachmentIds;
    if (urls.count>0) {
        [self createAVPlayer:urls[0]];
    }
    _title.text = item.shareName;
    NSString *type = item.type;
    if ([type isEqual:@"1"]) {
        _taskImage.image = [UIImage imageNamed:@""];
    }else if([type isEqual:@"2"]){
        _taskImage.image = [UIImage imageNamed:@"label"];
    }
}
- (IBAction)shareAction:(UIButton *)sender {
    WZHouseShareDetailController *shareVc = [[WZHouseShareDetailController alloc] init];
    shareVc.ID = _projectTaskId;
    UIViewController *Vc =  [UIViewController viewController:[self superview].superview];
    [Vc.navigationController pushViewController:shareVc animated:YES];
}
@end
