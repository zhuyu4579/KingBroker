//
//  WZVideoDailtelController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <WXApi.h>
#import "GKCover.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <WXApiObject.h>
#import "SelVideoPlayer.h"
#import <UIImageView+WebCache.h>
#import "SelPlayerConfiguration.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZVideoDailtelController.h"

@interface WZVideoDailtelController ()

@property (nonatomic, strong) SelVideoPlayer *player;

@property(nonatomic,strong) SelPlayerConfiguration *configuration;

@property (nonatomic, strong) UIView *redView;
@end

@implementation WZVideoDailtelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //创建控件
    [self setControl];
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight+13, 11, 20)];
    [backButton setImage:[UIImage imageNamed:@"wd_wmBack"] forState:UIControlStateNormal];
    [backButton setEnlargeEdge:44];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [self shareTasks];
}
#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
#pragma mark -创建控件
-(void)setControl{
    UIView *videoView = [[UIView alloc] init];
    videoView.frame = self.view.bounds;
    [self.view addSubview:videoView];
    NSURL *movieURL = [NSURL URLWithString:[_dicty valueForKey:@"videoUrl"]];
    SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
    _configuration = configuration;
    configuration.shouldAutoPlay = YES;
    configuration.supportedDoubleTap = YES;
    configuration.shouldAutorotate = YES;
    configuration.repeatPlay = YES;
    configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
    configuration.sourceUrl = movieURL;
    configuration.videoGravity = SelVideoGravityResizeAspect;
    _player = [[SelVideoPlayer alloc] initWithFrame:videoView.bounds configuration:configuration];
    [videoView addSubview:_player];
    //头像
    UIImageView *imageHead = [[UIImageView alloc] init];
    [imageHead sd_setImageWithURL:[NSURL URLWithString:[_dicty valueForKey:@"portrait"]] placeholderImage:[UIImage imageNamed:@"xx_pic"]];
    imageHead.layer.cornerRadius = 25.0;
    imageHead.layer.masksToBounds = YES;
    [self.view addSubview:imageHead];
    [imageHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-195);
        make.width.offset(49);
        make.height.offset(49);
    }];
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setEnlargeEdge:44];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"sptk_icon2"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.top.equalTo(imageHead.mas_bottom).offset(44);
        make.width.offset(34);
        make.height.offset(27);
    }];
    UILabel *realName = [[UILabel alloc] init];
    realName.textColor = [UIColor whiteColor];
    realName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    realName.text = [_dicty valueForKey:@"realname"];
    [self.view addSubview:realName];
    [realName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.equalTo(shareButton.mas_bottom).offset(33);
        make.height.offset(17);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    title.text = [_dicty valueForKey:@"title"];
    title.numberOfLines = 2;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.top.equalTo(realName.mas_bottom).offset(13);
        make.width.offset(self.view.fWidth-24);
    }];
    
}
//分享弹框
-(void)shareTasks{
    //弹出分享页
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT -250, self.view.fWidth, 250)];
    redView.backgroundColor = UIColorRBG(246, 246, 246);
    _redView = redView;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(16,16,50,12);
    label.text = @"分享至：";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    label.textColor = UIColorRBG(102, 102, 102);
    [redView addSubview:label];
    //创建微信按钮
    UIButton *WXButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0-87, 67, 50, 50)];
    [WXButton setBackgroundImage:[UIImage imageNamed:@"wewhat"] forState:UIControlStateNormal];
    [WXButton addTarget:self action:@selector(WXShare) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:WXButton];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.frame = CGRectMake(redView.fWidth/2.0-87,126,50,12);
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.text = @"微信好友";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [redView addSubview:labelOne];
    
    //创建朋友圈按钮
    UIButton *friendsButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+37, 67, 50, 50)];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"circle-of-friend"] forState:UIControlStateNormal];
    [friendsButton addTarget:self action:@selector(WXShare) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:friendsButton];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.frame = CGRectMake(redView.fWidth/2.0+37,126,50,12);
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.text = @"朋友圈";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelTwo.textColor =  UIColorRBG(68, 68, 68);
    [redView addSubview:labelTwo];
    
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, redView.fWidth, 1)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [redView addSubview:ineView];
    //创建取消按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 201, redView.fWidth, 49)];
    [cleanButton setTitle:@"取消" forState:UIControlStateNormal];
    [cleanButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    
    [cleanButton addTarget:self action:@selector(closeGkCover) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:cleanButton];
  
}
#pragma mark -分享
-(void)share{
      [GKCover translucentCoverFrom:self.view content:_redView animated:YES];
}
-(void)WXShare{
    NSString *url = [_dicty valueForKey:@"videoUrl"];
    [self downloadVideo:url];
}
//下载视频
-(void)downloadVideo:(NSString *)url{
    //下载视频到本地
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:[NSDate date]]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"video/mpeg",@"video/mp4",@"audio/mp3",nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", cachePath, fileName];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在下载视频"];
    
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       
                       [self saveVideo:fullPath];
                   }];
    [task resume];
}
//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        //保存失败
        [SVProgressHUD dismiss];
        [GKCover hide];
        [SVProgressHUD showInfoWithStatus:@"下载视频失败"];
    }else{
        //保存成功
        [SVProgressHUD dismiss];
        [GKCover hide];
        [SVProgressHUD showInfoWithStatus:@"下载视频成功"];
        [self loadUpShare];
        //弹窗提醒
        [self shareRemind];
    }
}
#pragma mark -点击分享视频
-(void)loadUpShare{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSString *url = [NSString stringWithFormat:@"%@/video/videoShare",HTTPURL];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"ids"] = [_dicty valueForKey:@"id"];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//提示弹框
-(void)shareRemind{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(243, 244);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"XC_PIC"];
    [imageView sizeToFit];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(view.fWidth);
        make.height.offset(view.fHeight);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"需要你到微信或朋友圈上传视频才能分享";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(51, 51, 51);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(138);
        make.width.offset(view.fWidth-90);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"xc_shareButton"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 18;
    button.layer.masksToBounds = YES;
    [button setTitle:@"去分享" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [button setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-18);
        make.height.offset(36);
        make.width.offset(145);
    }];
    [GKCover translucentWindowCenterCoverContent:view animated:NO];
}
//关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
//分享视频
-(void)shareVideo{
    [GKCover hide];
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(void)dealloc{
    [_player _deallocPlayer];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
@end
