//
//  WZRewardWalletController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/20.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import "WZNavigationController.h"
#import "WZVipServiceController.h"
#import "WZRewardWalletController.h"
#import "WZRewardsDetilsController.h"
@interface WZRewardWalletController ()
//余额
@property(nonatomic,strong)UILabel *moneys;
//总金额
@property(nonatomic,strong)NSString *price;
@end

@implementation WZRewardWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.navigationItem.title = @"悬赏账户";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(findDetailed) title:@"明细"];
    //创建内容
    [self createContent];
}

//请求数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/generalCapital/getGeneralCapital",HTTPURL];
    
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *amount = [data valueForKey:@"amount"];
            _price = amount;
            if(![amount isEqual:@""]||amount){
                _moneys.text = [NSString stringWithFormat:@"¥%@",amount];
            }
            
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
}
-(void)createContent{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"money"];
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+109);
    }];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"总金额";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    [self.view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(23);
        make.height.offset(17);
    }];
    UILabel *moneys = [[UILabel alloc] init];
    moneys.text = @"¥0.00";
    moneys.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:40];
    _moneys = moneys;
    [self.view addSubview:moneys];
    [moneys mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).offset(23);
        make.height.offset(40);
    }];
    UIButton *forWaryButton = [[UIButton alloc] init];
    [forWaryButton setTitle:@"发布悬赏" forState:UIControlStateNormal];
    [forWaryButton setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateNormal];
    forWaryButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    forWaryButton.backgroundColor = UIColorRBG(248, 248, 248);
    forWaryButton.layer.borderColor = UIColorRBG(221, 221, 221).CGColor;
    forWaryButton.layer.borderWidth = 1.0;
    forWaryButton.layer.cornerRadius = 22.0;
    forWaryButton.layer.masksToBounds = YES;
    [forWaryButton addTarget:self action:@selector(ReleaseRewardButtons) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forWaryButton];
    [forWaryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(moneys.mas_bottom).offset(78);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(44);
    }];
}
//查看明细
-(void)findDetailed{
    WZRewardsDetilsController *RewardsVC = [[WZRewardsDetilsController alloc] init];
    [self.navigationController pushViewController:RewardsVC animated:YES];
}
//发布悬赏
-(void)ReleaseRewardButtons{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    WZVipServiceController *vips = [[WZVipServiceController alloc] init];
    
    vips.url = [NSString stringWithFormat:@"%@/vip/publicaward.html?uuid=%@",HTTPH5,uuid];
    
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:vips];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
@end
