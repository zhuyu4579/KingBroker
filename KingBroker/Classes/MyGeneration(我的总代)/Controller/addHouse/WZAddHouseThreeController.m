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
#import "WZOSSImageUploader.h"
#import "UIBarButtonItem+Item.h"
#import "WZNavigationController.h"
#import "NSString+LCExtension.h"
#import "WZAddHouseThreeController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZAddHouseSuccessController.h"
@interface WZAddHouseThreeController ()<UITextFieldDelegate,HXPhotoViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *viewOne;
@property(nonatomic,strong)UIView *viewTwo;
@property(nonatomic,strong)UIView *viewThree;
@property(nonatomic,strong)UIView *viewFour;
@property(nonatomic,strong)UIView *viewFive;
//户型名称
@property(nonatomic,strong)UITextField *apartmentName;
//户型
@property(nonatomic,strong)UILabel *apartmentLabel;
@property(nonatomic,strong)UILabel *apartmentLabelNum;
//面积
@property(nonatomic,strong)UITextField *area;
//最低价格
@property(nonatomic,strong)UITextField *price;
//展示图
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *managerTwos;
@property (strong, nonatomic) HXPhotoView *photoViewTwos;
@property (strong, nonatomic) HXPhotoManager *managerThrees;
@property (strong, nonatomic) HXPhotoView *photoViewThrees;
@property (strong, nonatomic) HXPhotoManager *managerFours;
@property (strong, nonatomic) HXPhotoView *photoViewFours;
//楼盘图
@property (weak, nonatomic) NSMutableArray *photoViewOne;
@property (weak, nonatomic) NSMutableArray *photoViewTwo;
@property (weak, nonatomic) NSMutableArray *photoViewThree;
//图片数组
@property (strong, nonatomic) NSArray<UIImage *> *imageArray;
@property (strong, nonatomic) NSArray<UIImage *> *imageArray1;
@property (strong, nonatomic) NSArray<UIImage *> *imageArray2;
@property (strong, nonatomic) NSArray<UIImage *> *imageArray3;

@property (strong, nonatomic) NSArray<NSString*> *imageArrays;
@property (strong, nonatomic) NSArray<NSString*> *imageArrays1;
@property (strong, nonatomic) NSArray<NSString*> *imageArrays2;
@property (strong, nonatomic) NSMutableArray *imageArrays3;

@end
static const CGFloat kPhotoViewMargin = 15.0;
@implementation WZAddHouseThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArrays3 = [NSMutableArray array];
    self.navigationItem.title = @"添加楼盘";
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(skip) title:@"跳过"];
    //创建view
    [self createView];
}
#pragma mark-创建View
-(void)createView{
    CGFloat n = SCREEN_WIDTH / 375.0;
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX,0, self.view.fWidth, self.view.fHeight-49-JF_BOTTOM_SPACE)];
    meScrollView.backgroundColor = UIColorRBG(247,247,247);
    meScrollView.bounces = NO;
    meScrollView.showsVerticalScrollIndicator = NO;
    meScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:meScrollView];
    self.scrollView = meScrollView;
    //第一个view
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 1, meScrollView.fWidth, 166*n)];
    viewOne.backgroundColor = [UIColor whiteColor];
    _viewOne = viewOne;
    [meScrollView addSubview:viewOne];
    [self ctreatePhotographView:viewOne title:@"楼盘图" tag:10];
    
    //第二个view
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,viewOne.fY+viewOne.fHeight+8, meScrollView.fWidth, 166*n)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    _viewTwo = viewTwo;
    [meScrollView addSubview:viewTwo];
    [self ctreatePhotographView:viewTwo title:@"沙盘图" tag:11];
    
    //第三个view
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+viewTwo.fHeight+8, meScrollView.fWidth, 166*n)];
    viewThree.backgroundColor = [UIColor whiteColor];
    _viewThree = viewThree;
    [meScrollView addSubview:viewThree];
    [self ctreatePhotographView:viewThree title:@"样板间图" tag:12];
    
    //第四个view
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY+viewThree.fHeight+8, meScrollView.fWidth, 359+160*(n-1))];
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
    _apartmentLabelNum = [viewOne_two viewWithTag:40];
    
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 99, viewFour.fWidth-30, 1)];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineTwo];
    
    UIView *viewOne_Three = [self createViewOne:@"面积" contents:@"" fY:100 isDel:@"2" unit:@"m²" setKeyboard:@"1"];
    [viewFour addSubview:viewOne_Three];
    UITextField *area = [viewOne_Three viewWithTag:20];
    _area = area;
    
    UIView *ineThree = [[UIView alloc] initWithFrame:CGRectMake(15, 149, viewFour.fWidth-30, 1)];
    ineThree.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineThree];
    
    UIView *viewOne_Four = [self createViewOne:@"最低价格" contents:@"" fY:150 isDel:@"2" unit:@"万元" setKeyboard:@"1"];
    [viewFour addSubview:viewOne_Four];
    UITextField *price = [viewOne_Four viewWithTag:20];
    _price = price;
    
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(0, 199, viewFour.fWidth, 1)];
    ineFour.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineFour];
    
    UIView *pohtoView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, viewFour.fWidth, 160*n)];
    [viewFour addSubview:pohtoView];
    [self ctreatePhotographView:pohtoView title:@"户型图" tag:100];
    NSArray * array = @[@"0"];
    [_imageArrays3 addObject:array];
