//
//  WZEditHouseViewTwoController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import "HXPhotoPicker.h"
#import <SVProgressHUD.h>
#import "WZOSSImageUploader.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import "WZNavigationController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZEditHouseViewTwoController.h"

@interface WZEditHouseViewTwoController ()<UITextFieldDelegate,UITextViewDelegate,HXPhotoViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *viewFour;
//开发商
@property(nonatomic,strong)UITextField *developerName;
//剩余套数
@property(nonatomic,strong)UITextField *surpluNum;
// 标签数组
@property (nonatomic, strong) NSArray *markArray;
// 选中标签数组(数字)
@property (nonatomic, strong) NSMutableArray *selectedMarkArray;
@property(nonatomic,strong)NSString *buildingFeature;
//楼盘简介
@property (nonatomic, retain) UITextView *fareReimbur;
//文本提示语
@property (nonatomic, retain) UILabel *fareReimburLabels;
//文本数量
@property (nonatomic, retain) UILabel *fareReimburSum;
//展示图
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
//图片数组
@property (strong, nonatomic) NSMutableArray<UIImage *> *imageArray;
//图片数组
@property (strong, nonatomic) NSArray *imageArrays;

@end
static const CGFloat kPhotoViewMargin = 15.0;
@implementation WZEditHouseViewTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    
    //创建view
    [self createView];
}
#pragma mark -创建view
-(void)createView{
    CGFloat n = SCREEN_WIDTH / 375.0;
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX,0, self.view.fWidth, self.view.fHeight-134-JF_BOTTOM_SPACE-kApplicationStatusBarHeight)];
    meScrollView.backgroundColor = UIColorRBG(247,247,247);
    meScrollView.bounces = NO;
    meScrollView.showsVerticalScrollIndicator = NO;
    meScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:meScrollView];
    self.scrollView = meScrollView;
    //第一个view
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 1, meScrollView.fWidth, 99)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewOne];
    //开发商
    NSString *developer = [_data valueForKey:@"developer"];
    UIView *viewOne_one = [self createViewOne:@"开发商" contents:developer fY:0];
    [viewOne addSubview:viewOne_one];
    UITextField *developerName = [viewOne_one viewWithTag:20];
    _developerName = developerName;
    UIView *ineOne = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewOne.fWidth-30, 1)];
    ineOne.backgroundColor = UIColorRBG(240, 240, 240);
    [viewOne addSubview:ineOne];
    //剩余套数
    NSString *houseNum = [_data valueForKey:@"houseNum"];
    UIView *viewOne_two = [self createViewOne:@"剩余套数" contents:houseNum fY:50];
    [viewOne addSubview:viewOne_two];
    UITextField *surpluNum = [viewOne_two viewWithTag:20];
    _surpluNum = surpluNum;
    
    //第二个view
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, viewOne.fY+viewOne.fHeight+8, meScrollView.fWidth, 130)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewTwo];
    UILabel *labelTitle = [[UILabel alloc] init];
    NSMutableAttributedString *stringOne = [[NSMutableAttributedString alloc] initWithString:@"楼盘类型" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName:UIColorRBG(51, 51, 51)}];
    labelTitle.attributedText = stringOne;
    [viewTwo addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_top).offset(14);
        make.height.offset(15);
    }];
    
    UILabel *labelTitles = [[UILabel alloc] init];
    labelTitles.text = @"(多选)";
    labelTitles.textColor = UIColorRBG(204, 204, 204);
    labelTitles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    [viewTwo addSubview:labelTitles];
    [labelTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right).offset(10);
        make.top.equalTo(viewTwo.mas_top).offset(16);
        make.height.offset(13);
    }];
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 42, viewTwo.fWidth-30, 1)];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [viewTwo addSubview:ineTwo];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, ineTwo.fY+1, viewTwo.fWidth, 88)];
    [viewTwo addSubview:buttonView];
    [self createMultipleButton:buttonView];
    
    //第三个view
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+viewTwo.fHeight+8, meScrollView.fWidth, 159)];
    viewThree.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewThree];
    //车费报销说明
    NSString *fareReimburseDesc = [_data valueForKey:@"fareReimburseDesc"];
    [self createReadView:viewThree title:@"车费报销说明" placeholder:@"输入车费报销说明" sum:@"0/100"];
    _fareReimbur = [viewThree viewWithTag:40];
    _fareReimburLabels = [viewThree viewWithTag:50];
    _fareReimburSum = [viewThree viewWithTag:60];
    if(![fareReimburseDesc isEqual:@""]&&fareReimburseDesc){
        _fareReimbur.text = fareReimburseDesc;
        [_fareReimburLabels setHidden:YES];
        _fareReimburSum.text = [NSString stringWithFormat:@"%ld/100",fareReimburseDesc.length];
    }
    
    //第四个view
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY+viewThree.fHeight+8, meScrollView.fWidth, 166*n)];
    viewFour.backgroundColor = [UIColor whiteColor];
    _viewFour = viewFour;
    [meScrollView addSubview:viewFour];
    [self ctreatePhotographView:viewFour title:@"车费报销图片"];
    
    //提交按钮
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"保存" forState:UIControlStateNormal];
    [nextButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorRBG(255, 224, 0);
    nextButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    [nextButton addTarget:self action:@selector(nextSubmission:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.offset(self.view.fWidth);
        make.height.offset(49);
    }];
    meScrollView.contentSize = CGSizeMake(0, viewFour.fY+viewFour.fHeight);
}

