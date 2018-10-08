//
//  WZInvitePrizeController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  邀请有奖
#import <WXApi.h>
#import "GKCover.h"
#import <Masonry.h>
#import "CCPScrollView.h"
#import <WXApiObject.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <WebKit/WebKit.h>
#import "NSString+LCExtension.h"
#import "WZInvitePrizeController.h"

@interface WZInvitePrizeController ()<UIScrollViewDelegate>
@property(nonatomic,strong)CCPScrollView *scrollView;
@property(nonatomic,strong)UIView *lunView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UILabel *num;
@property(nonatomic,strong)UILabel *money;
@property(nonatomic,strong)UILabel *inviteCode;
@property(nonatomic,strong)UIView *redView;
@property(nonatomic,strong)UIView *ruleView;
@property(nonatomic,strong)NSDictionary *data;
@end

@implementation WZInvitePrizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"分享有奖";
    //创建控件
    [self setControl];
    [self shareRuleTask];
    [self shareTasks];
    
}
#pragma mark -请求数据
-(void)loadData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSString *url = [NSString stringWithFormat:@"%@/userRelation/userRelationInfo",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            [self setLunNews:[data valueForKey:@"infos"]];
            _num.text = [data valueForKey:@"countNum"];
            _money.text = [data valueForKey:@"countPrice"];
            _inviteCode.text = [data valueForKey:@"username"];
            NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
            dicty[@"url"] = [data valueForKey:@"url"];
            dicty[@"title"] = [data valueForKey:@"title"];
            dicty[@"describe"] = [data valueForKey:@"describe"];
            dicty[@"imageUrl"] = [data valueForKey:@"imageUrl"];
            _data = dicty;
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                [NSString isCode:self.navigationController code:code];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
}

