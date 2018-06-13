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
#import "WZLoginController.h"
#import "WZNavigationController.h"
#import "WZRegController.h"
#import "UIView+Frame.h"
#import "WZJionStoreController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZBoaringController.h"
#import "WZHouseController.h"
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
@interface WZMeViewController ()
//主view
@property(nonatomic,strong)UIScrollView *scrollView;
//未登录view
@property(nonatomic,strong)UIView *noLoginView;
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
@property(nonatomic,assign)UIView *views;
//加入门店状态栏
@property(nonatomic,assign)UIImageView *images;
//加入门店状态栏
@property(nonatomic,assign)UILabel *labels;
//加入门店状态栏
@property(nonatomic,assign)UIButton *joinButton;
//所属门店按钮
@property(nonatomic,assign)UIButton *boaldingButton;

@end

@implementation WZMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    //设置导航条上内容
    [self setNavBar];
    //创建区域控件
    [self setUpMeView];
}
-(void)setNavBar{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
}
//创建控件
-(void)setUpMeView{
    //创建第一个登录状态view//1.未登录，2.已登录未加入门店，3.已登录已加入门店
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX, -kApplicationStatusBarHeight, self.view.fWidth, self.view.fHeight-49+kApplicationStatusBarHeight)];
    meScrollView.backgroundColor = [UIColor whiteColor];
    meScrollView.bounces = NO;
    meScrollView.showsVerticalScrollIndicator = NO;
    meScrollView.showsHorizontalScrollIndicator = NO;
    meScrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight-44);
    [self.view addSubview:meScrollView];
    self.scrollView = meScrollView;
    //创建未登录状态
    [self noLogins];
    //创建登录成功页面
    [self loginSuccess];
    //创建其他
    [self setViews];
    
}
//获取数据
-(void)loadData{
      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      NSString *uuid = [ user objectForKey:@"uuid"];
      NSString *userId = [ user objectForKey:@"userId"];
      NSString *username = [ user objectForKey:@"username"];
     _uuid = uuid;
     if (uuid) {
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
        NSString *url = [NSString stringWithFormat:@"%@/sysUser/myInfo",URL];
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
                [defaults synchronize];
                [self storeState];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [self hide];
                [self.noLoginView setHidden:NO];
                [_views setHidden:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }
        }];
    }else{
        [self hide];
        [self.noLoginView setHidden:NO];
        [_views setHidden:YES];
    }
    
    
}
//登录后判断加入门店状态
-(void)storeState{
    //隐藏所有
    [self hide];
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
         _labels.text = @"请上传相关证件";
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
        [_storeName setHidden:YES];
        [ _boaldingButton setTitle:[_loginItem valueForKey:@"storeName"] forState:UIControlStateNormal];
        [_boaldingButton setHidden:NO];
        _boaldingButton.enabled = YES;
    }else if(state == 3){
        _images.image = [UIImage imageNamed:@"wd_icon_3"];
         _storeName.text = @"加入门店审核失败";
        [_labels setHidden:NO];
        [_joinButton setHidden:NO];
        _labels.text = @"请重新上传";
        _joinButton.enabled = YES;
    }

    [_views setHidden:NO];
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
//未登录状态
-(void)noLogins{
    UIView *noLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.fWidth, 224)];
    noLoginView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:noLoginView];
    self.noLoginView = noLoginView;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = noLoginView.bounds;
    imageView.image = [UIImage imageNamed:@"background_2"];
    [noLoginView addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15,87,200,17);
    label.text = @"欢迎来到经服";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    label.textColor =[UIColor whiteColor];
    [noLoginView addSubview:label];
    //登录按钮
    UIButton *login = [[UIButton alloc] initWithFrame:CGRectMake(_noLoginView.fWidth/2-70, 147, 55, 25)];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    login.layer.borderWidth = 1;
    login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.layer.cornerRadius = 4.0;
    login.layer.masksToBounds = YES;
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [noLoginView addSubview:login];
    //登录按钮
    UIButton *regs = [[UIButton alloc] initWithFrame:CGRectMake(_noLoginView.fWidth/2+15, 147, 55, 25)];
    [regs setTitle:@"注册" forState:UIControlStateNormal];
    [regs setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    regs.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    regs.layer.borderWidth = 1;
    regs.layer.borderColor = [UIColor whiteColor].CGColor;
    regs.layer.cornerRadius = 4.0;
    regs.layer.masksToBounds = YES;
    [regs addTarget:self action:@selector(regs) forControlEvents:UIControlEventTouchUpInside];
    [noLoginView addSubview:regs];
}


