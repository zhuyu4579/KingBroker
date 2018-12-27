//
//  WZVoucherBoardingController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/11/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import <MJRefresh.h>
#import "WZAlertView.h"
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "HXPhotoPicker.h"
#import "NSString+LCExtension.h"
#import "WZVoucherBoardingController.h"
static const CGFloat kPhotoViewMargin = 15.0;
@interface WZVoucherBoardingController ()<HXPhotoViewDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *views;
@property (strong, nonatomic) UIImageView *imageViews;
@property (strong, nonatomic) UILabel *viewTitle;
//图片数组
@property (strong, nonatomic) NSMutableArray<UIImage *> *imageArray;
@end

@implementation WZVoucherBoardingController
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 9; //
        _manager.configuration.videoMaxNum = 0;  //
        _manager.configuration.maxNum = 9;
        _manager.configuration.reverseDate = YES;
        //        _manager.configuration.selectTogether = NO;
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.navigationItem.title = @"凭证上客";
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    //创建控件
    [self createController];
}

-(void)createController{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //创建view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 8, scrollView.fWidth, 175)];
    view.backgroundColor = [UIColor whiteColor];
    _views = view;
    [scrollView addSubview:view];
    UILabel *labels = [[UILabel alloc] init];
    labels.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"上传上客凭证" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    labels.attributedText = string;
    [view addSubview:labels];
    [labels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(14);
        make.top.equalTo(view.mas_top).offset(14);
        make.height.offset(15);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ineView];
    [ineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(14);
        make.top.equalTo(labels.mas_bottom).offset(14);
        make.height.offset(1);
        make.width.offset(view.fWidth-28);
    }];
    CGFloat width = scrollView.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 58, width - kPhotoViewMargin * 2, 0);
    photoView.lineCount = 3;
    photoView.spacing = 24;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.outerCamera = YES;
    photoView.delegate = self;
    photoView.deleteImageName = @"delete";
    photoView.addImageName = @"camera";
    //    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [view addSubview:photoView];
    self.photoView = photoView;
    [self.photoView refreshView];
    //文字说明
    UIImageView *imageViews = [[UIImageView alloc] init];
    imageViews.image = [UIImage imageNamed:@"wd_ts"];
    _imageViews = imageViews;
    [scrollView addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left).offset(15);
        make.top.equalTo(view.mas_bottom).offset(11);
        make.width.offset(6);
        make.height.offset(12);
    }];
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.numberOfLines = 0;
    _viewTitle = labelTitle;
    [scrollView addSubview:labelTitle];
    
    NSMutableAttributedString *strings = [[NSMutableAttributedString alloc] initWithString:@"需上传纸质报备单确认上客，审核通过后上客成功" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Light" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    labelTitle.attributedText = strings;
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageViews.mas_right).offset(5);
        make.top.equalTo(view.mas_bottom).offset(12);
        make.height.offset(12);
    }];
    
    UIButton *boaringButton = [[UIButton alloc] init];
    boaringButton.backgroundColor = UIColorRBG(255, 224, 0);
    [boaringButton setTitle:@"确认上客" forState:UIControlStateNormal];
    [boaringButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    boaringButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    [boaringButton addTarget:self action:@selector(boarding) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boaringButton];
    [boaringButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.offset(self.view.fWidth);
        make.height.offset(49);
    }];
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    _views.fHeight = frame.size.height+77;
    [_imageViews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_views.mas_bottom).offset(11);
    }];
    [_viewTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_views.mas_bottom).offset(12);
    }];
}
//获取图片数组
-(void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    _imageArray = [NSMutableArray array];
    for (HXPhotoModel *modelOne in allList) {
        [_imageArray addObject:modelOne.thumbPhoto];
    }
    
}
-(void)boarding{
    
    if (_imageArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"请上传凭证"];
        return;
    }
    //添加遮罩
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    
    //延迟请求数据
    [self performSelector:@selector(loadData) withObject:self afterDelay:0.5];
    
    
}
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    
    NSString *url = [NSString stringWithFormat:@"%@/order/certificateBoard",HTTPURL];
    [mgr POST:url parameters:paraments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        for (int i = 0; i<_imageArray.count; i++) {
            NSData *imageData = [WZAlertView imageProcessWithImage:_imageArray[i]];//进行图片压缩
            // 使用日期生成图片名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            // 任意的二进制数据MIMEType application/octet-stream
            [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            [GKCover hide];
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"提交审核成功,等待审核"];
            if (_boardingSuccess) {
                _boardingSuccess(@"1");
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [GKCover hide];
            [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
@end
