//
//  WZSetPersonalInforMationController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSetPersonalInforMationController.h"
#import "UIView+Frame.h"
#import "WZSetInfertionView.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "NSString+LCExtension.h"
@interface WZSetPersonalInforMationController ()

@property(nonatomic,strong)NSDictionary *loginItem;

@property(nonatomic,strong)WZSetInfertionView *infoView;
@end

@implementation WZSetPersonalInforMationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"个人信息";
    //创建view
    [self setScrollView];
     [self loadData];
}
//请求数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *userId = [ user objectForKey:@"userId"];
    NSString *username = [ user objectForKey:@"username"];

    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    
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
            [self setDatas];
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
        if (error.code == -1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
}
//设置数据
-(void)setDatas{
    
    NSString *portrait = [_loginItem valueForKey:@"portrait"];
    _infoView.url = portrait;
    NSURL *url =[NSURL URLWithString:portrait];
    
    //头像
    [_infoView.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head"]];
    //姓名
    _infoView.name.text = [_loginItem valueForKey:@"realname"];
    //门店位置
    _infoView.cityName = [_loginItem valueForKey:@"cityName"];
    //门店地址
    _infoView.storeAddr = [_loginItem valueForKey:@"addr"];
    //经纪人认证状态
    _infoView.realtorStatus = [_loginItem valueForKey:@"realtorStatus"];
    //门店负责人
    _infoView.dutyFlag = [_loginItem valueForKey:@"dutyFlag"];
    //性别
    NSString *sex = [_loginItem valueForKey:@"sex"];
    if ([sex isEqual:@"1"]) {
        _infoView.sex.text = @"男";
    }else if([sex isEqual:@"2"]){
        _infoView.sex.text = @"女";
    }else{
        _infoView.sex.text = @"男";
    }
    //出生年月
     NSString *birthDate = [_loginItem valueForKey:@"birthday"];
    if (birthDate) {
        _infoView.birthDate.text = birthDate;
    }
    //籍贯
     NSString *birthAddress = [_loginItem valueForKey:@"navitePlace"];
    if (birthAddress){
        _infoView.birthAddress.text = birthAddress;
    }
    //从业时间
     NSString *employmentTime = [_loginItem valueForKey:@"startWorkTime"];
    if (employmentTime){
        _infoView.employmentTime.text = employmentTime;
    }
    //入职时间
     NSString *entryTime = [_loginItem valueForKey:@"hiredate"];
    if (entryTime){
        _infoView.entryTime.text = entryTime;
    }
}
-(void)setScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    WZSetInfertionView *view = [WZSetInfertionView setInforation];
    view.frame = scrollView.bounds;
    [scrollView addSubview:view];
     _infoView = view;
    scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight-45);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
   
}
@end