//    NSLog(@"%@",_imageArrays3);
    
    
    //第五个view
    UIView *viewFive = [[UIView alloc] initWithFrame:CGRectMake(0, viewFour.fY+viewFour.fHeight+1, meScrollView.fWidth, 50)];
    viewFive.backgroundColor = [UIColor whiteColor];
    _viewFive = viewFive;
    [meScrollView addSubview:viewFive];
    
    UIButton *addApartment = [[UIButton alloc] init];
    [addApartment setBackgroundImage:[UIImage imageNamed:@"zd_tjhx"] forState:UIControlStateNormal];
    [addApartment addTarget:self action:@selector(addApartments) forControlEvents:UIControlEventTouchUpInside];
    [viewFive addSubview:addApartment];
    [addApartment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewFive.mas_centerX);
        make.bottom.equalTo(viewFive.mas_bottom).offset(-15);
        make.width.offset(85);
        make.height.offset(24);
    }];
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
    meScrollView.contentSize = CGSizeMake(0, viewFive.fY+viewFive.fHeight);
}

#pragma mark-选择户型
-(void)selectApartment:(UIButton *)button{
    [self touches];
    // 自定义多列字符串
    NSArray *dataSources = @[@[@"一室", @"两室", @"三室", @"四室", @"五室", @"五室以上"], @[@"一厅", @"两厅", @"三厅", @"四厅", @"五厅", @"五厅以上"],@[@"一卫", @"两卫", @"三卫", @"四卫", @"五卫", @"五卫以上"]];
    NSDictionary *data1 = @{@"一室":@"1", @"两室":@"2", @"三室":@"3", @"四室":@"4", @"五室":@"5", @"五室以上":@"6"};
    NSDictionary *data3 = @{@"一卫":@"1", @"两卫":@"2", @"三卫":@"3", @"四卫":@"4", @"五卫":@"5", @"五卫以上":@"6"};
    NSDictionary *data2 = @{@"一厅":@"1", @"两厅":@"2", @"三厅":@"3", @"四厅":@"4", @"五厅":@"5", @"五厅以上":@"6"};
    
    [BRStringPickerView showStringPickerWithTitle:@"选择户型" dataSource:dataSources defaultSelValue:@[@"三室",@"两厅",@"两卫"] resultBlock:^(id selectValue) {
        UIView *view = button.superview;
        UILabel *aparetment = [view viewWithTag:30];
        UILabel *apareNum = [view viewWithTag:40];
        
        if (selectValue) {
            aparetment.textColor = UIColorRBG(51, 51, 51);
            aparetment.text = [NSString stringWithFormat:@"%@%@%@",selectValue[0],selectValue[1],selectValue[2]];
            apareNum.text = [NSString stringWithFormat:@"%@%@%@",[data1 valueForKey:selectValue[0]],[data2 valueForKey:selectValue[1]],[data3 valueForKey:selectValue[2]]];
        }
        
    }];
}
#pragma mark-跳过
-(void)skip{
    WZAddHouseSuccessController *addHouseThree = [[WZAddHouseSuccessController alloc] init];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:addHouseThree];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark-保存
