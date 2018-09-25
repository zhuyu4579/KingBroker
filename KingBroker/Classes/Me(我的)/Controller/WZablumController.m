//
//  WZablumController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZablumController.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZablumController ()
@property(nonatomic,strong)NSString *appVersion;
@property(nonatomic,strong)NSString *newsVersion;
@end

@implementation WZablumController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建内容
    [self createNext];
}
#pragma mark -返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
   
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
//创建内容
-(void)createNext{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *appVersion = [user objectForKey:@"appVersion"];
    _appVersion = appVersion;
    NSString *newVersion = [user objectForKey:@"newVersion"];
    _newsVersion = newVersion;
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"wd_wmbag"];
    [self.view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(-kApplicationStatusBarHeight);
        make.height.offset(self.view.fHeight+kApplicationStatusBarHeight);
        make.width.offset(self.view.fWidth);
    }];
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight+13, 11, 20)];
    [backButton setImage:[UIImage imageNamed:@"wd_wmBack"] forState:UIControlStateNormal];
    [backButton setEnlargeEdge:44];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    //创建公司logo
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((self.view.fWidth-77)/2.0, 105, 85, 86);
    imageView.image = [UIImage imageNamed:@"jf_1_logowty"];
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 0.35f;
    imageView.layer.shadowRadius = 7.0f;
    [self.view addSubview:imageView];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"经服";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    labelOne.textColor = [UIColor whiteColor];
    [self.view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.height.offset(18);
    }];
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text =[NSString stringWithFormat:@"当前版本%@",_appVersion];
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelTwo.textColor = [UIColor whiteColor];
    [self.view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).with.offset(10);
        make.height.offset(13);
    }];
    UILabel *labelThree = [[UILabel alloc] init];
    labelThree.text = @"经服是中国领先的房地产服务平台，\n提供真实的房源。提供\n收藏、分享、报备客户、\n带客户上客等服务。更好的服务于经纪人和总代。";
    labelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    labelThree.textColor = [UIColor whiteColor];
    labelThree.numberOfLines = 0;
    labelThree.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelThree];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTwo.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(self.view.fWidth-30);
    }];
    
    UIButton *buttons = [[UIButton alloc] init];
    [buttons setTitle:@"版本更新" forState:UIControlStateNormal];
    [buttons setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    buttons.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    buttons.layer.cornerRadius = 22.0;
    buttons.layer.masksToBounds = YES;
    buttons.backgroundColor = UIColorRBG(255, 224, 0);
    [buttons addTarget:self action:@selector(versionUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttons];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelThree.mas_bottom).with.offset(92);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(44);
        make.width.offset(240);
    }];
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.textColor = [UIColor whiteColor];
    telphoneLabel.text = @"客服热线：";
    telphoneLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [self.view addSubview:telphoneLabel];
    [telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
        make.centerX.equalTo(self.view.mas_centerX).offset(-47);
        make.height.offset(12);
    }];
    UIButton *telphone = [[UIButton alloc] init];
    [telphone setTitle:@"0571-88841808" forState:UIControlStateNormal];
    [telphone setTitleColor:UIColorRBG(255, 192, 0) forState:UIControlStateNormal];
    telphone.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    [telphone setEnlargeEdge:44];
    [telphone addTarget:self action:@selector(telphone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
        make.left.equalTo(telphoneLabel.mas_right);
        make.height.offset(12);
        make.width.offset(93);
    }];

}

#pragma mark -版本更新
-(void)versionUpdate{
    UIApplication *application = [UIApplication sharedApplication];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *downAddress = [ user objectForKey:@"downAddress"];
    [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?mt=8",downAddress]]];
}
#pragma mark-客服电话
-(void)telphone:(UIButton *)button{
    NSString *phone = button.titleLabel.text;
    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
@end
