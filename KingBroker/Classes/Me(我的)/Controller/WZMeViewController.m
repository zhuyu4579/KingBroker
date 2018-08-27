//
//  WZMeViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZMeViewController.h"
#import "UIBarButtonItem+Item.h"
#import "WZSetTableController.h"
#import "WZLoginAndRegistarController.h"
#import "WZNavigationController.h"
#import "WZRegController.h"
#import "UIView+Frame.h"
#import "WZJionStoreAndStoreHeadController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZBoaringController.h"
#import "WZHousePageController.h"
#import "WZAuthenticationController.h"
#import "WZQuestionController.h"
#import "WZSetPersonalInforMationController.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <Masonry.h>
#import "WZSettingController.h"
#import "NSString+LCExtension.h"
#import "WZBelongedStoreController.h"
#import "WZForwardController.h"
@interface WZMeViewController ()
//主view
@property(nonatomic,strong)UIScrollView *scrollView;
//登录成功
@property(nonatomic,strong)UIView *loginSuccessView;
//登录的数据
@property(nonatomic,strong)NSDictionary *loginItem;
//头像
@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UIImageView *headImageViewTwo;
//名字
@property(nonatomic,strong)UILabel *name;
//性别
@property(nonatomic,strong)UIImageView *sexImage;
//门店名称
@property(nonatomic,strong)UILabel *storeName;
//uuid
@property(nonatomic,strong)NSString *uuid;
//加入门店状态栏
@property(nonatomic,assign)UIImageView *images;
//加入门店状态栏
@property(nonatomic,assign)UILabel *labels;
//加入门店状态栏
@property(nonatomic,assign)UIButton *joinButton;
//所属门店按钮
@property(nonatomic,assign)UIButton *boaldingButton;
//登录按钮
@property(nonatomic,assign)UIButton *loginButton;
//编辑按钮
@property(nonatomic,assign)UIButton *editButton;
@end

@implementation WZMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = UIColorRBG(248,247,242);
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    //创建区域控件
    [self setUpMeView];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(meRefresh) name:@"MeRefresh" object:nil];
}

