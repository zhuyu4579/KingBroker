//
//  WZJionStoreAndStoreHeadController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/8/6.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import "WZAlertView.h"
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "ZDMapController.h"
#import "WZTabBarController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZJionStoreAndStoreHeadController.h"

@interface WZJionStoreAndStoreHeadController ()<UITextFieldDelegate>
//滑动页面
@property(nonatomic,strong)UIScrollView *scrollView;
//文字一
@property(nonatomic,strong)UILabel *labelOne;
//文字二
@property(nonatomic,strong)UILabel *labelTwo;
//第一个view
@property(nonatomic,strong)UIView *viewOne;
//第二个view
@property(nonatomic,strong)UIView *viewTwo;
//第三个view
@property(nonatomic,strong)UIView *viewThree;
//经纪人按钮
@property(nonatomic,strong)UIButton *agentButton;
@property(nonatomic,strong)UIView *ineAgent;
//门店负责人按钮
@property(nonatomic,strong)UIButton *headButton;
@property(nonatomic,strong)UIView *ineHead;
//名字
@property(nonatomic,strong)UITextField *name;
//提交按钮
@property(nonatomic,strong)UIButton *button;
//有编码无编码
@property(nonatomic,strong)NSString *codeType;
//有编码无编码背景
@property(nonatomic,strong)UIImageView *codeImageView;
//有编码按钮
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UIView *ineCode;
//无编码按钮
@property(nonatomic,strong)UIButton *noCodeButton;
@property(nonatomic,strong)UIView *ineNoCode;
//有编码模块
@property(nonatomic,strong)UIView *codeViews;
//无编码模块
@property(nonatomic,strong)UIView *noCodeViews;
//有编码-编码
@property(nonatomic,strong)UITextField *code;
//无编码-门店名称
@property(nonatomic,strong)UITextField *storeName;
//无编码-门店位置
@property(nonatomic,strong)UILabel *storePosition;
@property(nonatomic,strong)NSString *lnglat;
@property(nonatomic,strong)NSString *adCode;
//无编码-门店地址
@property(nonatomic,strong)UITextField *storeAddress;
//无编码名片正面
@property(nonatomic,strong)UIImage *cardImage;
//无编码名片反面
@property(nonatomic,strong)UIImage *cardSideImage;
@end

@implementation WZJionStoreAndStoreHeadController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    _codeType = @"0";
    //创建控件
    [self createControl];
}
#pragma mark - 创建控件
-(void)createControl{
     float n = [UIScreen mainScreen].bounds.size.width/375.0;
    //创建UISrceenView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-JF_BOTTOM_SPACE-49)];
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    //创建背景图
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_background"];
    [imageView sizeToFit];
    [_scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left);
        make.top.equalTo(_scrollView.mas_top).offset(-kApplicationStatusBarHeight);
        make.width.offset(self.view.fWidth);
        make.height.offset(304*n);
    }];
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 22, 15, 15)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close_login"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setEnlargeEdge:44];
    [_scrollView addSubview:closeButton];
   
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, closeButton.fHeight+closeButton.fY+18,200, 18)];
    title.text = @"加入门店";
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    title.textColor = UIColorRBG(255, 168, 66);
    [_scrollView addSubview:title];
   
    //文字一
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"1.门店编码是经服APP合作门店的唯一标识，你可咨询你的店长或者同事";
    labelOne.numberOfLines = 2;
    labelOne.textColor = UIColorRBG(159, 129, 79);
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _labelOne = labelOne;
    [_scrollView addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(title.mas_bottom).offset(13);
        make.width.offset(210*n);
    }];
    //文字二
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"2.加入门店后报备客户，成交后可赚取佣金；APP内做任 务赚取现金奖励";
    labelTwo.numberOfLines = 2;
    labelTwo.textColor = UIColorRBG(159, 129, 79);
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    _labelTwo = labelTwo;
    [_scrollView addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollView.mas_left).offset(15);
        make.top.equalTo(labelOne.mas_bottom).offset(9);
        make.width.offset(210*n);
    }];
    //创建名字
    [self createName];
    //创建按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"加入门店" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = UIColorRBG(255, 224, 0);
    _button = button;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(JF_BOTTOM_SPACE+49);
        make.width.offset(self.view.fWidth);
    }];
    if ([_type isEqual:@"1"]) {
        _scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight-49-JF_BOTTOM_SPACE);
    }else{
        _scrollView.contentSize = CGSizeMake(0,_viewThree.fHeight+kApplicationStatusBarHeight+_viewThree.fY);
    }
}

