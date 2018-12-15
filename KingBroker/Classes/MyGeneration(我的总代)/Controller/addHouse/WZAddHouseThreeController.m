//
//  WZAddHouseThreeController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import "HXPhotoPicker.h"
#import <SVProgressHUD.h>
#import <BRPickerView.h>
#import "UIBarButtonItem+Item.h"
#import "WZAddHouseThreeController.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZAddHouseThreeController ()<UITextFieldDelegate,HXPhotoViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *viewOne;
@property(nonatomic,strong)UIView *viewTwo;
@property(nonatomic,strong)UIView *viewThree;
@property(nonatomic,strong)UIView *viewFour;
//户型名称
@property(nonatomic,strong)UITextField *apartmentName;
//户型
@property(nonatomic,strong)UILabel *apartmentLabel;
//面积
@property(nonatomic,strong)UITextField *area;
//最低价格
@property(nonatomic,strong)UITextField *price;
//展示图
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
//楼盘图
@property (weak, nonatomic) NSMutableArray *photoViewOne;
@property (weak, nonatomic) NSMutableArray *photoViewTwo;
@property (weak, nonatomic) NSMutableArray *photoViewThree;
//图片数组
@property (strong, nonatomic) NSArray<UIImage *> *imageArray;
@end
static const CGFloat kPhotoViewMargin = 15.0;
@implementation WZAddHouseThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加楼盘";
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(skip) title:@"跳过"];
    //创建view
    [self createView];
}
#pragma mark-创建View
-(void)createView{
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX,0, self.view.fWidth, self.view.fHeight-49-JF_BOTTOM_SPACE)];
    meScrollView.backgroundColor = UIColorRBG(247,247,247);
    meScrollView.bounces = NO;
    meScrollView.showsVerticalScrollIndicator = NO;
    meScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:meScrollView];
    self.scrollView = meScrollView;
    //第一个view
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 1, meScrollView.fWidth, 166)];
    viewOne.backgroundColor = [UIColor whiteColor];
    _viewOne = viewOne;
    [meScrollView addSubview:viewOne];
    [self ctreatePhotographView:viewOne title:@"楼盘图" tag:10];
    
    //第二个view
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,viewOne.fY+viewOne.fHeight+8, meScrollView.fWidth, 166)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    _viewTwo = viewTwo;
    [meScrollView addSubview:viewTwo];
    [self ctreatePhotographView:viewTwo title:@"沙盘图" tag:11];
    
    //第三个view
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+viewTwo.fHeight+8, meScrollView.fWidth, 166)];
    viewThree.backgroundColor = [UIColor whiteColor];
    _viewThree = viewThree;
    [meScrollView addSubview:viewThree];
    [self ctreatePhotographView:viewThree title:@"沙盘图" tag:12];
    
    //第四个view
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY+viewThree.fHeight+8, meScrollView.fWidth, 408)];
    viewFour.backgroundColor = [UIColor whiteColor];
    _viewFour = viewFour;
    [meScrollView addSubview:viewFour];
    UIView *viewOne_one = [self createViewOne:@"户型名称" contents:@"" fY:0 isDel:@"0" unit:@"" setKeyboard:@"0"];
    [viewFour addSubview:viewOne_one];
    UITextField *apartmentName = [viewOne_one viewWithTag:20];
    _apartmentName = apartmentName;
    
    UIView *ineOne = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewFour.fWidth-30, 1)];
    ineOne.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineOne];
    
    UIView *viewOne_two = [self createViewClass:@selector(selectApartment:) image:[UIImage imageNamed:@"bb_more_unfold"] title:@"户型" fY:50 size:CGSizeMake(9, 15)];
    [viewFour addSubview:viewOne_two];
    _apartmentLabel = [viewOne_two viewWithTag:30];
    
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 99, viewFour.fWidth-30, 1)];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineTwo];
    
    UIView *viewOne_Three = [self createViewOne:@"面积" contents:@"" fY:100 isDel:@"3" unit:@"m²" setKeyboard:@"1"];
    [viewFour addSubview:viewOne_Three];
    UITextField *area = [viewOne_Three viewWithTag:20];
    _area = area;
    
    UIView *ineThree = [[UIView alloc] initWithFrame:CGRectMake(15, 149, viewFour.fWidth-30, 1)];
    ineThree.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineThree];
    
    UIView *viewOne_Four = [self createViewOne:@"最低价格" contents:@"" fY:150 isDel:@"3" unit:@"万元" setKeyboard:@"1"];
    [viewFour addSubview:viewOne_Four];
    UITextField *price = [viewOne_Four viewWithTag:20];
    _price = price;
    
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(0, 199, viewFour.fWidth, 1)];
    ineFour.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineFour];
    
    UIView *pohtoView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, viewFour.fWidth, 160)];
    [viewFour addSubview:pohtoView];
    [self ctreatePhotographView:pohtoView title:@"户型图" tag:100];
    
    UIView *ineFive = [[UIView alloc] initWithFrame:CGRectMake(15, 360, viewFour.fWidth-30, 1)];
    ineFive.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineFive];
    
    UIButton *addApartment = [[UIButton alloc] init];
    [addApartment setBackgroundImage:[UIImage imageNamed:@"zd_tjhx"] forState:UIControlStateNormal];
    [addApartment addTarget:self action:@selector(addApartments) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:addApartment];
    [addApartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewFour.mas_centerX);
        make.bottom.equalTo(viewFour.mas_bottom).offset(-15);
        make.width.offset(85);
        make.height.offset(24);
    }];
    //提交按钮
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"保存" forState:UIControlStateNormal];
    [nextButton setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    nextButton.backgroundColor = UIColorRBG(255, 224, 0);
    nextButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 15];
    [nextButton addTarget:self action:@selector(nextSubmission) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.offset(self.view.fWidth);
        make.height.offset(49);
    }];
    meScrollView.contentSize = CGSizeMake(0, viewFour.fY+viewFour.fHeight);
}