//注册成功
-(void)loginSuccess{
    UIView *loginSuccessView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.fWidth, 224)];
    loginSuccessView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:loginSuccessView];
    self.loginSuccessView = loginSuccessView;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = loginSuccessView.bounds;
    imageView.image = [UIImage imageNamed:@"background_2"];
    [loginSuccessView addSubview:imageView];
    //头像
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake((SCREEN_WIDTH-75)/2, 70, 75, 75);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [headImageView addGestureRecognizer:tapGesture];
    headImageView.layer.cornerRadius= headImageView.frame.size.width/2;//裁成圆角
    headImageView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    headImageView.layer.borderWidth = 0.5f;//边框宽度
    headImageView.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    headImageView.userInteractionEnabled = YES;
    [loginSuccessView addSubview:headImageView];
     _headImageViewTwo  = headImageView;
    UILabel *labelName = [[UILabel alloc] init];
    _name = labelName;
    labelName.textColor = [UIColor whiteColor];
    labelName.textAlignment = NSTextAlignmentRight;
    [loginSuccessView addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginSuccessView.mas_centerX);
        make.top.equalTo(headImageView.mas_bottom).offset(15);
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
-(void)hide{
    [self.noLoginView setHidden:YES];
    [self.loginSuccessView setHidden:YES];
}
//创建其他
-(void)setViews{
 
    [self createButtonView:CGRectMake(0, 270, (SCREEN_WIDTH-1)/2, 115) image:@"order" imageSize:CGSizeMake(20, 30) target:self action:@selector(myOrder) title:@"我的订单"];
     [self createButtonView:CGRectMake(SCREEN_WIDTH/2, 270, (SCREEN_WIDTH-1)/2, 115) image:@"lable" imageSize:CGSizeMake(20, 31) target:self action:@selector(myLable) title:@"我的项目"];
     [self createButtonView:CGRectMake(0, 416, (SCREEN_WIDTH-1)/2, 115) image:@"question" imageSize:CGSizeMake(21, 30) target:self action:@selector(question) title:@"问题小秘"];
     [self createButtonView:CGRectMake(SCREEN_WIDTH/2, 416, (SCREEN_WIDTH-1)/2, 115) image:@"setting" imageSize:CGSizeMake(30, 30) target:self action:@selector(setting) title:@"我的设置"];
    //创建加入门店
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake((self.view.fWidth-318)/2.0, 200, 318, 50)];
    views.backgroundColor = [UIColor whiteColor];
    views.layer.shadowColor = [UIColor grayColor].CGColor;
    views.layer.shadowOpacity = 0.5f;
    views.layer.shadowRadius = 4.0f;
    views.layer.cornerRadius = 25.0;
    _views = views;
    [views setHidden:YES];
    [_scrollView addSubview:views];
    UIImageView *imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    _images = imageViews;
    [views addSubview:imageViews];
  
    UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(imageViews.fX+imageViews.fWidth, 18, 130, 15)];
    storeName.textColor = UIColorRBG(68, 68, 68);
    storeName.font = [UIFont systemFontOfSize:15];
    _storeName = storeName;
    [views addSubview:storeName];
    
    
    UILabel *labels = [[UILabel alloc] initWithFrame:CGRectMake(storeName.fX+storeName.fWidth, 19, 86, 12)];
    labels.textColor = UIColorRBG(102, 102, 102);
    labels.textAlignment = NSTextAlignmentRight;
    _labels = labels;
    labels.font = [UIFont systemFontOfSize:12];
    [views addSubview:labels];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(labels.fX+labels.fWidth+10, 16, 9, 17)];
    [button setBackgroundImage:[UIImage imageNamed:@"icon_more_unfold"] forState:UIControlStateNormal];
    [button setEnlargeEdgeWithTop:16 right:15 bottom:16 left:300];
    [button addTarget:self action:@selector(JoinStore) forControlEvents:UIControlEventTouchUpInside];
    _joinButton = button;
    [views addSubview:button];
    //跳转所属门点按钮
    UIButton *stores = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, views.fWidth-120, views.fHeight)];
    _boaldingButton = stores;
    stores.titleLabel.textAlignment = NSTextAlignmentLeft;
    [stores setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [stores addTarget:self action:@selector(BelongedStore) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:stores];
}
//跳转所属门店
-(void)BelongedStore{
    WZBelongedStoreController *boaring = [[WZBelongedStoreController alloc] init];
    boaring.storeCode = [_loginItem valueForKey:@"storeCode"];
    boaring.storeName =[_loginItem valueForKey:@"storeName"];
    boaring.cityName = [_loginItem valueForKey:@"cityName"];
    boaring.idcardStatus = [_loginItem valueForKey:@"idcardStatus"];
    boaring.realtorStatus = [_loginItem valueForKey:@"realtorStatus"];
    boaring.dutyFlag = [_loginItem valueForKey:@"dutyFlag"];
    boaring.cityAdder = [_loginItem valueForKey:@"addr"];
    [self.navigationController pushViewController:boaring animated:YES];
}
//跳转加入门店
-(void)JoinStore{
    WZJionStoreController *JionStore = [[WZJionStoreController alloc] init];
     WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    JionStore.registarBlock = ^(NSString *state) {
        _loginState = [state integerValue];
        [self storeState];
    };
}
//创建一个按钮控件
-(void)createButtonView:(CGRect)rect image:(NSString *)image imageSize:(CGSize)imageSize target:(id)target action:(SEL)action title:(NSString *)title{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = rect;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((view.fWidth-imageSize.width)/2, 30,imageSize.width , imageSize.height)];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setEnlargeEdgeWithTop:30 right:20 bottom:30 left:20];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *titles = [[UILabel alloc] init];
    titles.frame = CGRectMake(view.fWidth/2 - 90,view.fHeight-36,180,16);
    titles.text = title;
    titles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    titles.textColor = UIColorRBG(68, 68, 68);
    titles.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titles];
    [_scrollView addSubview:view];
}
//个人信息设置
-(void)clickImage{
    
    WZSetPersonalInforMationController *setPIVc = [[WZSetPersonalInforMationController alloc] init];
    [self.navigationController pushViewController:setPIVc animated:YES];
   
}
//我的订单
-(void)myOrder{
    if (_uuid) {
        if(_loginState == 2){
            WZBoaringController *boarVc = [[WZBoaringController alloc] init];
            [self.navigationController pushViewController:boarVc animated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"未加入门店"];
        }
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
   
}
//我的收藏
-(void)myLable{
    if (_uuid) {
        WZHouseController *houseVc = [[WZHouseController alloc] init];
        houseVc.navigationItem.title = @"我的项目";
        houseVc.type = @"1";
        [self.navigationController pushViewController:houseVc animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
}

//问题小蜜
-(void)question{
    if (_uuid) {
        WZQuestionController *quesVc = [[WZQuestionController alloc] init];
        [self.navigationController pushViewController:quesVc animated:YES];
    }else{
        [NSString isCode:self.navigationController code:@"401"];
    }
    
}
//我的设置
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
    WZLoginController *loginVc = [[WZLoginController alloc] init];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:loginVc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//注册页面
-(void)regs{
    WZRegController *ragVc = [[WZRegController alloc] init];
    [self.navigationController pushViewController:ragVc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadData];
}

@end
