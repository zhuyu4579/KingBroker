//
//  WZHouseNoteController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/20.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <WXApi.h>
#import "GKCover.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <WXApiObject.h>
#import <WebKit/WebKit.h>
#import "UIView+Frame.h"
#import "NSString+LCExtension.h"
#import "WZNavigationController.h"
#import "WZHouseNoteController.h"

@interface WZHouseNoteController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *pV;

@end

@implementation WZHouseNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    _webView.frame = CGRectMake(0, kApplicationStatusBarHeight-20, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight+20);
   
}
- (void)createWebView
{
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    // 根据需要去设置对应的属性
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    //KVO监听标题
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [[webView configuration].userContentController addScriptMessageHandler:self name:@"black"];
    [[webView configuration].userContentController addScriptMessageHandler:self name:@"login"];
    
     [[webView configuration].userContentController addScriptMessageHandler:self name:@"WXFriends"];
     [[webView configuration].userContentController addScriptMessageHandler:self name:@"WXFriendsCircle"];
     [[webView configuration].userContentController addScriptMessageHandler:self name:@"WXVideoShare"];
     [[webView configuration].userContentController addScriptMessageHandler:self name:@"WYFriends"];
     [[webView configuration].userContentController addScriptMessageHandler:self name:@"WYFriendsCircle"];
    
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //设置JS
    NSString *inputValueJS =[NSString stringWithFormat:@"getuuid('%@')",uuid];
    //执行JS
    [webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];

    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url rangeOfString:@"share.html"].location == NSNotFound) {
        
        NSURL *URL = navigationAction.request.URL;
        NSString *scheme = [URL scheme];
        if ([scheme isEqualToString:@"tel"]) {
            NSString *resourceSpecifier = [URL resourceSpecifier];
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
            /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            });
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        //跳转分享页面
        NSString *param = navigationAction.request.URL.query;
      
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    if ([message.name isEqualToString:@"black"]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else if([message.name isEqualToString:@"login"]){
        [NSString isCode:self.navigationController code:@"401"];
    }else if([message.name isEqualToString:@"WYFriends"]){
        //楼盘详情分享好友
        
        NSDictionary *data = message.body;
        [self WYShare:data];
        
    }else if([message.name isEqualToString:@"WYFriendsCircle"]){
        //楼盘详情分享朋友圈
         NSDictionary *data = message.body;
        [self WYFriendsButton:data];
    }else if([message.name isEqualToString:@"WXFriends"]){
        NSString *url = message.body;
        [self WXShare:url];
    }else if([message.name isEqualToString:@"WXFriendsCircle"]){
        NSString *url = message.body;
        [self friendsButton:url];
    }else if([message.name isEqualToString:@"WXVideoShare"]){
        NSString *url = message.body;
        [self downloadVideo:url];
    }
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
//监听值改变时就会调用
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.title = _webView.title;
}
-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"black"];
    [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"login"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
//分享到微信
-(void)WXShare:(NSString *)url{
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
        //2.创建多媒体消息中包含的图片数据对象
        WXImageObject *imgObj = [WXImageObject object];
        //图片真实数据
        imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
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
}
//分享到朋友圈
-(void)friendsButton:(NSString *)url{
        //1.创建多媒体消息结构体
        WXMediaMessage *mediaMsg = [WXMediaMessage message];
        //2.创建多媒体消息中包含的图片数据对象
        WXImageObject *imgObj = [WXImageObject object];
        //图片真实数据
        imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
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
        //弹窗提醒
        [self shareRemind];
    }
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
//分享到微信
-(void)WYShare:(NSDictionary *)data{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = [data valueForKey:@"title"];
    mediaMsg.description = [data valueForKey:@"desc"];
    UIImage *image =  [self handleImageWithURLStr:[data valueForKey:@"img"]];
    [mediaMsg setThumbImage:image];
    //分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [data valueForKey:@"url"];
    mediaMsg.mediaObject = webpageObject;
    
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
    
}
//分享到朋友圈
-(void)WYFriendsButton:(NSDictionary *)data{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    
    mediaMsg.title = [data valueForKey:@"title"];
    mediaMsg.description = [data valueForKey:@"desc"];
    
    UIImage *image =  [self handleImageWithURLStr:[data valueForKey:@"img"]];
    [mediaMsg setThumbImage:image];
    
    //2.分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [data valueForKey:@"url"];
    mediaMsg.mediaObject = webpageObject;
    
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
    
    
}
- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