#pragma mark-下一步
-(void)nextSubmission:(UIButton *)button{
    
    if (_selectedMarkArray.count>0) {
         _buildingFeature =[_selectedMarkArray componentsJoinedByString:@","];
    }
    if(_fareReimbur.text.length>100){
        [SVProgressHUD showInfoWithStatus:@"车费报销说明字数超过最大限制"];
        return;
    }
    if (_imageArrays.count != _imageArray.count) {
        [SVProgressHUD showInfoWithStatus:@"图片上传失败,请重新选择图片"];
        return;
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"保存中"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"projectId"] = [_data valueForKey:@"id"];
    paraments[@"developer"] = _developerName.text;
    paraments[@"houseNum"] = _surpluNum.text ;
    paraments[@"buildingFeature"] = _buildingFeature;
    paraments[@"fareReimburseDesc"] = _fareReimbur.text;
    paraments[@"fareImglist"] = _imageArrays;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/upsupplementCreateOrUpdate",HTTPURL];
    NSLog(@"%@",paraments);
    button.enabled = NO;
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [SVProgressHUD dismiss];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"保存成功"];
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
        button.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
#pragma mark - 懒加载
- (NSMutableArray *)selectedMarkArray {
    if (!_selectedMarkArray) {
        _selectedMarkArray = [NSMutableArray array];
    }
    return _selectedMarkArray;
}