//创建控件
-(void)setUpMeView{
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX,0, self.view.fWidth, self.view.fHeight-49-JF_BOTTOM_SPACE)];
    meScrollView.backgroundColor = UIColorRBG(248,247,242);
    meScrollView.bounces = NO;
    meScrollView.showsVerticalScrollIndicator = NO;
    meScrollView.showsHorizontalScrollIndicator = NO;
   
    [self.view addSubview:meScrollView];
    
    self.scrollView = meScrollView;
    //创建上半部分
    [self loginSuccess];
    //创建其他
    [self setViews];
   
}
//推送刷新
-(void)meRefresh{
    [self loadData];
    [self setloadData];
}
//获取数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *userId = [ user objectForKey:@"userId"];
    NSString *username = [ user objectForKey:@"username"];
     _uuid = uuid;
     if (![uuid isEqual:@""] && uuid) {
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"username"] = username;
        paraments[@"userId"] = userId;
        
        NSString *url = [NSString stringWithFormat:@"%@/sysUser/myInfo",HTTPURL];
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                _loginItem = [responseObject valueForKey:@"data"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[_loginItem valueForKey:@"realtorStatus"] forKey:@"realtorStatus"];
                [defaults setObject:[_loginItem valueForKey:@"idcardStatus"] forKey:@"idcardStatus"];
                [defaults setObject:[_loginItem valueForKey:@"storeId"] forKey:@"storeId"];
                [defaults setObject:[_loginItem valueForKey:@"cityId"] forKey:@"cityId"];
                [defaults setObject:[_loginItem valueForKey:@"commissionFag"] forKey:@"commissionFag"];
                [defaults setObject:[_loginItem valueForKey:@"realname"] forKey:@"realname"];
                [defaults setObject:[_loginItem valueForKey:@"name"] forKey:@"name"];
                [defaults setObject:[_loginItem valueForKey:@"invisibleLinkmanFlag"] forKey:@"invisibleLinkmanFlag"];
                //门店名称
                [defaults setObject:[_loginItem valueForKey:@"storeName"] forKey:@"storeName"];
                //门店编码
                [defaults setObject:[_loginItem valueForKey:@"storeCode"] forKey:@"storeCode"];
                //门店位置
                [defaults setObject:[_loginItem valueForKey:@"cityName"] forKey:@"cityName"];
                //门店地址
                [defaults setObject:[_loginItem valueForKey:@"addr"] forKey:@"addr"];
                //门店负责人
                [defaults setObject:[_loginItem valueForKey:@"dutyFlag"] forKey:@"dutyFlag"];
                [defaults synchronize];
                [self storeState];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                if ([code isEqual:@"401"]) {
                   [NSString isCode:self.navigationController code:code];
                    //更新指定item
                    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];;
                    item.badgeValue= nil;
                }
               
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            
        }];
    }else{
        [self nologins];
    }
    
}
//登录后判断加入门店状态
-(void)storeState{
    NSInteger state =[[_loginItem valueForKey:@"realtorStatus"] integerValue];
    _loginState = state;
    NSString *portrait = [_loginItem valueForKey:@"portrait"];
    NSURL *url =[NSURL URLWithString:portrait];
    //0是未加入门店
    [_headImageViewTwo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"xx_pic"]];
    [self logins];
    
    if (state == 0) {
        [_joinButton setTitle:@"点击加入门店" forState:UIControlStateNormal];
    }else if (state == 1) {
        _joinButton.enabled = NO;
        [_joinButton setTitle:@"加入门店审核中" forState:UIControlStateNormal];
    }else if(state == 2){
        //已加入门店
        _joinButton.enabled = NO;
         [_joinButton setTitle:[_loginItem valueForKey:@"storeName"] forState:UIControlStateNormal];
        [_boaldingButton setHidden:NO];
        _boaldingButton.enabled = YES;
    }else if(state == 3){
        _joinButton.enabled = YES;
        [_joinButton setTitle:@"审核失败，请重新加入" forState:UIControlStateNormal];
    }
    _name.text = [_loginItem valueForKey:@"realname"];
    
    NSString *sex = [_loginItem valueForKey:@"sex"];
    if ([sex isEqual:@"1"]) {
        _sexImage.image = [UIImage imageNamed:@"wd_man"];
    }else if([sex isEqual:@"2"]){
        _sexImage.image = [UIImage imageNamed:@"wd_icon2"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"wd_man"];;
    }
    
}

