//
//  WZUpdateCardController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2019/2/20.
//  Copyright © 2019 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import <MJRefresh.h>
#import "UIColor+Tools.h"
#import "WZAlertView.h"
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "HXPhotoPicker.h"
#import "WZLoadDateSeviceOne.h"
#import "NSString+LCExtension.h"
#import "WZUpdateCardController.h"
static const CGFloat kPhotoViewMargin = 15.0;
@interface WZUpdateCardController ()<HXPhotoViewDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *views;
@property (strong, nonatomic) UILabel *viewTitle;
//图片数组
@property (strong, nonatomic) NSMutableArray<UIImage *> *imageArray;
@end

@implementation WZUpdateCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传名片";
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    [self createController];
}
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    _views.fHeight = frame.size.height+77;
   
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
    NSMutableDictionary *parement = [NSMutableDictionary dictionary];
    [WZLoadDateSeviceOne postUpdatePhotoSuccess:^(NSDictionary *dic) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        NSString *code = [dic valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            
            [SVProgressHUD showInfoWithStatus:@"提交成功,等待审核"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"businessCardStatus"];
            [defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            NSString *msg = [dic valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
           
        }
    } andFail:^(NSString *str) {
        [GKCover hide];
        [SVProgressHUD dismiss];
    } parament:parement URL:@"/sysAuthenticationInfo/businessCardAuthentication" imageArray:_imageArray];
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
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"上传名片" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    labels.attributedText = string;
    [view addSubview:labels];
    [labels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(14);
        make.top.equalTo(view.mas_top).offset(14);
        make.height.offset(15);
    }];
    UILabel *cardLabelTwo = [[UILabel alloc] init];
    cardLabelTwo.text = @"（名片、工牌、门店门头等）";
    cardLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
    cardLabelTwo.textColor = UIColorRBG(102, 102, 102);
    [view addSubview:cardLabelTwo];
    [cardLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labels.mas_right).offset(0);
        make.top.equalTo(view.mas_top).offset(18);
        make.height.offset(11);
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
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"";
    labelTitle.textColor = UIColorRBG(153, 153, 153);
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    NSString *strs = @"1.照片拍摄时确保各项信息清晰可见，亮度均匀，易于识别\n2.照片必须真实拍摄，不得使用复印件和扫描件";
    NSMutableAttributedString *attributedString =  [UIColor changeSomeText:@"清晰可见，亮度均匀，易于识别" inText:strs withColor:UIColorRBG(255, 168, 66)];
    labelTitle.attributedText = attributedString;
    labelTitle.numberOfLines = 0;
    _viewTitle = labelTitle;
    [scrollView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView.mas_left).offset(17);
        make.top.equalTo(view.mas_bottom).offset(12);
        make.width.offset(view.fWidth-34);
    }];
    
    UIButton *boaringButton = [[UIButton alloc] init];
    boaringButton.backgroundColor = UIColorRBG(255, 224, 0);
    [boaringButton setTitle:@"提交" forState:UIControlStateNormal];
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

@end