#pragma mark -创建多选按钮
-(void)createMultipleButton:(UIView *)view{
    NSString *buildingFeature = [_data valueForKey:@"buildingFeature"];
    _buildingFeature = buildingFeature;
    if (![buildingFeature isEqual:@""]&&buildingFeature) {
        NSArray *arrays = [buildingFeature componentsSeparatedByString:@","];
        _selectedMarkArray = arrays;
    }
   
    NSArray *array = @[@"新盘首开", @"可托管", @"实景样板房",@"", @"LOFT", @"现房",@"小户型",@"可餐饮"];
    _markArray = array;
    CGFloat top = 0;
    CGFloat height = 44;
    CGFloat width = view.fWidth/4.0;
    NSInteger maxCol = 4;
    for (NSInteger i = 0; i < 8; i++) {
        if (i==3) {
            continue;
        }
        NSInteger col = i % maxCol; //列
        NSInteger row = i / maxCol; //行
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(col * width, top + row * height, width, height)];
        [view addSubview:btnView];
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"bb_choose_2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bb_icon"] forState:UIControlStateSelected];
        if ([buildingFeature containsString:[NSString stringWithFormat:@"%ld",i+1]]) {
            btn.selected = YES;
        }
        if (i>3) {
            btn.tag = i;
        }else{
            btn.tag = i+1;
        }
        
        [btn setEnlargeEdgeWithTop:10 right:40 bottom:10 left:10];
        [btn addTarget:self action:@selector(chooseMark:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnView.mas_left).offset(15);
            make.top.equalTo(btnView.mas_top).offset(15);
            make.width.offset(19);
            make.height.offset(19);
        }];
        UILabel *labelTitle = [[UILabel alloc] init];
        labelTitle.text = _markArray[i];
        labelTitle.textColor = UIColorRBG(51, 51, 51);
        labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
        [btnView addSubview:labelTitle];
        [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(10);
            make.top.equalTo(btnView.mas_top).offset(18);
            make.height.offset(13);
        }];
    }
    
}
#pragma mark-多选按钮值
- (void)chooseMark:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    
    if (btn.isSelected) {
        
        [self.selectedMarkArray addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    } else {
        
        [self.selectedMarkArray removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
        
    }
    
}

#pragma mark -抽取第一个view
-(UIView *)createViewOne:(NSString *)title contents:(NSString *)str fY:(CGFloat)fY{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, fY, _scrollView.fWidth, 49)];
    UILabel *labelTitle = [[UILabel alloc] init];
    NSMutableAttributedString *stringOne = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 13],NSForegroundColorAttributeName:UIColorRBG(51, 51, 51)}];
    labelTitle.attributedText = stringOne;
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(19);
        make.height.offset(13);
    }];
    
    UITextField *content = [[UITextField alloc] init];
    content.tag = 20;
    content.placeholder = [NSString stringWithFormat:@"输入%@",title];
    content.textColor = UIColorRBG(51, 51, 51);
    content.text = str;
    content.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    content.delegate = self;
    content.keyboardType = UIKeyboardTypeDefault;
    content.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(106);
        make.top.equalTo(view.mas_top).offset(1);
        make.height.offset(48);
        make.width.offset(view.fWidth-121);
    }];
    return view;
}
#pragma mark -抽取第三个View
-(void)createReadView:(UIView *)view title:(NSString *)title placeholder:(NSString *)placeholder sum:(NSString *)sum{
    UILabel *labelTitle = [[UILabel alloc] init];
    NSMutableAttributedString *stringOne = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName:UIColorRBG(51, 51, 51)}];
    labelTitle.attributedText = stringOne;
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(14);
        make.height.offset(15);
    }];
    UILabel *labelTitles = [[UILabel alloc] init];
    labelTitles.text = @"(不支持输入表情符)";
    labelTitles.textColor = UIColorRBG(204, 204, 204);
    labelTitles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    [view addSubview:labelTitles];
    [labelTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right).offset(10);
        make.top.equalTo(view.mas_top).offset(16);
        make.height.offset(13);
    }];
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(15, 43, view.fWidth-30, view.fHeight-58)];
    views.backgroundColor = UIColorRBG(245, 245, 245);
    [view addSubview:views];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 43, view.fWidth-30, view.fHeight-82)]; //初始化大小并自动释放
    textView.tag = 40;
    textView.textColor = UIColorRBG(51, 51, 51);
    textView.font = [UIFont fontWithName:@"PingFang-SC-Regular" size: 13];//设置字体名字和字体大小
    textView.delegate = self;//设置它的委托方法
    textView.backgroundColor = UIColorRBG(245, 245, 245);
    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.scrollEnabled = YES;//是否可以拖动
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [view addSubview:textView];
    UILabel *lable = [[UILabel alloc] init];
    lable.tag = 50;
    lable.textColor = UIColorRBG(204, 204, 204);
    lable.font = [UIFont fontWithName:@"PingFang-SC-Regular" size: 13];
    lable.numberOfLines = 0;
    lable.text = placeholder;
    [textView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView.mas_left).offset(10);
        make.top.equalTo(textView.mas_top).offset(10);
        make.width.offset(textView.fWidth-20);
    }];
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.tag = 60;
    lable1.textColor = UIColorRBG(204, 204, 204);
    lable1.font = [UIFont fontWithName:@"PingFang-SC-Regular" size: 13];
    lable1.text = sum;
    [view addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-29);
        make.bottom.equalTo(view.mas_bottom).offset(-24);
        make.height.offset(13);
    }];
    
}
//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight+220);
    if (textView == _fareReimbur) {
        [_fareReimburLabels setHidden:YES];
    }
    
}

