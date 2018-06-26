//
//  WZApplyStorePersonController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZApplyStorePersonController.h"
#import "WZAuthenticationController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "GKCover.h"
#import "WZAlertView.h"
#import <AFNetworking.h>
#import "ZDAlertView.h"
#import "NSString+LCExtension.h"
@interface WZApplyStorePersonController ()
//名片
@property(nonatomic,strong)UIImage *image;
//合同
@property(nonatomic,strong)UIImage *images;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIImageView *imageViews;

@end

@implementation WZApplyStorePersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"申请门店负责人";
    //创建页面
    if([_idCardstatus isEqual:@"2"]){
        //已经实名认证
        [self setCard];
    }else{
        //未实名认证
        [self setIdCard];
    }
}
//申请门店负责人
-(void)setCard{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+54, self.view.fWidth, 446)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"上传资料";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    label.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(15);
    }];
    //上传名片正面
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"applyfor_2"];
    _imageView = imageView;
    //给照片view绑定点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [imageView addGestureRecognizer:tapGesture];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.top.equalTo(label.mas_bottom).offset(43);
        make.width.offset(225);
        make.height.offset(140);
    }];
    //上传营业执照正面
    UIImageView *imageViews = [[UIImageView alloc] init];
    imageViews.image = [UIImage imageNamed:@"applyfor"];
    _imageViews = imageViews;
     UITapGestureRecognizer *tapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImages)];
    [imageViews addGestureRecognizer:tapGestures];
    imageViews.userInteractionEnabled = YES;
    [view addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.top.equalTo(imageView.mas_bottom).offset(46);
        make.width.offset(225);
        make.height.offset(140);
    }];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    [button setTitle:@"提交审核" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(subButton:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-24);
        make.height.offset(44);
    }];
}

-(void)setIdCard{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"empty"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+44+103);
        make.width.offset(129);
        make.height.offset(86);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"你还没有完成实名认证，实名认证后\n才能申请门店负责人~";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(29);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"实名认证" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    button.layer.cornerRadius = 4.0;
    [button addTarget:self action:@selector(idCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(140);
        make.width.offset(215);
        make.height.offset(49);
    }];
}
//上传名片
-(void)clickImage{
    WZAlertView *redView = [WZAlertView new];
    redView.imageName = @"sketchmap";
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [_imageView setImage:image];
        _image = image;
    };
}
//上传营业执照
-(void)clickImages{
    WZAlertView *redView = [WZAlertView new];
    redView.imageName = @"sketchmap";
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [_imageViews setImage:image];
        _images = image;
    };
}
//提交审核
-(void)subButton:(UIButton *)button{
    if (!_image) {
        [SVProgressHUD showInfoWithStatus:@"名片不能为空!"];
        return;
    }
    if (!_images) {
        [SVProgressHUD showInfoWithStatus:@"营业执照不能为空!"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [SVProgressHUD showWithStatus:@"提交中"];
    button.enabled = NO;
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/leaderAuthentication",URL];
    [mgr POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = [ZDAlertView imageProcessWithImage:_image];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        
        NSData *imageDatas = [ZDAlertView imageProcessWithImage:_images];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
        formatters.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileNames = [NSString stringWithFormat:@"%@.png",[formatters stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageDatas name:@"face" fileName:fileNames mimeType:@"image/png"];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        button.enabled = YES;
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            NSString *data = [responseObject valueForKey:@"data"];
            if (_statusBlock) {
                _statusBlock(data);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            [NSString isCode:self.navigationController code:code];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        button.enabled = YES;
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
//实名认证
-(void)idCard{
    WZAuthenticationController *authen = [[WZAuthenticationController alloc] init];
    [self.navigationController pushViewController:authen animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