#pragma mark-选择户型
-(void)selectApartment:(UIButton *)button{
    // 自定义多列字符串
    NSArray *dataSources = @[@[@"一室", @"两室", @"三室", @"四室", @"五室", @"五室以上"], @[@"一厅", @"两厅", @"三厅", @"四厅", @"五厅", @"五厅以上"],@[@"一卫", @"两卫", @"三卫", @"四卫", @"五卫", @"五卫以上"]];
    
    [BRStringPickerView showStringPickerWithTitle:@"选择户型" dataSource:dataSources defaultSelValue:@[@"三室",@"两厅",@"两卫"] resultBlock:^(id selectValue) {
        UIView *view = button.superview;
        UILabel *aparetment = [view viewWithTag:30];
        if (selectValue) {
            aparetment.textColor = UIColorRBG(51, 51, 51);
            aparetment.text = [NSString stringWithFormat:@"%@%@%@",selectValue[0],selectValue[1],selectValue[2]];
        }
        
    }];
}
#pragma mark-跳过
-(void)skip{
    
}
#pragma mark-保存
-(void)nextSubmission{
    
}
#pragma mark-添加户型
-(void)addApartments{
    NSUInteger n = _scrollView.subviews.count-4;
    
    //view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _viewFour.fY, _scrollView.fWidth, 359)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 101+n;
    [_scrollView addSubview:view];
    UIView *viewOne_one = [self createViewOne:@"户型名称" contents:@"" fY:0 isDel:@"1" unit:@"" setKeyboard:@"0"];
    [view addSubview:viewOne_one];
   
    UIView *ineOne = [[UIView alloc] initWithFrame:CGRectMake(15, 49, view.fWidth-30, 1)];
    ineOne.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineOne];
    
    UIView *viewOne_two = [self createViewClass:@selector(selectApartment:) image:[UIImage imageNamed:@"bb_more_unfold"] title:@"户型" fY:50 size:CGSizeMake(9, 15)];
    [view addSubview:viewOne_two];
    
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 99, view.fWidth-30, 1)];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineTwo];
    
    UIView *viewOne_Three = [self createViewOne:@"面积" contents:@"" fY:100 isDel:@"3" unit:@"m²" setKeyboard:@"1"];
    [view addSubview:viewOne_Three];
   
    
    UIView *ineThree = [[UIView alloc] initWithFrame:CGRectMake(15, 149, view.fWidth-30, 1)];
    ineThree.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineThree];
    
    UIView *viewOne_Four = [self createViewOne:@"最低价格" contents:@"" fY:150 isDel:@"3" unit:@"万元" setKeyboard:@"1"];
    [view addSubview:viewOne_Four];
    
    
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(0, 199, view.fWidth, 1)];
    ineFour.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineFour];
    
    UIView *pohtoView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, view.fWidth, 160)];
    [view addSubview:pohtoView];
    [self ctreatePhotographView:pohtoView title:@"户型图" tag:100];
    
    _viewFour.fY += 367;
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
}
#pragma mark-删除户型
-(void)deleteHousePhotos:(UIButton *)button{
    NSUInteger n = _scrollView.subviews.count-4;
    NSInteger tag = button.superview.superview.tag;
    NSInteger m = n - (tag - 100);
    UIView *view = button.superview.superview;
    
    for (int i = 1; i<= m; i++) {
        UIView *view = [_scrollView viewWithTag:(tag+i)];
        [view setTag:(tag+i -1)];
        view.fY -= 367;
    }
    [view removeFromSuperview];
    _viewFour.fY -=367;
    _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
}

