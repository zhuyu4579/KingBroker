//
//  WZAuthenSuccessController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAuthenSuccessController.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "NSString+LCExtension.h"
@interface WZAuthenSuccessController ()
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *cardId;

@end

@implementation WZAuthenSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"实名认证";
    //设置内容
    [self setCard];
    //请求数据
    [self loadData];
}
//设置内容
-(void)setCard{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(124);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(150);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"card1"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(150);
    }];
    UIImageView *head = [[UIImageView alloc] init];
    _headImageView = head;
    head.layer.borderColor = UIColorRBG(84, 175, 246).CGColor;
    head.layer.borderWidth = 4.0;
    head.layer.cornerRadius = 4.0;
    head.layer.masksToBounds = YES;
    head.image = [UIImage imageNamed:@"bb_5_pic"];
    [view addSubview:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(29);
        make.width.offset(73);
        make.height.offset(73);
    }];
    UILabel *name = [[UILabel alloc] init];
    _name = name;
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    name.textColor = [UIColor whiteColor];
    [view addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(19);
        make.top.equalTo(view.mas_top).offset(48);
        make.height.offset(15);
    }];
    UILabel *cardId = [[UILabel alloc] init];
    _cardId = cardId;
    cardId.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    cardId.textColor = [UIColor whiteColor];
    [view addSubview:cardId];
    [cardId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head.mas_right).offset(19);
        make.top.equalTo(name.mas_bottom).offset(17);
        make.height.offset(15);
    }];
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
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    
    NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/checkrealnameAuthentication",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *url = [data valueForKey:@"url"];
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"bb_5_pic"]];
            NSString *name = [data valueForKey:@"realname"];
            NSString *realname = [name substringFromIndex:1];
            _name.text = [NSString stringWithFormat:@"*%@",realname];
            NSString *idCard = [data valueForKey:@"idCard"];
            NSString *card = [idCard substringToIndex:1];
            NSString *cardId = [idCard substringFromIndex:17];
            _cardId.text = [NSString stringWithFormat:@"%@****************%@",card,cardId];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