#pragma mark - 邀请有奖
-(void)setControl{
    CGFloat n  = SCREEN_WIDTH/375.0;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, kApplicationStatusBarHeight+44, self.view.fWidth, self.view.fHeight);
    imageView.image = [UIImage imageNamed:@"yq_background"];
    [self.view addSubview:imageView];
    
    UIButton *shareRule = [[UIButton alloc] init];
    [shareRule setBackgroundImage:[UIImage imageNamed:@"yq_gz"] forState:UIControlStateNormal];
    [shareRule setTitle:@"邀请规则" forState:UIControlStateNormal];
    [shareRule setTitleColor:UIColorRBG(190, 68, 42) forState:UIControlStateNormal];
    [shareRule setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 1, 0)];
    shareRule.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [shareRule addTarget:self action:@selector(shareRule) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareRule];
    [shareRule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+68);
        make.width.offset(75);
        make.height.offset(28);
    }];
    //创建滚动动态
    UIView *lunView =[[UIView alloc] init];
    _lunView = lunView;
    [self.view addSubview:lunView];
    [lunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+244*n);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(22);
    }];

    //邀请码
    UIView *inviteCodeView = [[UIView alloc] init];
    [self.view addSubview:inviteCodeView];
    [inviteCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.top.equalTo(lunView.mas_bottom).offset(25);
        make.width.offset(self.view.fWidth-100);
        make.height.offset(105);
    }];
    UIImageView *inviteImageView = [[UIImageView alloc] init];
    inviteImageView.image = [UIImage imageNamed:@"fxyj_yqm"];
    [inviteCodeView addSubview:inviteImageView];
    [inviteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviteCodeView.mas_left);
        make.top.equalTo(inviteCodeView.mas_top);
        make.width.offset(self.view.fWidth-100);
        make.height.offset(105);
    }];
    UILabel *titleLabe = [[UILabel alloc] init];
    titleLabe.text = @"我的邀请码";
    titleLabe.textColor = UIColorRBG(255, 122, 56);
    titleLabe.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [inviteCodeView addSubview:titleLabe];
    [titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(inviteCodeView.mas_centerX);
        make.top.equalTo(inviteCodeView.mas_top).offset(28);
        make.height.offset(12);
    }];
    UILabel *inviteCode = [[UILabel alloc] init];
    inviteCode.textColor = UIColorRBG(255, 109, 26);
    inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:20];
    _inviteCode = inviteCode;
    [inviteCodeView addSubview:inviteCode];
    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(inviteCodeView.mas_centerX);
        make.top.equalTo(titleLabe.mas_top).offset(24);
    }];
    //邀请按钮
    UIButton *inviteButton = [[UIButton alloc] init];
    [inviteButton setBackgroundImage:[UIImage imageNamed:@"yq_button"] forState:UIControlStateNormal];
    [inviteButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    inviteButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    [inviteButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    [inviteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    [inviteButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteButton];
    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(inviteCodeView.mas_bottom).offset(28);
        make.width.offset(self.view.fWidth-106);
        make.height.offset(48);
    }];
    //邀请战绩
    UILabel *recordTitle = [[UILabel alloc] init];
    recordTitle.text = @"我的邀请战绩";
    recordTitle.textColor = UIColorRBG(189, 126, 68);
    recordTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [self.view addSubview:recordTitle];
    [recordTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(inviteButton.mas_bottom).offset(41);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(215, 169, 127);
    [self.view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(recordTitle.mas_bottom).offset(30);
        make.height.offset(34);
        make.width.offset(1);
    }];
    UIView *leftView = [[UIView alloc] init];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ineView.mas_left);
        make.top.equalTo(recordTitle.mas_bottom).offset(30);
        make.height.offset(34);
        make.width.offset((self.view.fWidth-1)/2.0);
    }];
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"0";
    numLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    numLabel.textColor = UIColorRBG(189, 126, 68);
    _num = numLabel;
    [leftView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView.mas_centerX);
        make.top.equalTo(leftView.mas_top).offset(1);
        make.height.offset(12);
    }];
    UILabel *numLabels = [[UILabel alloc] init];
    numLabels.text = @"共邀请好友";
    numLabels.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    numLabels.textColor = UIColorRBG(237, 178, 125);
    [leftView addSubview:numLabels];
    [numLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView.mas_centerX);
        make.top.equalTo(numLabel.mas_bottom).offset(8);
        make.height.offset(12);
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ineView.mas_right);
        make.top.equalTo(recordTitle.mas_bottom).offset(30);
        make.height.offset(34);
        make.width.offset((self.view.fWidth-1)/2.0);
    }];
    UILabel *money = [[UILabel alloc] init];
    money.text = @"0.00";
    money.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    money.textColor = UIColorRBG(189, 126, 68);
    _money = money;
    [rightView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView.mas_centerX);
        make.top.equalTo(rightView.mas_top).offset(1);
        make.height.offset(12);
    }];
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"获得现金(元)";
    moneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    moneyLabel.textColor = UIColorRBG(237, 178, 125);
    [rightView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView.mas_centerX);
        make.top.equalTo(money.mas_bottom).offset(8);
        make.height.offset(12);
    }];
    
}
#pragma mark -创建消息轮播
-(void)setLunNews:(NSArray *)array{
    CCPScrollView *ccpView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth-30, 22)];
    
    ccpView.titleArray = array;
    
    ccpView.titleFont = 12;
    
    ccpView.titleColor = UIColorRBG(51, 51, 51);
    
    ccpView.BGColor = [UIColor clearColor];
    
    _scrollView = ccpView;
    [_lunView addSubview:ccpView];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [_scrollView removeTimer];
    [_scrollView removeFromSuperview];
}
#pragma mark -邀请弹框
-(void)shareRuleTask{
    UIView *ruleView = [[UIView alloc] init];
    ruleView.fSize = CGSizeMake(295, 525);
    _ruleView = ruleView;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ruleView.fWidth, 470)];
    view.layer.cornerRadius = 5.0;
    view.backgroundColor = [UIColor whiteColor];
    [ruleView addSubview:view];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.textColor = UIColorRBG(49, 35, 6);
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:18];
    labelOne.text = @"邀请规则";
    [view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(25);
        make.height.offset(17);
    }];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.textColor = UIColorRBG(51, 51, 51);
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    labelTwo.text = @"1.所有经喜用户均可邀请好友成为经喜app新用户，每位用户每日分享次数不设上限。同一用户仅限一台设备登录，如同一登录设备中途更换设备参与本活动，可能无法领取红包。\n\n2.你的好友必须是从未注册过经喜app的新用户，新用户下载经喜app，注册并填写邀请码，成功加入门店后并且名片审核通过后视作邀请成功。（注：若通过门店编码加入门店，必须上传经纪人名片）。\n\n3.邀请成功后，经喜app将会直接给你发放现金奖励，你可在“分享有奖”—“我的邀请”或“我的钱包”—“钱包明细”中查看。\n\n4.如发现恶意套取现金奖励行为，经喜将有权根据情节严重程度采取相关措施：包括不限于不发放奖励、冻结所获得奖励、停止分享有奖功能、依法追究法律责任。\n\n活动的最终解释权归运营方所有，本活动和商品内容与设备生产商Apple Inc无关。";
    labelTwo.numberOfLines = 0;
    [view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).offset(18);
        make.width.offset(view.fWidth - 40);
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"closes"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeGkCover) forControlEvents:UIControlEventTouchUpInside];
    [ruleView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_bottom).offset(23);
        make.width.offset(30);
        make.height.offset(30);
    }];
}
#pragma mark -邀请规则
-(void)shareRule{
    [GKCover translucentWindowCenterCoverContent:_ruleView animated:YES notClick:NO];
}

#pragma mark -分享弹框
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
    [WXButton addTarget:self action:@selector(WYShare) forControlEvents:UIControlEventTouchUpInside];
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
    [friendsButton addTarget:self action:@selector(WYFriendsButton) forControlEvents:UIControlEventTouchUpInside];
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
//关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
//分享到微信
-(void)WYShare{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = [_data valueForKey:@"title"];
    mediaMsg.description = [_data valueForKey:@"describe"];
    UIImage *image =  [self handleImageWithURLStr:[_data valueForKey:@"imageUrl"]];
    [mediaMsg setThumbImage:image];
    //分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [_data valueForKey:@"url"];
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
-(void)WYFriendsButton{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    
    mediaMsg.title = [_data valueForKey:@"title"];
    mediaMsg.description = [_data valueForKey:@"describe"];
    
    UIImage *image =  [self handleImageWithURLStr:[_data valueForKey:@"imageUrl"]];
    [mediaMsg setThumbImage:image];
    
    //2.分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [_data valueForKey:@"url"];
    mediaMsg.mediaObject = webpageObject;
    
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(朋友圈)
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
