//
//  WZHouseShareDetailController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHouseShareDetailController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+LCExtension.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "SelVideoPlayer.h"
#import "SelPlayerConfiguration.h"
#import "WZSharesCollectionView.h"
#import "GKCover.h"
#import <WXApi.h>
#import <WXApiObject.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface WZHouseShareDetailController ()
@property(nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic, strong) SelVideoPlayer *player;

@property(nonatomic,strong) SelPlayerConfiguration *configuration;

@property(nonatomic,strong)UIImageView *imageView;

@property (nonatomic, strong) UILabel *content;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) UIView *selectMore;
//复制的内容
@property(nonatomic,strong) NSString *contents;
//选择的URl
@property(nonatomic,strong) NSString *url;
//视频的url
@property(nonatomic,strong) NSString *vidoUrl;
//分享类型
@property(nonatomic,strong) NSString *type;
//分享弹框
@property(nonatomic,strong) UIView *redView;
//悬赏类型
@property(nonatomic,strong)NSString *taskType;
//点击分享按钮
@property (nonatomic, strong) UIButton *shareButton;
//分享按钮赏字
@property (nonatomic, strong) UIImageView *imageViewDetail;
@end

@implementation WZHouseShareDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"分享";
    
    UIScrollView *scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight)];
    _scrollView = scollView;
    [self.view addSubview:scollView];
   
    
    [self loadData];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:@"taskShare" object:nil];
}