-(void)nextSubmission:(UIButton *)button{
    
    NSMutableArray *apartmentArray = [NSMutableArray array];
    NSMutableDictionary *apartOne = [NSMutableDictionary dictionary];
    if (![_apartmentLabelNum.text isEqual:@""]) {
            apartOne[@"room"] = [_apartmentLabelNum.text substringToIndex:1];
            apartOne[@"living"] = [_apartmentLabelNum.text substringWithRange:NSMakeRange(1,1)];
            apartOne[@"toilet"] = [_apartmentLabelNum.text substringFromIndex:2];
    }
    apartOne[@"id"] = @"";
    apartOne[@"name"] = _apartmentName.text;
    apartOne[@"area"] = _area.text;
    apartOne[@"price"] = _price.text;
    NSArray *imageArrayOne = _imageArrays3[0];
    if (imageArrayOne.count>0&&![imageArrayOne[0] isEqual:@"0"]) {
        NSString *apartPhoto = imageArrayOne[0];
        if (![apartPhoto isEqual:@"0"]) {
            apartOne[@"housePic"] = _imageArrays3[0];
        }
    }else{
        apartOne[@"housePic"] =nil;
    }
    [apartmentArray addObject:apartOne];
    NSUInteger n = _scrollView.subviews.count-5;
    for (int i=0; i<n; i++) {
        UIView *view = [_scrollView viewWithTag:(101+i)];
        UIView *viewOne = [view viewWithTag:1111];
        UIView *viewTwo = [view viewWithTag:1112];
        UIView *viewThree = [view viewWithTag:1113];
        UIView *viewFour = [view viewWithTag:1114];
        UITextField *apartmentName = [viewOne viewWithTag:20];
        UILabel *apartNum = [viewTwo viewWithTag:40];
        UITextField *area = [viewThree viewWithTag:20];
        UITextField *price = [viewFour viewWithTag:20];
        NSArray *imageArray = _imageArrays3[1+i];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[@"id"] = @"";
        dictionary[@"name"] = apartmentName.text;
        dictionary[@"area"] = area.text;
        dictionary[@"price"] = price.text;
        if (![apartNum.text isEqual:@""]) {
            dictionary[@"room"] = [apartNum.text substringToIndex:1];
            dictionary[@"living"] = [apartNum.text substringWithRange:NSMakeRange(1,1)];
            dictionary[@"toilet"] = [apartNum.text substringFromIndex:2];
        }
        
        if (imageArray.count!=0 && ![imageArray[0] isEqual:@"0"]) {
            NSString *apartPhoto = imageArrayOne[0];
            if (![apartPhoto isEqual:@"0"]) {
                dictionary[@"housePic"] = imageArray;
            }
        }
        [apartmentArray addObject:dictionary];
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
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"projectId"] = _projectId;
    paraments[@"buildingPic"] = _imageArrays;
    paraments[@"sandPic"] = _imageArrays1;
    paraments[@"prototypePic"] = _imageArrays2;
    paraments[@"list"] = apartmentArray;
//    NSLog(@"%@",paraments);
    NSString *url = [NSString stringWithFormat:@"%@/proProject/uppictureInfoCreateOrUpdate",HTTPURL];
//    NSLog(@"%@",paraments);
    button.enabled = NO;
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [SVProgressHUD dismiss];
        button.enabled = YES;
        if ([code isEqual:@"200"]) {
            WZAddHouseSuccessController *addHouseThree = [[WZAddHouseSuccessController alloc] init];
            WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:addHouseThree];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
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
#pragma mark-添加户型
-(void)addApartments{
    CGFloat s = SCREEN_WIDTH / 375.0;
    NSUInteger n = _scrollView.subviews.count-5;
    //view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _viewFive.fY+8, _scrollView.fWidth, 359)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 101+n;
    [_scrollView addSubview:view];
    UIView *viewOne_one = [self createViewOne:@"户型名称" contents:@"" fY:0 isDel:@"1" unit:@"" setKeyboard:@"0"];
    viewOne_one.tag = 1111;
    [view addSubview:viewOne_one];
   
    UIView *ineOne = [[UIView alloc] initWithFrame:CGRectMake(15, 49, view.fWidth-30, 1)];
    ineOne.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineOne];
    
    UIView *viewOne_two = [self createViewClass:@selector(selectApartment:) image:[UIImage imageNamed:@"bb_more_unfold"] title:@"户型" fY:50 size:CGSizeMake(9, 15)];
    viewOne_two.tag = 1112;
    [view addSubview:viewOne_two];
    
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 99, view.fWidth-30, 1)];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineTwo];
    
    UIView *viewOne_Three = [self createViewOne:@"面积" contents:@"" fY:100 isDel:@"2" unit:@"m²" setKeyboard:@"1"];
    viewOne_Three.tag = 1113;
    [view addSubview:viewOne_Three];
   
    
    UIView *ineThree = [[UIView alloc] initWithFrame:CGRectMake(15, 149, view.fWidth-30, 1)];
    ineThree.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineThree];
    
    UIView *viewOne_Four = [self createViewOne:@"最低价格" contents:@"" fY:150 isDel:@"2" unit:@"万元" setKeyboard:@"1"];
    viewOne_Four.tag = 1114;
    [view addSubview:viewOne_Four];
    
    
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(0, 199, view.fWidth, 1)];
    ineFour.backgroundColor = UIColorRBG(240, 240, 240);
    [view addSubview:ineFour];
    
    UIView *pohtoView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, view.fWidth, 160)];
    pohtoView.tag = 1115;
    [view addSubview:pohtoView];
    [self ctreatePhotographView:pohtoView title:@"户型图" tag:101+n];
    NSArray * array = @[@"0"];
    [_imageArrays3 addObject:array];
    
    _viewFive.fY += 368+160*(s-1);
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight);
}
#pragma mark-删除户型
-(void)deleteHousePhotos:(UIButton *)button{
    CGFloat s = SCREEN_WIDTH / 375.0;
    NSUInteger n = _scrollView.subviews.count-5;
    NSInteger tag = button.superview.superview.tag;
    NSInteger m = n - (tag - 100);
    UIView *view = button.superview.superview;
    [_imageArrays3 removeObjectAtIndex:(tag-100)];
    
    for (int i = 1; i<= m; i++) {
        UIView *view = [_scrollView viewWithTag:(tag+i)];
        [view setTag:(tag+i -1)];
        view.fY -= 368+160*(s-1);
    }
    [view removeFromSuperview];
    _viewFive.fY -= 368+160*(s-1);
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight);
    
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
    if ([isDel isEqual:@"2"]) {
        [labelUnit setHidden:NO];
    }else{
        [labelUnit setHidden:YES];
    }
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"bb_delete-1"] forState:UIControlStateNormal];
    [button setEnlargeEdge:10];
    [button addTarget:self action:@selector(deleteHousePhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button];
    if ([isDel isEqual:@"1"]) {
        [button setEnabled:YES];
        [button setHidden:NO];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-15);
            make.top.equalTo(view.mas_top).offset(17);
            make.width.offset(15);
            make.height.offset(15);
        }];
    }else{
        [button setEnabled:NO];
        [button setHidden:YES];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(15);
            make.top.equalTo(view.mas_top).offset(17);
            make.width.offset(15);
            make.height.offset(15);
        }];
    }
    
    
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
    
    UILabel *titleNum = [[UILabel alloc] init];
    titleNum.tag = 40;
    [titleNum setHidden:YES];
    titleNum.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    titleNum.textColor = UIColorRBG(204, 204, 204);
    [view addSubview:titleNum];
    [titleNum mas_makeConstraints:^(MASConstraintMaker *make) {
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
#pragma mark -懒加载
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 9; //
        _manager.configuration.videoMaxNum = 0;  //
        _manager.configuration.maxNum = 9;
        _manager.configuration.reverseDate = YES;
    }
    return _manager;
}
- (HXPhotoManager *)managerTwos {
    if (!_managerTwos) {
        _managerTwos = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _managerTwos.configuration.saveSystemAblum = YES;
        _managerTwos.configuration.photoMaxNum = 9; //
        _managerTwos.configuration.videoMaxNum = 0;  //
        _managerTwos.configuration.maxNum = 9;
        _managerTwos.configuration.reverseDate = YES;
    }
    return _managerTwos;
}
- (HXPhotoManager *)managerThrees {
    if (!_managerThrees) {
        _managerThrees = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _managerThrees.configuration.saveSystemAblum = YES;
        _managerThrees.configuration.photoMaxNum = 9; //
        _managerThrees.configuration.videoMaxNum = 0;  //
        _managerThrees.configuration.maxNum = 9;
        _managerThrees.configuration.reverseDate = YES;
    }
    return _managerThrees;
}
- (HXPhotoManager *)managerFours {
    if (!_managerFours) {
        _managerFours = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _managerFours.configuration.saveSystemAblum = YES;
        _managerFours.configuration.photoMaxNum = 3; //
        _managerFours.configuration.videoMaxNum = 0;  //
        _managerFours.configuration.maxNum = 3;
        _managerFours.configuration.reverseDate = YES;
    }
    return _managerFours;
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
    
    CGFloat width = view.fWidth;
    if (tag == 10) {
        _photoView = [HXPhotoView photoManager:self.manager];
        _photoView.frame = CGRectMake(kPhotoViewMargin, 53, width - kPhotoViewMargin * 2, 0);
        _photoView.lineCount = 3;
        _photoView.spacing = 24;
        _photoView.previewStyle = HXPhotoViewPreViewShowStyleDark;
        _photoView.outerCamera = YES;
        _photoView.delegate = self;
        _photoView.deleteImageName = @"delete";
        _photoView.addImageName = @"zd_camera";
        _photoView.tag = tag;
        _photoView.backgroundColor = [UIColor whiteColor];
        [view addSubview:_photoView];
        [_photoView refreshView];
    }else if (tag == 11){
        _photoViewTwos = [HXPhotoView photoManager:self.managerTwos];
        _photoViewTwos.frame = CGRectMake(kPhotoViewMargin, 53, width - kPhotoViewMargin * 2, 0);
        _photoViewTwos.lineCount = 3;
        _photoViewTwos.spacing = 24;
        _photoViewTwos.previewStyle = HXPhotoViewPreViewShowStyleDark;
        _photoViewTwos.outerCamera = YES;
        _photoViewTwos.delegate = self;
        _photoViewTwos.deleteImageName = @"delete";
        _photoViewTwos.addImageName = @"zd_camera";
        _photoViewTwos.tag = tag;
        _photoViewTwos.backgroundColor = [UIColor whiteColor];
        [view addSubview:_photoViewTwos];
        [_photoViewTwos refreshView];
    }else if (tag == 12){
        _photoViewThrees = [HXPhotoView photoManager:self.managerThrees];
        _photoViewThrees.frame = CGRectMake(kPhotoViewMargin, 53, width - kPhotoViewMargin * 2, 0);
        _photoViewThrees.lineCount = 3;
        _photoViewThrees.spacing = 24;
        _photoViewThrees.previewStyle = HXPhotoViewPreViewShowStyleDark;
        _photoViewThrees.outerCamera = YES;
        _photoViewThrees.delegate = self;
        _photoViewThrees.deleteImageName = @"delete";
        _photoViewThrees.addImageName = @"zd_camera";
        _photoViewThrees.tag = tag;
        _photoViewThrees.backgroundColor = [UIColor whiteColor];
        [view addSubview:_photoViewThrees];
        [_photoViewThrees refreshView];
    }else {
        _photoViewFours = [HXPhotoView photoManager:self.managerFours];
        _photoViewFours.frame = CGRectMake(kPhotoViewMargin, 53, width - kPhotoViewMargin * 2, 0);
        _photoViewFours.lineCount = 3;
        _photoViewFours.spacing = 24;
        _photoViewFours.previewStyle = HXPhotoViewPreViewShowStyleDark;
        _photoViewFours.outerCamera = YES;
        _photoViewFours.delegate = self;
        _photoViewFours.deleteImageName = @"delete";
        _photoViewFours.addImageName = @"zd_camera";
        _photoViewFours.tag = tag;
        _photoViewFours.backgroundColor = [UIColor whiteColor];
        [view addSubview:_photoViewFours];
        [_photoViewFours refreshView];
    }
}
//修改view的高度
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame
{

    NSInteger m = _scrollView.subviews.count-5;
    NSInteger tag = photoView.tag;
    NSInteger h = frame.size.height+68;
    
    if(tag == 10){
        NSInteger n = h - _viewOne.fHeight;
        _viewOne.fHeight += n;
        _viewTwo.fY += n;
        _viewThree.fY += n;
        _viewFour.fY += n;
        _viewFive.fY += n;
        if(m>0){
            for (int i = 1; i<=m; i++) {
                UIView *view = [_scrollView viewWithTag:(100+i)];
                view.fY += n;
            }
        }
    }
    if(tag == 11){
        NSInteger n = h - _viewTwo.fHeight;
        _viewTwo.fHeight += n;
        _viewThree.fY += n;
        _viewFour.fY += n;
        _viewFive.fY += n;
        if(m>0){
            for (int i = 1; i<=m; i++) {
                UIView *view = [_scrollView viewWithTag:(100+i)];
                view.fY += n;
            }
        }
    }
    if(tag == 12){
        NSInteger n = h - _viewThree.fHeight;
        _viewThree.fHeight += n;
        _viewFour.fY += n;
        _viewFive.fY += n;
        if(m>0){
            for (int i = 1; i<=m; i++) {
                UIView *view = [_scrollView viewWithTag:(100+i)];
                view.fY += n;
            }
        }
    }
    
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight);
}