#pragma mark -抽取第一个view
-(UIView *)createViewOne:(NSString *)title contents:(NSString *)str fY:(CGFloat)fY isDel:(NSString *)isDel unit:(NSString *)unit setKeyboard:(NSString *)keyboard{
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
    if ([keyboard isEqual:@"1"]) {
        content.keyboardType = UIKeyboardTypeDecimalPad;
    }else{
        content.keyboardType = UIKeyboardTypeDefault;
    }
    
    content.clearButtonMode = UITextFieldViewModeWhileEditing;
    [view addSubview:content];
    if ([isDel isEqual:@"1"]||[isDel isEqual:@"2"]) {
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(106);
            make.top.equalTo(view.mas_top).offset(1);
            make.height.offset(48);
            make.width.offset(view.fWidth-170);
        }];
    }else{
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(106);
            make.top.equalTo(view.mas_top).offset(1);
            make.height.offset(48);
            make.width.offset(view.fWidth-121);
        }];
    }
    UILabel *labelUnit = [[UILabel alloc] init];
    NSMutableAttributedString *stringTwo = [[NSMutableAttributedString alloc] initWithString:unit attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 12],NSForegroundColorAttributeName:UIColorRBG(51, 51, 51)}];
    labelUnit.attributedText = stringTwo;
    [view addSubview:labelUnit];
    [labelUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset(19);
        make.height.offset(12);
    }];
    if ([isDel isEqual:@"3"]) {
        [labelUnit setHidden:NO];
    }else{
        [labelUnit setHidden:YES];
    }
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"bb_delete-1"] forState:UIControlStateNormal];
    [button setEnlargeEdge:10];
    [button addTarget:self action:@selector(deleteHousePhotos:) forControlEvents:UIControlEventTouchUpInside];
    if ([isDel isEqual:@"1"]) {
        [button setEnabled:YES];
        [button setHidden:NO];
    }else{
        [button setEnabled:NO];
        [button setHidden:YES];
    }
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset(17);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    return view;
}
#pragma mark -抽取第二个View
-(UIView *)createViewClass:(SEL)sel image:(UIImage *)image title:(NSString *)title fY:(CGFloat)fY size:(CGSize)size{
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
    
    UILabel *titles = [[UILabel alloc] init];
    titles.tag = 30;
    titles.text = @"选择户型";
    titles.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    titles.textColor = UIColorRBG(204, 204, 204);
    [view addSubview:titles];
    [titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(106);
        make.top.equalTo(view.mas_top).offset(19);
        make.height.offset(13);
    }];
    
    UIImageView *imageOne = [[UIImageView alloc] init];
    imageOne.image = image;
    [view addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset((49-size.width)/2.0);
        make.width.offset(size.width);
        make.height.offset(size.height);
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

#pragma mark -创建图片拍照
-(void)ctreatePhotographView:(UIView *)view title:(NSString *)title tag:(NSInteger)tag{
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
    
   HXPhotoManager *manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    //        _manager.configuration.openCamera = NO;
    manager.configuration.saveSystemAblum = YES;
    if (tag>=100) {
        manager.configuration.photoMaxNum = 3;
    }else{
        manager.configuration.photoMaxNum = 9;
    }
   // manager.configuration.photoMaxNum = 9; //
    manager.configuration.videoMaxNum = 0;  //
    manager.configuration.maxNum = 9;
    manager.configuration.reverseDate = YES;
    
    CGFloat width = view.fWidth;
    HXPhotoView *photoView = [HXPhotoView photoManager:manager];
    photoView.frame = CGRectMake(kPhotoViewMargin, 53, width - kPhotoViewMargin * 2, 0);
    photoView.lineCount = 3;
    photoView.spacing = 24;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
    photoView.outerCamera = YES;
    photoView.delegate = self;
    photoView.deleteImageName = @"delete";
    photoView.addImageName = @"camera";
    photoView.tag = tag;
    //    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [view addSubview:photoView];
    _photoView = photoView;
    [_photoView refreshView];
}
//修改view的高度
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{
    NSInteger tag = photoView.tag;
    if(tag == 10){
        _viewOne.fHeight = frame.size.height+68;
        _viewTwo.fY += frame.size.height+68 - 166;
        _viewThree.fY += frame.size.height+68 - 166;
        _viewFour.fY += frame.size.height+68 - 166;
        _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    }else if(tag == 11){
        _viewTwo.fHeight = frame.size.height+68;
        _viewThree.fY += frame.size.height+68 - 166;
        _viewFour.fY += frame.size.height+68 - 166;
        _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    }else if(tag == 12){
        _viewThree.fHeight = frame.size.height+68;
        _viewFour.fY += frame.size.height+68 - 166;
        _scrollView.contentSize = CGSizeMake(0, _viewFour.fY+_viewFour.fHeight);
    }else{
        
    }
}
//获取图片数组
- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList{
    
    _imageArray = imageList;
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
    [self.view endEditing:YES];
}
-(void)touches{
    [self.view endEditing:YES];
}
@end
