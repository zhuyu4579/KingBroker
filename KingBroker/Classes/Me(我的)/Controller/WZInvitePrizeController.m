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
#import "UIImage+Image.h"
#import "CCPScrollView.h"
#import <WXApiObject.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <WebKit/WebKit.h>
#import <UIImageView+WebCache.h>
#import "WZLoadDateSeviceOne.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import "WZInvitePrizeController.h"
#import "UIButton+WZEnlargeTouchAre.h"
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
@property(nonatomic,strong)NSString *codes;
@end

@implementation WZInvitePrizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建控件
    [self setControl];
    [self shareRuleTask];
    [self shareTasks];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_scrollView removeTimer];
    [_scrollView removeFromSuperview];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
    [self loadCode];
}

#pragma mark -点击事件
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)copyInvitation{
    [SVProgressHUD showInfoWithStatus:@"复制成功"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [_data valueForKey:@"username"];
}
#pragma mark -请求数据
-(void)loadData{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            [self setLunNews:[data valueForKey:@"infos"]];
            _num.text = [data valueForKey:@"countNum"];
            _money.text = [data valueForKey:@"countPrice"];
            _inviteCode.text = [NSString stringWithFormat:@"我的邀请码:%@",[data valueForKey:@"username"]];
            NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
            dicty[@"url"] = [data valueForKey:@"url"];
            dicty[@"title"] = [data valueForKey:@"title"];
            dicty[@"describe"] = [data valueForKey:@"describe"];
            dicty[@"imageUrl"] = [data valueForKey:@"imageUrl"];
            _data = dicty;
            
        }else{
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            if ([code isEqual:@"401"]) {
                [NSString isCode:self.navigationController code:code];
            }
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/userRelation/userRelationInfo"];
   
}
//二维码
-(void)loadCode{
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne getUserInfosSuccess:^(NSDictionary *dic) {
        NSString *code = [dic valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [dic valueForKey:@"data"];
            _codes = [data valueForKey:@"url"];
        }
    } andFail:^(NSString *str) {
        
    } parament:paraments URL:@"/sysUser/facetofaceQrcode"];
}
#pragma mark - 邀请有奖
-(void)setControl{
    CGFloat n  = SCREEN_WIDTH/375.0;
    //背景图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-69*n);
    imageView.image = [UIImage imageNamed:@"yq_background"];
    [self.view addSubview:imageView];
    
    UIImageView *inviteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.fY+imageView.fHeight, self.view.fWidth, 69*n)];
    inviteImageView.image = [UIImage imageNamed:@"yq_fxbj"];
    [self.view addSubview:inviteImageView];
   
    
    //返回按钮
    UIButton *backs = [[UIButton alloc] initWithFrame:CGRectMake(21, kApplicationStatusBarHeight+13, 20, 16)];
    [backs setBackgroundImage:[UIImage imageNamed:@"yq_back"] forState:UIControlStateNormal];
    [backs addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backs setEnlargeEdge:44];
    [self.view addSubview:backs];
    //邀请规则
    UIButton *intiveRules = [[UIButton alloc] init];
    [intiveRules addTarget:self action:@selector(inviteRules) forControlEvents:UIControlEventTouchUpInside];
    [intiveRules setBackgroundImage:[UIImage imageNamed:@"yq_gz"] forState:UIControlStateNormal];
    [intiveRules setEnlargeEdge:40];
    [self.view addSubview:intiveRules];
    [intiveRules mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(178);
        make.width.offset(26);
        make.height.offset(80);
    }];
    //内容view
    UIView *viewOne = [[UIView alloc] init];
    [self.view addSubview:viewOne];
    [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(inviteImageView.mas_top);
        make.width.offset(self.view.fWidth);
        make.height.offset(200);
    }];
    //创建滚动动态
    UIView *lunView =[[UIView alloc] init];
    _lunView = lunView;
    [self.view addSubview:lunView];
    [lunView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(viewOne.mas_top);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(22);
    }];
    
    UILabel *titleLabe = [[UILabel alloc] init];
    titleLabe.text = @"受邀用户注册并填写你的邀请码，成功\n加入门店并且名片审核通过后，你就获得现金奖励";
    titleLabe.textColor = UIColorRBG(255, 212, 63);
    titleLabe.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
    titleLabe.textAlignment = NSTextAlignmentCenter;
    titleLabe.numberOfLines = 0;
    [viewOne addSubview:titleLabe];
    [titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(viewOne.mas_top).offset(10);
    }];
    
    //邀请按钮
    UIButton *inviteButton = [[UIButton alloc] init];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 220, 38);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[UIColorRBG(250, 203, 38) CGColor],(id)[UIColorRBG(247, 140, 40) CGColor]]];//渐变数组
    [inviteButton.layer addSublayer:gradientLayer];
    inviteButton.layer.cornerRadius = 3.0;
    inviteButton.layer.masksToBounds = YES;
    [inviteButton setTitle:@"立即邀请好友" forState:UIControlStateNormal];
    inviteButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [inviteButton setTitleColor:UIColorRBG(206, 0, 0) forState:UIControlStateNormal];
    [inviteButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:inviteButton];
    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(titleLabe.mas_bottom).offset(12);
        make.width.offset(220);
        make.height.offset(38);
    }];
   
    UILabel *inviteCode = [[UILabel alloc] init];
    inviteCode.textColor = UIColorRBG(241, 215, 215);
    inviteCode.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
    _inviteCode = inviteCode;
    [viewOne addSubview:inviteCode];
    [inviteCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX).offset(-30);
        make.top.equalTo(inviteButton.mas_bottom).offset(16);
        make.height.offset(10);
    }];
   
    UIButton *copyButton = [[UIButton alloc] init];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size: 10];
    [copyButton addTarget:self action:@selector(copyInvitation) forControlEvents:UIControlEventTouchUpInside];
    [copyButton setBackgroundImage:[UIImage imageNamed:@"yq_copy"] forState:UIControlStateNormal];
    [copyButton setEnlargeEdge:13];
    [viewOne addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inviteCode.mas_right).offset(12);
        make.top.equalTo(inviteButton.mas_bottom).offset(13);
        make.width.offset(35);
        make.height.offset(17);
    }];
    //邀请战绩
    UILabel *recordTitle = [[UILabel alloc] init];
    recordTitle.text = @"我的邀请战绩";
    recordTitle.textColor = UIColorRBG(255, 212, 63);
    recordTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [viewOne addSubview:recordTitle];
    [recordTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(copyButton.mas_bottom).offset(15);
        make.height.offset(14);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left);
        make.top.equalTo(recordTitle.mas_bottom);
        make.height.offset(58);
        make.width.offset((self.view.fWidth-1)/2.0);
    }];
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"0";
    numLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    numLabel.textColor = UIColorRBG(255, 212, 63);
    _num = numLabel;
    [leftView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView.mas_centerX);
        make.top.equalTo(leftView.mas_top).offset(14);
        make.height.offset(10);
    }];
    UILabel *numLabels = [[UILabel alloc] init];
    numLabels.text = @"共邀请好友";
    numLabels.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    numLabels.textColor = UIColorRBG(255, 212, 63);
    [leftView addSubview:numLabels];
    [numLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView.mas_centerX);
        make.top.equalTo(numLabel.mas_bottom).offset(10);
        make.height.offset(11);
    }];
    
    UIView *rightView = [[UIView alloc] init];
    [self.view addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right);
        make.top.equalTo(recordTitle.mas_bottom);
        make.height.offset(58);
        make.width.offset((self.view.fWidth-1)/2.0);
    }];
    UILabel *money = [[UILabel alloc] init];
    money.text = @"0.00";
    money.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    money.textColor = UIColorRBG(255, 212, 63);
    _money = money;
    [rightView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView.mas_centerX);
        make.top.equalTo(rightView.mas_top).offset(14);
        make.height.offset(10);
    }];
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"获得现金（元）";
    moneyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    moneyLabel.textColor = UIColorRBG(255, 212, 63);
    [rightView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView.mas_centerX);
        make.top.equalTo(money.mas_bottom).offset(10);
        make.height.offset(11);
    }];
    //分享按钮
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.fY+imageView.fHeight, self.view.fWidth, 69*n)];
    [self.view addSubview:viewTwo];
    
    UIView *buttonViewOne = [self createShareView:CGRectMake(0, 0, self.view.fWidth/3.0, 69*n) image:[UIImage imageNamed:@"wewhat"] title:@"微信好友" action:@selector(WYShare)];
    [viewTwo addSubview:buttonViewOne];
    UIView *buttonViewTwo = [self createShareView:CGRectMake(self.view.fWidth/3.0, 0, self.view.fWidth/3.0, 69*n) image:[UIImage imageNamed:@"circle-of-friend"] title:@"微信朋友圈" action:@selector(WYFriendsButton)];
    [viewTwo addSubview:buttonViewTwo];
    UIView *buttonViewThree = [self createShareView:CGRectMake(self.view.fWidth/3.0*2, 0, self.view.fWidth/3.0, 69*n) image:[UIImage imageNamed:@"yq_ewm"] title:@"面对面邀请" action:@selector(shareRule)];
    [viewTwo addSubview:buttonViewThree];
}
#pragma mark -创建消息轮播
-(void)setLunNews:(NSArray *)array{
    CCPScrollView *ccpView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth-30, 22)];
    
    ccpView.titleArray = array;
    
    ccpView.titleFont = 12;
    
    ccpView.titleColor = [UIColor whiteColor];
    
    ccpView.BGColor = [UIColor clearColor];
    
    _scrollView = ccpView;
    [_lunView addSubview:ccpView];
    
}
#pragma mark -创建分享按钮view
-(UIView *)createShareView:(CGRect)rect image:(UIImage *)image title:(NSString *)str action:(SEL)action{
    CGFloat n  = SCREEN_WIDTH/375.0;
    UIView *view = [[UIView alloc] init];
    view.frame = rect;
    UIImageView *imageViews = [[UIImageView alloc] init];
    imageViews.image = image;
    [view addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(12*n);
        make.height.offset(34*n);
        make.width.offset(34*n);
    }];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.textColor = UIColorRBG(255, 212, 63);
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
    labelOne.text = str;
    [view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageViews.mas_bottom).offset(8*n);
        make.height.offset(10);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(view.fWidth);
        make.height.offset(view.fHeight);
    }];
    return view;
}
#pragma mark -面对面邀请view
-(void)shareRuleTask{
    UIView *ruleView = [[UIView alloc] init];
    ruleView.fSize = CGSizeMake(342, 460);
    _ruleView = ruleView;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"yq_ewmtc"];
    [ruleView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ruleView.mas_left);
        make.top.equalTo(ruleView.mas_top);
        make.width.offset(ruleView.fWidth);
        make.height.offset(ruleView.fHeight);
    }];
    
    UIImageView *imageViews = [[UIImageView alloc] init];
    [imageViews sd_setImageWithURL:[NSURL URLWithString:_codes]];
    [ruleView addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ruleView.mas_centerX);
        make.top.equalTo(ruleView.mas_top).offset(147);
        make.width.offset(210);
        make.height.offset(210);
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"closes"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeGkCover) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setEnlargeEdge:40];
    [ruleView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ruleView.mas_right).offset(-8);
        make.top.equalTo(ruleView.mas_top).offset(8);
        make.width.offset(20);
        make.height.offset(20);
    }];
}
#pragma mark -关闭邀请二维码
-(void)shareRule{
    [GKCover translucentWindowCenterCoverContent:_ruleView animated:YES notClick:NO];
}
-(void)inviteRules{
    UIView *ruleView = [[UIView alloc] init];
    ruleView.fSize = CGSizeMake(295, 510);
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"yq_gz2"];
    [ruleView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ruleView.mas_left);
        make.top.equalTo(ruleView.mas_top);
        make.width.offset(ruleView.fWidth);
        make.height.offset(450);
    }];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"closes"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeGkCover) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setEnlargeEdge:40];
    [ruleView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ruleView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(23);
        make.width.offset(30);
        make.height.offset(30);
    }];
    [GKCover translucentWindowCenterCoverContent:ruleView animated:YES notClick:NO];
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
    UIImage *image =  [UIImage handleImageWithURLStr:[_data valueForKey:@"imageUrl"]];
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
    
    UIImage *image =  [UIImage handleImageWithURLStr:[_data valueForKey:@"imageUrl"]];
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



@end