-(void)photoListViewControllerDidDone:(HXPhotoView *)photoView allList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSInteger tag = photoView.tag;
    NSMutableArray<UIImage *> *imageList = [NSMutableArray array];
    for (HXPhotoModel *modelOne in allList) {
//        NSSLog(@"%@",modelOne.thumbPhoto);
        [imageList addObject:modelOne.thumbPhoto];
    }
    [self findUploadData:imageList tag:tag];
}
//获取文件上传信息
-(void)findUploadData:(NSArray<UIImage *> *)imageList tag:(NSInteger)tag{
    
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
            
            if (imageList.count == 0) {
                if(tag == 10){
                    _imageArray = imageList;
                    _imageArrays = nil;
                }else if(tag == 11){
                    _imageArray1 = imageList;
                    _imageArrays1 = nil;
                }else if(tag == 12){
                    _imageArray2 = imageList;
                    _imageArrays2 = nil;
                }else{
                    NSArray * array = @[@"0"];
                    [_imageArrays3 replaceObjectAtIndex:(tag-100) withObject:array];
                }
                return ;
            }
            [WZOSSImageUploader asyncUploadImages:imageList data:dacty complete:^(NSArray<NSString *> * _Nonnull names, UploadImageState state) {
               
                if(tag == 10){
                    _imageArray = imageList;
                    _imageArrays = names;
                    
                }else if(tag == 11){
                    _imageArray1 = imageList;
                    _imageArrays1 = names;
                    
                }else if(tag == 12){
                    _imageArray2 = imageList;
                    _imageArrays2 = names;
                    
                }else{
                    [_imageArrays3 replaceObjectAtIndex:(tag-100) withObject:names];
                    
                }
            }];
        }else{
            [SVProgressHUD showInfoWithStatus:@"获取上传凭证失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight+220);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight);
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
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight);
    [self.view endEditing:YES];
}
-(void)touches{
    _scrollView.contentSize = CGSizeMake(0, _viewFive.fY+_viewFive.fHeight);
    [self.view endEditing:YES];
}
@end