#pragma mark -创建名字
-(void)createName{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(13, _labelTwo.fY+_labelTwo.fHeight+20, self.view.fWidth-26, 139)];
    _viewOne = view;
    [_scrollView addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_background_2"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.height.offset(139);
        make.width.offset(self.view.fWidth-26);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(view.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //经纪人
    UIButton *agentButton = [[UIButton alloc] init];
    [agentButton setTitle:@"经纪人" forState:UIControlStateNormal];
    [agentButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    agentButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [agentButton addTarget:self action:@selector(agentButton:) forControlEvents:UIControlEventTouchUpInside];
    _agentButton = agentButton;
    [view addSubview:agentButton];
    [agentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    //划线
    UIView *ineAgent = [[UIView alloc] init];
    ineAgent.backgroundColor = [UIColor clearColor];
    _ineAgent = ineAgent;
    [view addSubview:ineAgent];
    [ineAgent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(17);
        make.top.equalTo(agentButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    //门店负责人
    UIButton *headButton = [[UIButton alloc] init];
    [headButton setTitle:@"门店负责人" forState:UIControlStateNormal];
    [headButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    headButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [headButton addTarget:self action:@selector(headButton:) forControlEvents:UIControlEventTouchUpInside];
    _headButton = headButton;
    [view addSubview:headButton];
    [headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agentButton.mas_right).offset(40);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(80);
    }];
    //划线
    UIView *ineHead = [[UIView alloc] init];
    ineHead.backgroundColor = [UIColor clearColor];
    _ineHead = ineHead;
    [view addSubview:ineHead];
    [ineHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agentButton.mas_right).offset(40);
        make.top.equalTo(headButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(80);
    }];
    //经纪人模块
    [self agrentView];
    //门店负责人模块
    [self headView];
    if ([_jionType isEqual:@"1"]) {
        [agentButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineAgent.backgroundColor = UIColorRBG(255, 224, 0);
        [_viewThree setHidden:YES];
        [_viewTwo setHidden:NO];
    }else{
        [headButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineHead.backgroundColor = UIColorRBG(255, 224, 0);
        [_viewTwo setHidden:YES];
        [_viewThree setHidden:NO];
    }
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"名字";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(ine.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *name = [[UITextField alloc] init];
    name.placeholder = @"填写个人姓名";
    name.textColor = UIColorRBG(68, 68, 68);
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    name.delegate = self;
    name.keyboardType = UIKeyboardTypeDefault;
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _name = name;
    [view addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 224, 0);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(name.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    
}
#pragma mark -经纪人模块
-(void)agrentView{
    UIView *view = [[UIView alloc] init];
    _viewTwo = view;
    [_scrollView addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    if ([_codeType isEqual:@"0"]) {
        imageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 139);
        imageView.image = [UIImage imageNamed:@"rz_background_3"];
    }else{
        imageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 286);
        imageView.image = [UIImage imageNamed:@"rz_wbm_pic_2"];
    }
    _codeImageView = imageView;
    [view addSubview:imageView];
    
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(view.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //有编码
    UIButton *codeButton = [[UIButton alloc] init];
    [codeButton setTitle:@"有编码" forState:UIControlStateNormal];
    [codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    codeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [codeButton addTarget:self action:@selector(codeButton:) forControlEvents:UIControlEventTouchUpInside];
    _codeButton = codeButton;
    [view addSubview:codeButton];
    [codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    //划线
    UIView *ineCode = [[UIView alloc] init];
    ineCode.backgroundColor = [UIColor clearColor];
    _ineCode = ineCode;
    [view addSubview:ineCode];
    [ineCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(codeButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    //无编码
    UIButton *noCodeButton = [[UIButton alloc] init];
    [noCodeButton setTitle:@"无编码" forState:UIControlStateNormal];
    [noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    noCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [noCodeButton addTarget:self action:@selector(noCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    _noCodeButton = noCodeButton;
    [view addSubview:noCodeButton];
    [noCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeButton.mas_right).offset(40);
        make.top.equalTo(view.mas_top).mas_offset(8);
        make.height.offset(35);
        make.width.offset(50);
    }];
    //划线
    UIView *ineNoCode = [[UIView alloc] init];
    ineNoCode.backgroundColor = [UIColor clearColor];
    _ineNoCode = ineNoCode;
    [view addSubview:ineNoCode];
    [ineNoCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeButton.mas_right).offset(40);
        make.top.equalTo(noCodeButton.mas_bottom).offset(4);
        make.height.offset(2);
        make.width.offset(50);
    }];
    [self codeView];
    [self noCodeView];
    if ([_codeType isEqual:@"0"]) {
        [noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        ineNoCode.backgroundColor = [UIColor clearColor];
        [codeButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineCode.backgroundColor = UIColorRBG(255, 224, 0);
        [_codeViews setHidden:NO];
        [_noCodeViews setHidden:YES];
    }else{
        [codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        ineCode.backgroundColor = [UIColor clearColor];
        [noCodeButton setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
        ineNoCode.backgroundColor = UIColorRBG(255, 224, 0);
        [_codeViews setHidden:YES];
        [_noCodeViews setHidden:NO];
    }
}
#pragma mark -门店负责人模块
-(void)headView{
    UIView *view = [[UIView alloc] init];
    _viewThree = view;
    [_scrollView addSubview:view];
    
}
#pragma mark -有编码模块
-(void)codeView{
    UIView *view = [[UIView alloc] init];
    _codeViews = view;
    [_viewTwo addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewTwo.mas_left);
        make.top.equalTo(_ineCode.mas_bottom);
        make.height.offset(91);
        make.width.offset(self.view.fWidth-26);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"门店编码";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *code = [[UITextField alloc] init];
    code.placeholder = @"填写门店编码";
    code.textColor = UIColorRBG(68, 68, 68);
    code.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    code.delegate = self;
    code.keyboardType = UIKeyboardTypeNumberPad;
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    _code = code;
    [view addSubview:code];
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 224, 0);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(code.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    
}
#pragma mark -无编码模块
-(void)noCodeView{
    UIView *view = [[UIView alloc] init];
    _noCodeViews = view;
    [_viewTwo addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewTwo.mas_left);
        make.top.equalTo(_ineCode.mas_bottom);
        make.height.offset(430);
        make.width.offset(self.view.fWidth-26);
    }];
    //门店名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"门店名称";
    nameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    nameLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(view.mas_top).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeName = [[UITextField alloc] init];
    storeName.placeholder = @"必填";
    storeName.textColor = UIColorRBG(68, 68, 68);
    storeName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeName.delegate = self;
    storeName.keyboardType = UIKeyboardTypeDefault;
    storeName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _storeName = storeName;
    [view addSubview:storeName];
    [storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *nameIne = [[UIView alloc] init];
    nameIne.backgroundColor = UIColorRBG(255, 224, 0);
    [view addSubview:nameIne];
    [nameIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeName.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    //门店位置
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = @"门店位置";
    positionLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    positionLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(nameIne.mas_top).offset(15);
        make.height.offset(13);
    }];
    UILabel *storePosition = [[UILabel alloc] init];
    storePosition.text = @"点击选择";
    storePosition.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storePosition.textColor = UIColorRBG(204, 204, 204);
    _storePosition = storePosition;
    [view addSubview:storePosition];
    [storePosition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionLabel.mas_bottom).offset(18);
        make.height.offset(13);
        make.width.offset(273);
    }];
    //下划线
    UIView  *positionIne = [[UIView alloc] init];
    positionIne.backgroundColor = UIColorRBG(255, 224, 0);
    [view addSubview:positionIne];
    [positionIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storePosition.mas_bottom).offset(15);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-97);
    }];
    UIButton *position = [[UIButton alloc] init];
    [position setBackgroundImage:[UIImage imageNamed:@"zc_map"] forState:UIControlStateNormal];
    [position addTarget:self action:@selector(positionButton:) forControlEvents:UIControlEventTouchUpInside];
    [position setEnlargeEdge:44];
    [view addSubview:position];
    [position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storePosition.mas_right).offset(14);
        make.top.equalTo(positionLabel.mas_bottom).offset(11);
        make.height.offset(26);
        make.width.offset(20);
    }];
    //下划线
    UIView  *positionInes = [[UIView alloc] init];
    positionInes.backgroundColor = UIColorRBG(255, 224, 0);
    [view addSubview:positionInes];
    [positionInes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storePosition.mas_right).offset(14);
        make.top.equalTo(position.mas_bottom).offset(9);
        make.height.offset(1);
        make.width.offset(21);
    }];
    //门店地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"门店地址";
    addressLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    addressLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(positionIne.mas_bottom).offset(15);
        make.height.offset(13);
    }];
    UITextField *storeAddress = [[UITextField alloc] init];
    storeAddress.placeholder = @"必填";
    storeAddress.textColor = UIColorRBG(68, 68, 68);
    storeAddress.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeAddress.delegate = self;
    storeAddress.keyboardType = UIKeyboardTypeDefault;
    storeAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
    _storeAddress = storeAddress;
    [view addSubview:storeAddress];
    [storeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(addressLabel.mas_bottom);
        make.height.offset(45);
        make.width.offset(self.view.fWidth-62);
    }];
    //下划线
    UIView  *addressIne = [[UIView alloc] init];
    addressIne.backgroundColor = UIColorRBG(255, 224, 0);
    [view addSubview:addressIne];
    [addressIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(storeAddress.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-62);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"rz_wbm_pic_3"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(_codeImageView.mas_bottom).offset(10);
        make.height.offset(183);
        make.width.offset(self.view.fWidth-26);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(8);
        make.top.equalTo(imageView.mas_top).offset(48);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-42);
    }];
    //名片
    UILabel *cardLabel = [[UILabel alloc] init];
    cardLabel.text = @"上传名片";
    cardLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    cardLabel.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:cardLabel];
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(18);
        make.top.equalTo(_codeImageView.mas_bottom).offset(25);
        make.height.offset(16);
    }];
    //名片正面
    UIButton *cardButton = [[UIButton alloc] init];
    [cardButton setBackgroundImage:[UIImage imageNamed:@"camera_zm"] forState:UIControlStateNormal];
    [cardButton addTarget:self action:@selector(cardButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardButton];
    [cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_centerX).offset(-36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
    //名片反面
    UIButton *cardSideButton = [[UIButton alloc] init];
    [cardSideButton setBackgroundImage:[UIImage imageNamed:@"camera_fm"] forState:UIControlStateNormal];
     [cardSideButton addTarget:self action:@selector(cardSideButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cardSideButton];
    [cardSideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).offset(36);
        make.top.equalTo(ine.mas_bottom).offset(15);
        make.height.offset(100);
        make.width.offset(100);
    }];
}
#pragma mark -设置滑动值
-(void)viewDidLayoutSubviews{
    _viewOne.frame = CGRectMake(13, _labelTwo.fY+_labelTwo.fHeight+20, self.view.fWidth-26, 139);
    _viewTwo.frame = CGRectMake(13, _viewOne.fY+_viewOne.fHeight+10, self.view.fWidth-26, 476);
    _viewThree.frame = CGRectMake(13, _viewOne.fY+_viewOne.fHeight+10, self.view.fWidth-26, 435);
}
#pragma mark -经纪人
-(void)agentButton:(UIButton *)button{
    [self touches];
    [_headButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineHead.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineAgent.backgroundColor = UIColorRBG(255, 224, 0);
    [_viewThree setHidden:YES];
    [_viewTwo setHidden:NO];
    if([_codeType isEqual:@"0"]){
        _scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight-49-JF_BOTTOM_SPACE);
    }else{
        _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY);
    }
}
#pragma mark -门店负责人
-(void)headButton:(UIButton *)button{
    [self touches];
    [_agentButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineAgent.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineHead.backgroundColor = UIColorRBG(255, 224, 0);
    [_viewThree setHidden:NO];
    [_viewTwo setHidden:YES];
    _scrollView.contentSize = CGSizeMake(0,_viewThree.fHeight+kApplicationStatusBarHeight+_viewThree.fY);
}
#pragma mark -有编码按钮
-(void)codeButton:(UIButton *)button{
    [self touches];
    [_noCodeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineNoCode.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineCode.backgroundColor = UIColorRBG(255, 224, 0);
    _codeImageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 139);
    _codeImageView.image = [UIImage imageNamed:@"rz_background_3"];
    _codeType = @"0";
    [_codeViews setHidden:NO];
    [_noCodeViews setHidden:YES];
    _scrollView.contentSize = CGSizeMake(0, self.view.fHeight-kApplicationStatusBarHeight-49-JF_BOTTOM_SPACE);
}
#pragma mark -无编码按钮
-(void)noCodeButton:(UIButton *)button{
    [self touches];
    [_codeButton setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    _ineCode.backgroundColor = [UIColor clearColor];
    [button setTitleColor:UIColorRBG(51, 51, 51) forState:UIControlStateNormal];
    _ineNoCode.backgroundColor = UIColorRBG(255, 224, 0);
    _codeImageView.frame = CGRectMake(0, 0, self.view.fWidth-26, 286);
    _codeImageView.image = [UIImage imageNamed:@"rz_wbm_pic_2"];
    _codeType = @"1";
    [_codeViews setHidden:YES];
    [_noCodeViews setHidden:NO];
    _scrollView.contentSize = CGSizeMake(0, _viewTwo.fHeight+kApplicationStatusBarHeight+_viewTwo.fY);
}
#pragma mark -无编码-选择位置
-(void)positionButton:(UIButton *)button{
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _storePosition.textColor = UIColorRBG(51, 51, 51);
        _storePosition.text = [address valueForKey:@"address"];
        _lnglat = [address valueForKey:@"lnglat"];
        _adCode = [address valueForKey:@"adcode"];
    };
}
#pragma mark -无编码-名片正面
-(void)cardButton:(UIButton *)button{
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
        [button setBackgroundImage:image forState:UIControlStateNormal];
        _cardImage = image;
    };
}
#pragma mark -无编码-名片反面
-(void)cardSideButton:(UIButton *)button{

    WZAlertView *redView = [WZAlertView new];
    
    redView.imageName = @"card_1";
    
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        _cardSideImage = image;
    };
}
#pragma mark -关闭页面
-(void)closeButton{
    if([_types isEqual:@"1"]){
        //跳转至我的页面
        WZTabBarController *tar = [[WZTabBarController alloc] init];
        tar.selectedViewController = [tar.viewControllers objectAtIndex:2];
        [self.navigationController presentViewController:tar animated:YES completion:nil];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_name == textField) {
        if (toBeString.length>16) {
            return NO;
        }
    }
    if (_code == textField) {
        if (toBeString.length>15) {
            return NO;
        }
    }
    if (toBeString.length>20) {
        return NO;
    }
    return YES;
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  [_name resignFirstResponder];
  [_code resignFirstResponder];
  [_storeName resignFirstResponder];
  [_storeAddress resignFirstResponder];
}
-(void)touches{
    [_name resignFirstResponder];
    [_code resignFirstResponder];
    [_storeName resignFirstResponder];
    [_storeAddress resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