//登录入口
-(void)loginSuccess{
    
    UIView *loginSuccessView = [[UIView alloc] initWithFrame:CGRectMake(0, -kApplicationStatusBarHeight, self.scrollView.fWidth, 194+kApplicationStatusBarHeight)];
    loginSuccessView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:loginSuccessView];
    self.loginSuccessView = loginSuccessView;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = loginSuccessView.bounds;
    imageView.image = [UIImage imageNamed:@"background_4"];
    [loginSuccessView addSubview:imageView];
    //头像
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"xx_pic"];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [headImageView addGestureRecognizer:tapGesture];
    headImageView.layer.cornerRadius= 67/2.0;//裁成圆角
    headImageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    headImageView.layer.borderWidth = 2.0f;//边框宽度
    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    headImageView.userInteractionEnabled = YES;
    _headImageViewTwo  = headImageView;
    [loginSuccessView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginSuccessView.mas_left).offset(15);
    make.top.equalTo(loginSuccessView.mas_top).offset(kApplicationStatusBarHeight+41);
        make.height.offset(67);
        make.width.offset(67);
    }];
    //登录按钮
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _loginButton = loginButton;
    [loginSuccessView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(18);
        make.top.equalTo(loginSuccessView.mas_top).offset(kApplicationStatusBarHeight+58);
        make.height.offset(34);
        make.width.offset(60);
    }];
    //名称
    UILabel *labelName = [[UILabel alloc] init];
    _name = labelName;
    labelName.textColor = [UIColor whiteColor];
    labelName.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    [loginSuccessView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(14);
        make.top.equalTo(loginSuccessView.mas_top).offset(kApplicationStatusBarHeight+52);
        make.height.offset(12);
    }];
    
    //性别
    UIImageView *genderImageView = [[UIImageView alloc] init];
    _sexImage = genderImageView;
    [loginSuccessView addSubview:genderImageView];
    [genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_right).offset(12);
       make.top.equalTo(loginSuccessView.mas_top).offset(kApplicationStatusBarHeight+51);
        make.height.offset(13);
        make.width.offset(13);
    }];
    //加入门店按钮
    UIButton *joinButton = [[UIButton alloc] init];
    [joinButton setTitleColor:UIColorRBG(254, 201, 37) forState:UIControlStateNormal];
    joinButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    joinButton.backgroundColor = [UIColor whiteColor];
    joinButton.layer.cornerRadius = 12.5;
    joinButton.layer.masksToBounds = NO;
    joinButton.layer.shadowColor = UIColorRBG(192, 117, 0).CGColor;
    joinButton.layer.shadowOpacity = 0.12f;
    joinButton.layer.shadowRadius = 5.0f;
    joinButton.layer.shadowOffset = CGSizeMake(0, 7);
    _joinButton = joinButton;
    [joinButton addTarget:self action:@selector(JoinStore) forControlEvents:UIControlEventTouchUpInside];
    [loginSuccessView addSubview:joinButton];
    [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(9);
        make.top.equalTo(labelName.mas_bottom).offset(14);
        make.height.offset(25);
        make.width.offset(150);
    }];
    //已加入门店按钮
    UIButton *boaldingButton = [[UIButton alloc] init];
    [boaldingButton addTarget:self action:@selector(BelongedStore) forControlEvents:UIControlEventTouchUpInside];
    _boaldingButton = boaldingButton;
    [loginSuccessView addSubview:boaldingButton];
    [boaldingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(9);
        make.top.equalTo(labelName.mas_bottom).offset(14);
        make.height.offset(25);
        make.width.offset(150);
    }];
    //编辑按钮
    UIButton *editButton = [[UIButton alloc] init];
    [editButton setBackgroundImage:[UIImage imageNamed:@"wd_icon"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(clickImage) forControlEvents:UIControlEventTouchUpInside];
    [editButton setEnlargeEdge:44];
    _editButton = editButton;
    [loginSuccessView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginSuccessView.mas_right).offset(-15);
        make.top.equalTo(loginSuccessView.mas_top).offset(kApplicationStatusBarHeight+64);
        make.height.offset(19);
        make.width.offset(17);
    }];
}
#pragma mark - 未登录
-(void)nologins{
    _headImageViewTwo.image = [UIImage imageNamed:@"xx_pic"];
    [_loginButton setEnabled:YES];
    [_loginButton setHidden:NO];
    [_name setHidden:YES];
    [_sexImage setHidden:YES];
    [_joinButton setHidden:YES];
    [_joinButton setEnabled:NO];
    [_boaldingButton setHidden:YES];
    [_boaldingButton setEnabled:NO];
    [_editButton setEnabled:NO];
    [_editButton setHidden:YES];
}
#pragma mark - 已登录
-(void)logins{
    [_loginButton setEnabled:NO];
    [_loginButton setHidden:YES];
    [_name setHidden:NO];
    [_sexImage setHidden:NO];
    [_joinButton setHidden:NO];
    [_joinButton setEnabled:YES];
    [_boaldingButton setHidden:YES];
    [_boaldingButton setEnabled:NO];
    [_editButton setEnabled:YES];
    [_editButton setHidden:NO];
}
#pragma mark - 创建其他
-(void)setViews{
    UIView *viewOne = [[UIView alloc] init];
    [_scrollView addSubview:viewOne];
    [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(_loginSuccessView.mas_bottom).offset(-47);
        make.width.offset(_scrollView.fWidth-30);
        make.height.offset(117);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"background_wty"];
    imageView.layer.shadowColor = UIColorRBG(255, 185, 76).CGColor;
    imageView.layer.shadowOpacity = 0.05f;
    imageView.layer.shadowRadius = 20.0f;
    imageView.layer.shadowOffset = CGSizeMake(0, 1);
    [viewOne addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left);
        make.top.equalTo(viewOne.mas_top);
        make.width.offset(_scrollView.fWidth-30);
        make.height.offset(117);
    }];
    UIView *myBoardingView = [self createViewClass:@selector(myOrder) image:[UIImage imageNamed:@"wd_icon3"] title:@"我的订单" fY:0 size:CGSizeMake(18, 22)];
    [viewOne addSubview:myBoardingView];
     UIView *myWalletView = [self createViewClass:@selector(myWallet) image:[UIImage imageNamed:@"wd_icon4"] title:@"我的钱包" fY:58 size:CGSizeMake(19, 20)];
    [viewOne addSubview:myWalletView];
    
    UIView *viewTwo = [[UIView alloc] init];
    [_scrollView addSubview:viewTwo];
    [viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(viewOne.mas_bottom).offset(12);
        make.width.offset(_scrollView.fWidth-30);
        make.height.offset(176);
    }];
    UIImageView *imageViewTwo = [[UIImageView alloc] init];
    imageViewTwo.image = [UIImage imageNamed:@"background_wty2"];
    imageViewTwo.layer.shadowColor = UIColorRBG(255, 185, 76).CGColor;
    imageViewTwo.layer.shadowOpacity = 0.05f;
    imageViewTwo.layer.shadowRadius = 20.0f;
    imageViewTwo.layer.shadowOffset = CGSizeMake(0, 1);
    [viewTwo addSubview:imageViewTwo];
    [imageViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left);
        make.top.equalTo(viewTwo.mas_top);
        make.width.offset(_scrollView.fWidth-30);
        make.height.offset(176);
    }];
    UIView *myStoreView = [self createViewClass:@selector(myStore) image:[UIImage imageNamed:@"wd_icon5"] title:@"我的门店" fY:0 size:CGSizeMake(19, 18)];
    [viewTwo addSubview:myStoreView];
    UIView *myCollectionView = [self createViewClass:@selector(myCollection) image:[UIImage imageNamed:@"wd_icon6"] title:@"我的楼盘" fY:58 size:CGSizeMake(19, 19)];
    [viewTwo addSubview:myCollectionView];
    UIView *questionView = [self createViewClass:@selector(question) image:[UIImage imageNamed:@"wd_icon7"] title:@"问题小秘" fY:117 size:CGSizeMake(18, 22)];
    [viewTwo addSubview:questionView];
    
    UIView *viewThree = [[UIView alloc] init];
    viewThree.backgroundColor = [UIColor whiteColor];
    viewThree.layer.cornerRadius = 10;
    viewThree.layer.shadowColor = UIColorRBG(255, 185, 76).CGColor;
    viewThree.layer.shadowOpacity = 0.05f;
    viewThree.layer.shadowRadius = 20.0f;
    viewThree.layer.shadowOffset = CGSizeMake(0, 1);
    [_scrollView addSubview:viewThree];
    [viewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_bottom).offset(10);
        make.width.offset(_scrollView.fWidth-30);
        make.height.offset(58);
    }];
    
    UIView *mySettingView = [self createViewClass:@selector(setting) image:[UIImage imageNamed:@"wd_icon8"] title:@"设置" fY:0 size:CGSizeMake(19, 19)];
    [viewThree addSubview:mySettingView];
}
#pragma mark -创建分类
-(UIView *)createViewClass:(SEL)sel image:(UIImage *)image title:(NSString *)title fY:(CGFloat)fY size:(CGSize)size{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, fY, _scrollView.fWidth-30, 58)];
    UIImageView *imageOne = [[UIImageView alloc] init];
    imageOne.image = image;
    [view addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(12);
        make.top.equalTo(view.mas_top).offset(size.width);
        make.width.offset(size.width);
        make.height.offset(size.height);
    }];
    UILabel *titles = [[UILabel alloc] init];
    titles.text = title;
    titles.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    titles.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:titles];
    [titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageOne.mas_right).offset(14);
        make.top.equalTo(view.mas_top).offset(22);
        make.height.offset(14);
    }];
    UIImageView *imageTwo = [[UIImageView alloc] init];
    imageTwo.image = [UIImage imageNamed:@"bb_more_unfold"];
    [view addSubview:imageTwo];
    [imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-11);
        make.top.equalTo(view.mas_top).offset(22);
        make.width.offset(9);
        make.height.offset(15);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(view.fWidth);
        make.height.offset(view.fHeight);
    }];
    return view;
}

