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
@end

@implementation WZMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = UIColorRBG(242, 242, 242);
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
    //创建第一个登录状态view//1.未登录，2.已登录未加入门店，3.已登录已加入门店
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX,0, self.view.fWidth, self.view.fHeight-49-JF_BOTTOM_SPACE)];
    meScrollView.backgroundColor = [UIColor whiteColor];
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
        
    }
    
}
//登录后判断加入门店状态
-(void)storeState{
    NSInteger state =[[_loginItem valueForKey:@"realtorStatus"] integerValue];
    _loginState = state;
    NSString *portrait = [_loginItem valueForKey:@"portrait"];
    NSURL *url =[NSURL URLWithString:portrait];
    //0是未加入门店
    [self.loginSuccessView setHidden:NO];
    [_headImageViewTwo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"xx_pic"]];
    [_images setHidden:NO];
    [_labels setHidden:YES];
    _boaldingButton.enabled = NO;
    [_boaldingButton setHidden:YES];
    [_joinButton setHidden:YES];
    _joinButton.enabled = NO;
    [_storeName setHidden:NO];
    if (state == 0) {
        _images.image = [UIImage imageNamed:@"wd_icon"];
        _storeName.text = @"加入门店";
        [_labels setHidden:NO];
         _labels.text = @"点击加入";
        [_joinButton setHidden:NO];
        _joinButton.enabled = YES;
    }else if (state == 1) {
        _images.image = [UIImage imageNamed:@"wd_icon_4"];
         _storeName.text = @"加入门店审核中";
        _joinButton.enabled = NO;
    }else if(state == 2){
        //已加入门店
        _images.image = [UIImage imageNamed:@"wd_icon_5"];
        _joinButton.enabled = NO;
        _storeName.fWidth = 200;
        _storeName.text =[_loginItem valueForKey:@"storeName"];
        _storeName.textColor = UIColorRBG(3, 133, 219);
        [_boaldingButton setHidden:NO];
        _boaldingButton.enabled = YES;
    }else if(state == 3){
        _images.image = [UIImage imageNamed:@"wd_icon_3"];
         _storeName.text = @"审核失败";
        [_labels setHidden:NO];
        [_joinButton setHidden:NO];
        _labels.text = @"请重新加入";
        _joinButton.enabled = YES;
    }
    _name.text = [_loginItem valueForKey:@"realname"];
    NSString *sex = [_loginItem valueForKey:@"sex"];
    
    if ([sex isEqual:@"1"]) {
        _sexImage.image = [UIImage imageNamed:@"man"];
    }else if([sex isEqual:@"2"]){
        _sexImage.image = [UIImage imageNamed:@"women"];
        
    }else{
        _sexImage.image = [UIImage imageNamed:@"man"];;
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
    
    
    
    UILabel *labelName = [[UILabel alloc] init];
    _name = labelName;
    labelName.textColor = [UIColor whiteColor];
    labelName.textAlignment = NSTextAlignmentRight;
    labelName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [loginSuccessView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginSuccessView.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(17);
        make.height.offset(13);
    }];
    
    //性别
    UIImageView *genderImageView = [[UIImageView alloc] init];
    _sexImage = genderImageView;
    [loginSuccessView addSubview:genderImageView];
    [genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelName.mas_right).offset(5);
        make.top.equalTo(headImageView.mas_bottom).offset(15);
        make.height.offset(16);
        make.width.offset(16);
    }];
}

#pragma mark - 创建其他
-(void)setViews{
    
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
    if (_uuid) {
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
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
   
}
#pragma mark -我的收藏
-(void)myLable{
    if (_uuid) {
        WZHousePageController *houseVc = [[WZHousePageController alloc] init];
        houseVc.status = 1;
        [self.navigationController pushViewController:houseVc animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -我的钱包
-(void)myWallet{
    if (_uuid) {
        WZForwardController *forward = [[WZForwardController alloc] init];
        [self.navigationController pushViewController:forward animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -我的门店
-(void)myStore{
    if (_uuid) {
        WZBelongedStoreController *boaring = [[WZBelongedStoreController alloc] init];
        [self.navigationController pushViewController:boaring animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}
#pragma mark -问题小蜜
-(void)question{
    if (_uuid) {
        WZQuestionController *quesVc = [[WZQuestionController alloc] init];
        [self.navigationController pushViewController:quesVc animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
    
}
#pragma mark -我的设置
-(void)setting{
    if (_uuid) {
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
