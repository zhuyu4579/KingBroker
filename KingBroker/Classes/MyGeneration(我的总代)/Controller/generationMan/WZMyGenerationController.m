//
//  WZMyGenerationController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZRewardWalletController.h"
#import "WZNavigationController.h"
#import "WZVipServiceController.h"
#import "WZAddHousesController.h"
#import "WZHouseManagesController.h"
#import "WZMyGenerationController.h"
#import "WZJoinGenerationController.h"
#import "WZCompanyInfoController.h"
@interface WZMyGenerationController ()
@property(nonatomic,strong)UIView *viewNo;
@end

@implementation WZMyGenerationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.title = @"我是总代";
    
    //创建view
    [self createView];
}
#pragma mark -创建view
-(void)createView{
    UIView *viewOne = [[UIView alloc] init];
    [self.view addSubview:viewOne];
    [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+57);
        make.width.offset(self.view.fWidth);
        make.height.offset(50);
    }];
    UIView *companyInformation = [self createViewClass:@selector(companyInformations) image:[UIImage imageNamed:@"zd_icon1"] title:@"公司信息" fY:0 size:CGSizeMake(19, 20)];
    [viewOne addSubview:companyInformation];
    
    UIView *viewTwo = [[UIView alloc] init];
    [self.view addSubview:viewTwo];
    [viewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(viewOne.mas_bottom).offset(10);
        make.width.offset(self.view.fWidth);
        make.height.offset(101);
    }];
    
    UIView *memberService = [self createViewClass:@selector(memberServices) image:[UIImage imageNamed:@"zd_icon2"] title:@"会员服务" fY:0 size:CGSizeMake(20, 16)];
    [viewTwo addSubview:memberService];
    UIView *totalWallet = [self createViewClass:@selector(totalWallets) image:[UIImage imageNamed:@"zd_icon3"] title:@"悬赏账户" fY:51 size:CGSizeMake(19, 20)];
    [viewTwo addSubview:totalWallet];
    
    UIView *viewThree = [[UIView alloc] init];
    [self.view addSubview:viewThree];
    [viewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(viewTwo.mas_bottom).offset(10);
        make.width.offset(self.view.fWidth);
        make.height.offset(101);
    }];
    
    UIView *houseManage = [self createViewClass:@selector(houseManages) image:[UIImage imageNamed:@"zd_icon4"] title:@"楼盘管理" fY:0 size:CGSizeMake(18, 20)];
    [viewThree addSubview:houseManage];
    UIView *addHouse = [self createViewClass:@selector(addHouses) image:[UIImage imageNamed:@"zd_icon5"] title:@"添加楼盘" fY:51 size:CGSizeMake(17, 20)];
    [viewThree addSubview:addHouse];
    
    UIView *viewFour = [[UIView alloc] init];
    [self.view addSubview:viewFour];
    [viewFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(viewThree.mas_bottom).offset(10);
        make.width.offset(self.view.fWidth);
        make.height.offset(50);
    }];
    UIView *releaseReward = [self createViewClass:@selector(releaseReward) image:[UIImage imageNamed:@"zd_icon6"] title:@"我的悬赏" fY:0 size:CGSizeMake(17, 22)];
    [viewFour addSubview:releaseReward];
    
    [self joinGeneration];
}
//创建加入总代
-(void)joinGeneration{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = self.view.frame;
    [view setHidden:YES];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"zd_WDZDK"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(160);
        make.width.offset(181);
        make.height.offset(150);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"太低调了，连个总代都没有";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(29);
    }];
    UIButton *joinGeneration = [[UIButton alloc] init];
    joinGeneration.backgroundColor = UIColorRBG(255, 224, 0);
    [joinGeneration setTitle:@"我是总代" forState:UIControlStateNormal];
    [joinGeneration setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    joinGeneration.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    joinGeneration.layer.cornerRadius = 22;
    joinGeneration.layer.masksToBounds = YES;
    [joinGeneration addTarget:self action:@selector(joinGenerations) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:joinGeneration];
    [joinGeneration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(89);
        make.width.offset(215);
        make.height.offset(44);
    }];
}
#pragma mark -创建分类
-(UIView *)createViewClass:(SEL)sel image:(UIImage *)image title:(NSString *)title fY:(CGFloat)fY size:(CGSize)size{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, fY, self.view.fWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageOne = [[UIImageView alloc] init];
    imageOne.image = image;
    [view addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(17);
        make.top.equalTo(view.mas_top).offset((50-size.height)/2.0);
        make.width.offset(size.width);
        make.height.offset(size.height);
    }];
    UILabel *titles = [[UILabel alloc] init];
    titles.text = title;
    titles.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    titles.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:titles];
    [titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(55);
        make.top.equalTo(view.mas_top).offset(18);
        make.height.offset(14);
    }];
    UIImageView *imageTwo = [[UIImageView alloc] init];
    imageTwo.image = [UIImage imageNamed:@"zd_more"];
    [view addSubview:imageTwo];
    [imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset(18);
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
#pragma mark -加入总代
-(void)joinGenerations{
    WZJoinGenerationController *joinGen = [[WZJoinGenerationController alloc] init];
    [self.navigationController pushViewController:joinGen animated:YES];
}

#pragma mark -公司信息
-(void)companyInformations{
    WZCompanyInfoController *houseManage = [[WZCompanyInfoController alloc] init];
    [self.navigationController pushViewController:houseManage animated:YES];
}
#pragma mark -会员服务
-(void)memberServices{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
   
    WZVipServiceController *vips = [[WZVipServiceController alloc] init];
    
    vips.url = [NSString stringWithFormat:@"%@/vip/index.html?uuid=%@",HTTPH5,uuid];
    
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:vips];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark -悬赏账户
-(void)totalWallets{
    WZRewardWalletController *RewardWallet = [[WZRewardWalletController alloc] init];
    [self.navigationController pushViewController:RewardWallet animated:YES];
}
#pragma mark -楼盘管理
-(void)houseManages{
    WZHouseManagesController *houseManage = [[WZHouseManagesController alloc] init];
    [self.navigationController pushViewController:houseManage animated:YES];
}
#pragma mark -添加楼盘
-(void)addHouses{
    WZAddHousesController *houseManage = [[WZAddHousesController alloc] init];
    [self.navigationController pushViewController:houseManage animated:YES];
}
#pragma mark -我的悬赏
-(void)releaseReward{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    WZVipServiceController *vips = [[WZVipServiceController alloc] init];

    vips.url = [NSString stringWithFormat:@"%@/vip/publicbymyself.html?uuid=%@",HTTPH5,uuid];
    
    //WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:vips];
    //[self.navigationController presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vips animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *companyFlag = [ user objectForKey:@"companyFlag"];
    if ([companyFlag isEqual:@"1"]) {
        [_viewNo setHidden:YES];
    }else{
        [_viewNo setHidden:NO];
    }
}

@end