//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *text = textView.text;
    if (text.length == 0) {
        if (textView == _fareReimbur) {
            [_fareReimburLabels setHidden:NO];
        }
        
    }
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    
}
-(void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    if (textView == _fareReimbur) {
        _fareReimburSum.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)text.length];
    }
    
}
#pragma mark -懒加载
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 2; //
        _manager.configuration.videoMaxNum = 0;  //
        _manager.configuration.maxNum = 2;
        _manager.configuration.reverseDate = YES;
        //        _manager.configuration.selectTogether = NO;
    }
    return _manager;
}
#pragma mark -创建图片拍照
-(void)ctreatePhotographView:(UIView *)view title:(NSString *)title{
    UILabel *labelTitle = [[UILabel alloc] init];
    NSMutableAttributedString *stringOne = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName:UIColorRBG(51, 51, 51)}];
    labelTitle.attributedText = stringOne;
    [view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(14);
        make.height.offset(15);
    }];
    UILabel *labelTitles = [[UILabel alloc] init];
    labelTitles.text = @"(建议图片长：宽=3：2)";
    labelTitles.textColor = UIColorRBG(204, 204, 204);
    labelTitles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    [view addSubview:labelTitles];
    [labelTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right).offset(10);
        make.top.equalTo(view.mas_top).offset(16);
        make.height.offset(13);
    }];
    UIView *ine = [[UIView alloc] initWithFrame:CGRectMake(15, 42, view.fWidth-30, 1)];
    ine.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ine];
    
    CGFloat width = view.fWidth;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 53, width - kPhotoViewMargin * 2, 0);
    photoView.lineCount = 3;
    photoView.spacing = 24;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.outerCamera = YES;
    photoView.delegate = self;
    photoView.deleteImageName = @"delete";
    photoView.addImageName = @"zd_camera";
    //    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [view addSubview:photoView];
    self.photoView = photoView;
    NSMutableArray *array = [_data valueForKey:@"fareImglist"];
    _imageArrays = array;
    NSLog(@"%@",_imageArrays);
    
    if (array.count==1) {
        HXCustomAssetModel *assetModel = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:array[0]] selected:YES];
        [self.manager addCustomAssetModel:@[assetModel]];
    }
    if (array.count==2) {
        HXCustomAssetModel *assetModel = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:array[0]] selected:YES];
        HXCustomAssetModel *assetModel2 = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:array[1]] selected:YES];
        [self.manager addCustomAssetModel:@[assetModel,assetModel2]];
    }
    
    [self.photoView refreshView];
}

//获取图片数组
-(void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    _imageArray = [NSMutableArray array];
    for (HXPhotoModel *modelOne in allList) {
        NSSLog(@"%@",modelOne.thumbPhoto);
        [_imageArray addObject:modelOne.thumbPhoto];
    }
    [self findUploadData:_imageArray];
}
//获取文件上传信息
-(void)findUploadData:(NSArray<UIImage *> *)imageList{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    //NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@/sysAttachment/getStsInfo",HTTPURL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *dacty = [responseObject valueForKey:@"data"];
            NSLog(@"%@",dacty);
            if (imageList.count == 0) {
                _imageArrays = nil;
                return ;
            }
            [WZOSSImageUploader asyncUploadImages:imageList data:dacty complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
                NSLog(@"%ld",(long)state);
                NSLog(@"%@",names);
                _imageArrays = names;
            }];
        }else{
           // [SVProgressHUD showInfoWithStatus:@"获取上传凭证失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight+220);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length>20) {
        return NO;
    }
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    [self.view endEditing:YES];
}
-(void)touches{
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    [self.view endEditing:YES];
}
@end
