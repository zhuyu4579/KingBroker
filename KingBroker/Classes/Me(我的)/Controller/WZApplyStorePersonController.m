//
//  WZApplyStorePersonController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/12.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZApplyStorePersonController.h"
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
    
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.title = @"申请门店负责人";
    //创建页面
    [self setCard];
  
}
//申请门店负责人
-(void)setCard{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realname = [user objectForKey:@"realname"];
    NSString *storeName = [user objectForKey:@"storeName"];
    NSString *cityName = [user objectForKey:@"cityName"];
    NSString *addr = [user objectForKey:@"addr"];
    //信息view
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight+54, self.view.fWidth-30, 210)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0;
    [self.view addSubview:view];
    
    UIView *nameView = [self createView: @"名      字" contents:realname fY:0];
    [view addSubview:nameView];
    UIView *storeNameView = [self createView: @"门店名称" contents:storeName fY:49];
    [view addSubview:storeNameView];
    UIView *storeAddressView = [self createView: @"门店位置" contents:cityName fY:98];
    [view addSubview:storeAddressView];
    UIView *storeAddrView = [self createView: @"门店地址" contents:addr fY:148];
    [view addSubview:storeAddrView];
    
    UIView *viewTwo  = [[UIView alloc] initWithFrame:CGRectMake(15,view.fHeight+view.fY+7, self.view.fWidth-30, 200)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    viewTwo.layer.cornerRadius = 5.0;
    [self.view addSubview:viewTwo];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"上传资料";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    label.textColor = UIColorRBG(51, 51, 51);
    [viewTwo addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_top).offset(13);
        make.height.offset(16);
    }];
    
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor = UIColorRBG(238, 238, 238);
    [viewTwo addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(label.mas_bottom).offset(16);
        make.right.equalTo(viewTwo.mas_right).offset(-15);
        make.height.offset(1);
    }];
    //上传名片正面
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"camera_zm"];
    _imageView = imageView;
    //给照片view绑定点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [imageView addGestureRecognizer:tapGesture];
    imageView.userInteractionEnabled = YES;
    [viewTwo addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTwo.mas_centerX).offset(-38);
        make.top.equalTo(ineOne.mas_bottom).offset(30);
        make.width.offset(100);
        make.height.offset(100);
    }];
    //上传营业执照正面
    UIImageView *imageViews = [[UIImageView alloc] init];
    imageViews.image = [UIImage imageNamed:@"camera_yyzz"];
    _imageViews = imageViews;
     UITapGestureRecognizer *tapGestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImages)];
    [imageViews addGestureRecognizer:tapGestures];
    imageViews.userInteractionEnabled = YES;
    [viewTwo addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_centerX).offset(38);
        make.top.equalTo(ineOne.mas_bottom).offset(30);
        make.width.offset(100);
        make.height.offset(100);
    }];
    UILabel *labels = [[UILabel alloc] init];
    labels.textColor = UIColorRBG(153, 153, 153);
    labels.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    NSString *titleLabel = @"1.请上传相关证件，拍摄时确保各项信息清晰可见，亮度均匀，易于识别\n2.照片必须真实拍摄，不得使用复印件和扫描件";
    NSMutableAttributedString *attributedString =  [self changeSomeText:@"清晰可见，亮度均匀，易于识别" inText:titleLabel withColor:UIColorRBG(102, 221, 85)];
    labels.attributedText = attributedString;
    labels.numberOfLines = 0;
    [self.view addSubview:labels];
    [labels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_bottom).offset(11);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = UIColorRBG(255, 224, 0);
    [button setTitle:@"提交审核" forState:UIControlStateNormal];
    [button setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [button addTarget:self action:@selector(subButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(49);
    }];
}
#pragma mark -创建view
-(UIView *)createView:(NSString *)name contents:(NSString *)content fY:(CGFloat)fY{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, fY, self.view.fWidth-30, 49)];
    //名字
    UILabel *names = [[UILabel alloc] init];
    names.text = name;
    names.textColor = UIColorRBG(51, 51, 51);
    names.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [view addSubview:names];
    [names mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(19);
        make.height.offset(13);
    }];
    //内容
    UILabel *contents = [[UILabel alloc] init];
    contents.text = content;
    contents.textColor = UIColorRBG(51, 51, 51);
    contents.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [view addSubview:contents];
    [contents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(names.mas_right).offset(39);
        make.top.equalTo(view.mas_top).offset(19);
        make.width.offset(view.fWidth-120);
        make.height.offset(13);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(255, 236, 134);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
        make.bottom.equalTo(view.mas_bottom);
        make.height.offset(1);
    }];
    return view;
}
//上传名片
-(void)clickImage{
    WZAlertView *redView = [WZAlertView new];
    redView.imageName = @"card_2";
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
    redView.imageName = @"rz_pic";
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
    NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/leaderAuthentication",HTTPURL];
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
            if ([code isEqual:@"401"]) {
                
                [NSString isCode:self.navigationController code:code];
                //更新指定item
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];;
                item.badgeValue= nil;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        button.enabled = YES;
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
- (NSMutableAttributedString *)changeSomeText:(NSString *)str inText:(NSString *)result withColor:(UIColor *)color {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:result];
    NSRange colorRange = NSMakeRange([[attributeStr string] rangeOfString:str].location,[[attributeStr string] rangeOfString:str].length);
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    
    return attributeStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