//请求数据
-(void)loadData{
    
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
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/taskSource/taskSourceInfo",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            
            NSDictionary *data = [responseObject valueForKey:@"data"];
            
            
            NSDictionary *share = [data valueForKey:@"share"];
            
            _taskType = [share valueForKey:@"taskType"];
            //创建view
            [self createView:share];
            [self shareTasks];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        
    }];
}
#pragma mark -初始化控件
-(void)createView:(NSDictionary *)dicty{
    
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    //类型
    NSString *type = [dicty valueForKey:@"type"];
    _type = type;
    //图片或视频地址
    NSArray *urls  = [dicty valueForKey:@"url"];
    
    _contents = [dicty valueForKey:@"title"];
    
    if(urls.count==0){
        return;
    }
    //视频view
    UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, 230*n)];
    [_scrollView addSubview:playView];
    if ([type isEqual:@"1"]) {
        //图片
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        imageView.frame = playView.bounds;
        [playView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:[UIImage imageNamed:@"zlp_xq_pic"]];
        _url = urls[0];
    }else{
        
        SelPlayerConfiguration *configuration = [[SelPlayerConfiguration alloc]init];
        _configuration = configuration;
        configuration.shouldAutoPlay = YES;
        configuration.supportedDoubleTap = YES;
        configuration.shouldAutorotate = YES;
        configuration.repeatPlay = YES;
        configuration.statusBarHideState = SelStatusBarHideStateFollowControls;
        configuration.sourceUrl = [NSURL URLWithString:urls[0]];
        configuration.videoGravity = SelVideoGravityResizeAspect;
        _player = [[SelVideoPlayer alloc] initWithFrame:playView.bounds configuration:configuration];
        [playView addSubview:_player];
        _url = urls[0];
    }
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.textColor = UIColorRBG(51, 51, 51);
    labelOne.text = @"分享内容";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    [_scrollView addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(playView.mas_bottom).offset(22);
        make.height.offset(16);
    }];
    //华丽的分割线
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(220, 220, 220);
    [_scrollView addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(labelOne.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(playView.fWidth-30);
    }];
    //文字内容
    UILabel *content = [[UILabel alloc] init];
    content.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    content.textColor = UIColorRBG(101, 101, 101);
    _content = content;
    content.numberOfLines = 4;
    content.text = _contents;
    [_scrollView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(ineOne.mas_bottom).offset(15);
        make.width.offset(playView.fWidth-30);
    }];
    //更多按钮144
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [moreButton setEnlargeEdge:44];
    moreButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [moreButton addTarget:self action:@selector(moreContent) forControlEvents:UIControlEventTouchUpInside];
    _moreButton = moreButton;
    [_scrollView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(content.mas_bottom).offset(10);
        make.width.offset(30);
        make.height.offset(15);
    }];
    //复制内容按钮
    UIButton *copyContent = [[UIButton alloc] init];
    [copyContent setTitle:@"复制内容" forState:UIControlStateNormal];
    [copyContent setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    copyContent.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    copyContent.layer.cornerRadius = 20;
    copyContent.layer.masksToBounds = YES;
    copyContent.layer.borderWidth = 1.0;
    copyContent.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [copyContent addTarget:self action:@selector(copyContents) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:copyContent];
    [copyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_scrollView.mas_centerX).offset(-23);
        make.top.equalTo(moreButton.mas_bottom).offset(19);
        make.width.offset(125);
        make.height.offset(40);
    }];
    //分享内容按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setTitle:@"点击分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    shareButton.layer.cornerRadius = 20;
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.borderWidth = 1.0;
    shareButton.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [shareButton addTarget:self action:@selector(shareTask) forControlEvents:UIControlEventTouchUpInside];
    _shareButton = shareButton;
    [_scrollView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_centerX).offset(23);
        make.top.equalTo(moreButton.mas_bottom).offset(19);
        make.width.offset(125);
        make.height.offset(40);
    }];
    //选择视频
    UILabel *labelTwo = [[UILabel alloc] init];
    if ([type isEqual:@"1"]) {
        labelTwo.text = @"图片选择";
    }else{
        labelTwo.text = @"视频选择";
    }
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    labelTwo.textColor = UIColorRBG(51, 51, 51);
    [_scrollView addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(copyContent.mas_bottom).offset(33);
        make.height.offset(16);
    }];
    //华丽的分割线
    UIView *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(220, 220, 220);
    [_scrollView addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(labelTwo.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(_scrollView.fWidth-30);
    }];
    //视频选择区域
    UIView *selectMore = [[UIView alloc] init];
    selectMore.backgroundColor = [UIColor whiteColor];
    _selectMore = selectMore;
    [_scrollView addSubview:selectMore];
    [selectMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left);
        make.top.equalTo(ineTwo.mas_bottom).offset(3);
        make.height.offset(110*n);
        make.width.offset(_scrollView.fWidth);
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(155*n, 90*n);
    WZSharesCollectionView *shareCV = [[WZSharesCollectionView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.fWidth, 110*n) collectionViewLayout:layout];
    shareCV.type = type;
    shareCV.urls = urls;
    [selectMore addSubview:shareCV];
    if ([type isEqual:@"1"]) {
        shareCV.selectBlock = ^(NSString *url) {
            _url = url;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zlp_xq_pic"]];
        };
    }else{
        shareCV.selectBlock = ^(NSString *url) {
            _url = url;
            _configuration.sourceUrl = [NSURL URLWithString:url];
            [_player  removeFromSuperview];
            _player = [[SelVideoPlayer alloc] initWithFrame:playView.bounds configuration:_configuration];
            [playView addSubview:_player];
        };
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _scrollView.contentSize = CGSizeMake(0, _selectMore.fY+_selectMore.fHeight);
}
-(void)moreContent{
    _content.numberOfLines = 0;
    [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
    [_moreButton removeTarget:self action:@selector(moreContent) forControlEvents:UIControlEventTouchUpInside];
    [_moreButton addTarget:self action:@selector(takeUp) forControlEvents:UIControlEventTouchUpInside];
}
-(void)takeUp{
    _content.numberOfLines = 4;
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton removeTarget:self action:@selector(takeUp) forControlEvents:UIControlEventTouchUpInside];
    [_moreButton addTarget:self action:@selector(moreContent) forControlEvents:UIControlEventTouchUpInside];
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
    
    //创建悬赏标识
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+42, 41, 37, 21)];
    if ([_taskType isEqual:@"1"]) {
        imageView.image = [UIImage imageNamed:@""];
    }else if([_taskType isEqual:@"2"]){
        imageView.image = [UIImage imageNamed:@"label"];
    }else{
        imageView.image = [UIImage imageNamed:@"label_2"];
    }
    _imageViewDetail = imageView;
    [redView addSubview:imageView];
    //创建朋友圈按钮
    UIButton *friendsButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+37, 67, 50, 50)];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"circle-of-friend"] forState:UIControlStateNormal];
    [friendsButton addTarget:self action:@selector(friendsButton) forControlEvents:UIControlEventTouchUpInside];
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
//分享
-(void)shareTask{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _content.text;
    [GKCover translucentCoverFrom:self.view content:_redView animated:YES];
}
//分享到微信
-(void)WXShare{
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    if ([_type isEqual:@"1"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"shareSuccessType"];
        [defaults synchronize];
        //2.创建多媒体消息中包含的图片数据对象
        WXImageObject *imgObj = [WXImageObject object];
        //图片真实数据
        imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]];
        //多媒体数据对象
        mediaMsg.mediaObject = imgObj;
        //3.创建发送消息至微信终端程序的消息结构体
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        //多媒体消息的内容
        req.message = mediaMsg;
        //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
        req.bText = NO;
        //指定发送到会话(聊天界面)
        req.scene = WXSceneSession;
        //发送请求到微信,等待微信返回onResp
        [WXApi sendReq:req];
        
        [self closeGkCover];
        
    }else {
        
        [self downloadVideo];
    }
    
    
}
//分享到朋友圈
-(void)friendsButton{
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    if ([_type isEqual:@"1"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"shareSuccessType"];
        [defaults synchronize];
        //2.创建多媒体消息中包含的图片数据对象
        WXImageObject *imgObj = [WXImageObject object];
        //图片真实数据
        imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]];
        //多媒体数据对象
        mediaMsg.mediaObject = imgObj;
        //3.创建发送消息至微信终端程序的消息结构体
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        //多媒体消息的内容
        req.message = mediaMsg;
        //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
        req.bText = NO;
        //指定发送到会话(聊天界面)
        req.scene = WXSceneTimeline;
        //发送请求到微信,等待微信返回onResp
        [WXApi sendReq:req];
        [self closeGkCover];
       
    }else {
        [self downloadVideo];
    }
}
//下载视频
-(void)downloadVideo{
    //下载视频到本地
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:[NSDate date]]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"video/mpeg",@"video/mp4",@"audio/mp3",nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", cachePath, fileName];
    NSURL *urlNew = [NSURL URLWithString:_url];
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
        //弹窗提醒
        [self shareRemind];
    }
}
//提示弹框
-(void)shareRemind{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(295, 240);
    UIView *viewTwo = [[UIView alloc] init];
    viewTwo.frame = CGRectMake(0, 57, view.fWidth, 183);
    viewTwo.backgroundColor = [UIColor whiteColor];
    viewTwo.layer.cornerRadius = 7.0;
    viewTwo.layer.masksToBounds = YES;
    [view addSubview:viewTwo];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon"];
    [imageView sizeToFit];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"需要您上传视频才能分享";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    label.textColor = UIColorRBG(51, 51, 51);
    [viewTwo addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewTwo.mas_centerX);
        make.top.equalTo(viewTwo.mas_top).offset(82);
        make.height.offset(15);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"background_2"] forState:UIControlStateNormal];
    [button setTitle:@"去分享" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [viewTwo addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left);
        make.bottom.equalTo(viewTwo.mas_bottom);
        make.height.offset(51);
        make.width.offset(viewTwo.fWidth);
    }];
    [GKCover translucentWindowCenterCoverContent:view animated:NO];
}
//关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
//分享视频
-(void)shareVideo{
    
    [self shareSuccess];
    [GKCover hide];
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
//分享回调
-(void)shareSuccess{
    
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
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    paraments[@"num"] = @"";
    NSString *url = [NSString stringWithFormat:@"%@/projectTask/callback",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [self loadDatas];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD valueForKey:@"网络不给力"];
    }];
}

//请求数据
-(void)loadDatas{
    
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
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/taskSource/taskSourceInfo",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            
            NSDictionary *data = [responseObject valueForKey:@"data"];
            
            NSDictionary *share = [data valueForKey:@"share"];
            
            _taskType = [share valueForKey:@"taskType"];
            if ([_taskType isEqual:@"1"]) {
                _imageViewDetail.image = [UIImage imageNamed:@""];
            }else if([_taskType isEqual:@"2"]){
                _imageViewDetail.image = [UIImage imageNamed:@"label"];
            }else{
                _imageViewDetail.image = [UIImage imageNamed:@"label_2"];
            }
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        
    }];
}
//复制内容
-(void)copyContents{
    [SVProgressHUD showInfoWithStatus:@"复制内容成功"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _content.text;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_player _deallocPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//将毫秒数转换成时间
-(NSString *)ConvertStrToTime:(NSInteger)time{
    NSInteger times = time/1000;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",times/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(times%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",times%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}


@end
