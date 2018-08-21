//
//  WZablumController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//


#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZablumController.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZablumController ()
@property(nonatomic,strong)NSString *appVersion;
@property(nonatomic,strong)NSString *newsVersion;
@end

@implementation WZablumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"关于我们";
    //创建内容
    [self createNext];
}
//创建内容
-(void)createNext{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *appVersion = [user objectForKey:@"appVersion"];
    _appVersion = appVersion;
    NSString *newVersion = [user objectForKey:@"newVersion"];
    _newsVersion = newVersion;
    //创建公司logo
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((self.view.fWidth-77)/2.0, 105, 77, 77);
    imageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:imageView];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"经服";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    labelOne.textColor =UIColorRBG(68, 68, 68);
    [self.view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.height.offset(18);
    }];
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text =[NSString stringWithFormat:@"当前版本%@",_appVersion];
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelTwo.textColor =UIColorRBG(68, 68, 68);
    [self.view addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).with.offset(10);
        make.height.offset(13);
    }];
    UILabel *labelThree = [[UILabel alloc] init];
    labelThree.text = @"经服APP是全国首个经纪人乐享平台，拥有全国丰富的最新楼盘资源。随时报备客户，带看上客，畅享成交。助力房产经纪行业，让您轻松赚大钱。";
    labelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    labelThree.textColor =UIColorRBG(153, 153, 153);
    labelThree.numberOfLines = 0;
    labelThree.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelThree];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTwo.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"版本更新" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = YES;
    button.backgroundColor = UIColorRBG(3, 133, 219);
    [button addTarget:self action:@selector(versionUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelThree.mas_bottom).with.offset(92);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.offset(44);
        make.width.offset(240);
    }];
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.textColor = UIColorRBG(68, 68, 68);
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
    [telphone setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
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
@end