#pragma mark -跳转所属门店
-(void)BelongedStore{
    WZBelongedStoreController *boaring = [[WZBelongedStoreController alloc] init];
    [self.navigationController pushViewController:boaring animated:YES];
}
#pragma mark -跳转加入门店
-(void)JoinStore{
    WZJionStoreAndStoreHeadController *JionStore = [[WZJionStoreAndStoreHeadController alloc] init];
    JionStore.type = @"1";
    JionStore.jionType = @"1";
     WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}
#pragma mark -个人信息设置
-(void)clickImage{
    
    WZSetPersonalInforMationController *setPIVc = [[WZSetPersonalInforMationController alloc] init];
    [self.navigationController pushViewController:setPIVc animated:YES];
   
}
#pragma mark -我的订单
-(void)myOrder{
    if (_uuid&&![_uuid isEqual:@""]) {
        if(_loginState == 2){
            WZBoaringController *boarVc = [[WZBoaringController alloc] init];
            [self.navigationController pushViewController:boarVc animated:YES];
        }else if(_loginState == 1){
            [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"未加入门店" message:@"你还没有加入经纪门店，不能进行更多操作"  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不加入" style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                  }];
            UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"加入门店" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       [self JoinStore];
                                                                   }];
            [cancelAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
            [defaultAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
   
}
#pragma mark -我的收藏
-(void)myCollection{
    if (_uuid&&![_uuid isEqual:@""]) {
        WZHousePageController *houseVc = [[WZHousePageController alloc] init];
        houseVc.status = 1;
        [self.navigationController pushViewController:houseVc animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -我的钱包
-(void)myWallet{
    if (_uuid&&![_uuid isEqual:@""]) {
        WZForwardController *forward = [[WZForwardController alloc] init];
        [self.navigationController pushViewController:forward animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -我的门店
-(void)myStore{
    if (_uuid&&![_uuid isEqual:@""]) {
        WZBelongedStoreController *boaring = [[WZBelongedStoreController alloc] init];
        [self.navigationController pushViewController:boaring animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -问题小蜜
-(void)question{
    if (_uuid&&![_uuid isEqual:@""]) {
        WZQuestionController *quesVc = [[WZQuestionController alloc] init];
        [self.navigationController pushViewController:quesVc animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
    
}
#pragma mark -我的设置
-(void)setting{
    if (_uuid&&![_uuid isEqual:@""]) {
        WZSettingController *setting = [[WZSettingController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -跳转登录页面
-(void)login{
    WZLoginAndRegistarController *loginVc = [[WZLoginAndRegistarController alloc] init];
    loginVc.type = @"0";
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:loginVc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadData];
    [self setloadData];
}
#pragma mark -查询未读消息
-(void)setloadData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/userMessage/read/notreadCount",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            
            NSString *count = [data valueForKey:@"count"] ;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:count forKey:@"newCount"];
            [defaults synchronize];
           
            NSInteger counts = [count integerValue];
            
            UITabBarItem *item =[self.tabBarController.tabBar.items objectAtIndex:1];
            
            if (counts<100&&counts>0) {
                item.badgeValue= [NSString stringWithFormat:@"%ld",(long)counts];
            }else if(counts>=100){
                item.badgeValue= [NSString stringWithFormat:@"99+"];
            }else{
                item.badgeValue = nil;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
