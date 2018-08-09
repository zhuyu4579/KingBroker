//
//  WZBelongedStoreController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZBelongedStoreController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "GKCover.h"
#import "WZAuthenticationController.h"
#import <SVProgressHUD.h>
#import "WZApplyStorePersonController.h"
#import "WZUpdateStoreController.h"
#import "WZNavigationController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZJionStoreAndStoreHeadController.h"
#import "WZStoreAdministrationController.h"
@interface WZBelongedStoreController ()

@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)UIButton *addrButton;
@property(nonatomic,strong)UITextField *labelThreeAddress;

//门店认证
@property(nonatomic,strong)NSString *realtorStatus;
//门店编码
@property(nonatomic,strong)NSString *storeCode;
//门店名称
@property(nonatomic,strong)NSString *storeName;
//门店位置
@property(nonatomic,strong)NSString *cityName;
//门店地址
@property(nonatomic,strong)NSString *cityAdder;
//门店负责人
@property(nonatomic,strong)NSString *dutyFlag;

@end

@implementation WZBelongedStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"所属门店";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _dutyFlag = [ user objectForKey:@"dutyFlag"];
    _storeName = [ user objectForKey:@"storeName"];
    _storeCode = [ user objectForKey:@"storeCode"];
    _cityAdder = [ user objectForKey:@"addr"];
    _cityName = [ user objectForKey:@"cityName"];
    _realtorStatus = [ user objectForKey:@"realtorStatus"];
    
    //创建控件
    if ([_realtorStatus isEqual:@"2"]) {
        //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(edit) title:@"编辑"];
        //已加入门店
        [self setUpStore];
    }else{
       // 未加入门店
        [self setUpNoStore];
    }
}
//编辑按钮
-(void)edit{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(success) title:@"完成"] ;
    _addrButton.enabled = YES;
    [_addrButton setHidden:NO];
    _labelThreeAddress.enabled = YES;
}
//完成按钮
-(void)success{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(edit) title:@"编辑"] ;
    _addrButton.enabled = NO;
    [_addrButton setHidden:YES];
    _labelThreeAddress.enabled = NO;
}
//未加入门店
-(void)setUpNoStore{
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
    label.text = @"太低调了，连个门店都没有~";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(29);
        make.height.offset(13);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"加入门店" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    button.layer.cornerRadius = 4.0;
    [button addTarget:self action:@selector(joinStore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(140);
        make.width.offset(215);
        make.height.offset(49);
    }];
}
//加入门店
-(void)setUpStore{
    
    UIView *viewOne = [[UIView alloc] init];
    viewOne.frame = CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, 151);
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"choose"];
    [viewOne addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(viewOne.mas_top).offset(24);
        make.width.offset(47);
        make.height.offset(47);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"已加入门店";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.height.offset(13);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    button.layer.cornerRadius = 12.5;
    [button addTarget:self action:@selector(ApplyStoreDuty) forControlEvents:UIControlEventTouchUpInside];
    if ([_dutyFlag isEqual:@"0"]) {
        [button setTitle:@"申请门店负责人" forState:UIControlStateNormal];
    }else if([_dutyFlag isEqual:@"2"]){
        [button setTitle:@"门店管理" forState:UIControlStateNormal];
        button.enabled = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = UIColorRBG(3, 133, 219);
        [button removeTarget:self action:@selector(ApplyStoreDuty) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(storeAdministration) forControlEvents:UIControlEventTouchUpInside];
    }else if([_dutyFlag isEqual:@"1"]){
        [button setTitle:@"门店负责人认证中" forState:UIControlStateNormal];
        button.enabled = NO;
    }else{
        [button setTitle:@"门店负责人认证失败" forState:UIControlStateNormal];
    }
    _button = button;
    [viewOne addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(15);
        make.width.offset(150);
        make.height.offset(25);
    }];
    
    UIView *viewTwo = [[UIView alloc] init];
    viewTwo.frame = CGRectMake(0,viewOne.fY + viewOne.fHeight +10, self.view.fWidth, 101);
    viewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTwo];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"门店名称";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwo.textColor =UIColorRBG(153, 153, 153);
    [viewTwo addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_top).offset(18);
        make.height.offset(14);
    }];
    UILabel *labelTwoName = [[UILabel alloc] init];
    labelTwoName.text = _storeName;
    labelTwoName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwoName.textColor =UIColorRBG(68, 68, 68);
    [viewTwo addSubview:labelTwoName];
    [labelTwoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTwo.mas_right).offset(-15);
        make.top.equalTo(viewTwo.mas_top).offset(18);
        make.height.offset(14);
    }];
    UIView *ineView = [[UIView alloc] init];
    ineView.frame = CGRectMake(14, 50, viewTwo.fWidth-15, 1);
    ineView.backgroundColor = UIColorRBG(243, 243, 243);
    [viewTwo addSubview:ineView];
    
    UILabel *labelTwos = [[UILabel alloc] init];
    labelTwos.text = @"门店编码";
    labelTwos.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwos.textColor =UIColorRBG(153, 153, 153);
    [viewTwo addSubview:labelTwos];
    [labelTwos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(ineView.mas_bottom).offset(18);
        make.height.offset(14);
    }];
    UILabel *labelTwoCode = [[UILabel alloc] init];
    labelTwoCode.text = _storeCode;
    labelTwoCode.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwoCode.textColor =UIColorRBG(68, 68, 68);
    [viewTwo addSubview:labelTwoCode];
    [labelTwoCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTwo.mas_right).offset(-15);
        make.top.equalTo(ineView.mas_bottom).offset(18);
        make.height.offset(14);
    }];
    
    
    UIView *viewThree = [[UIView alloc] init];
    viewThree.frame = CGRectMake(0, viewTwo.fY+viewTwo.fHeight+10, self.view.fWidth, 101);
    viewThree.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewThree];
    
    UILabel *labelThree = [[UILabel alloc] init];
    labelThree.text = @"门店位置";
    labelThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelThree.textColor =UIColorRBG(153, 153, 153);
    [viewThree addSubview:labelThree];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).offset(15);
        make.top.equalTo(viewThree.mas_top).offset(18);
        make.height.offset(14);
    }];
   
    UILabel *labelThreeAddr = [[UILabel alloc] init];
    labelThreeAddr.text = _cityName;
    labelThreeAddr.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelThreeAddr.textColor =UIColorRBG(68, 68, 68);
    [viewThree addSubview:labelThreeAddr];
    [labelThreeAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewThree.mas_right).offset(-15);
        make.top.equalTo(viewThree.mas_top).offset(18);
        make.height.offset(14);
    }];
    //选择门店位置
    UIButton *addrButton = [[UIButton alloc] init];
    [addrButton setBackgroundImage:[UIImage imageNamed:@"place"] forState:UIControlStateNormal];
    [addrButton addTarget:self action:@selector(selectStoreAddress) forControlEvents:UIControlEventTouchUpInside];
    [addrButton setEnlargeEdgeWithTop:16 right:200 bottom:16 left:200];
    addrButton.enabled = NO;
    [addrButton setHidden:YES];
    _addrButton  = addrButton;
    [viewThree addSubview:addrButton];
    [addrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(labelThreeAddr.mas_left).offset(-10);
        make.top.equalTo(viewThree.mas_top).offset(15);
        make.height.offset(21);
        make.width.offset(17);
    }];
    
    UIView *ineViews = [[UIView alloc] init];
    ineViews.frame = CGRectMake(14, 50, viewTwo.fWidth-15, 1);
    ineViews.backgroundColor = UIColorRBG(243, 243, 243);
    [viewThree addSubview:ineViews];
    
    UILabel *labelThrees = [[UILabel alloc] init];
    labelThrees.text = @"门店地址";
    labelThrees.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelThrees.textColor =UIColorRBG(153, 153, 153);
    [viewThree addSubview:labelThrees];
    [labelThrees mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewThree.mas_left).offset(15);
        make.top.equalTo(ineViews.mas_bottom).offset(18);
        make.height.offset(14);
    }];
    UITextField *labelThreeAddress = [[UITextField alloc] init];
    labelThreeAddress.placeholder = @"必填";
    labelThreeAddress.text = _cityAdder;
    labelThreeAddress.textAlignment = NSTextAlignmentRight;
    _labelThreeAddress = labelThreeAddress;
    labelThreeAddress.enabled = NO;
    labelThreeAddress.keyboardType = UIKeyboardTypeDefault;
    labelThreeAddress.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelThreeAddress.textColor =UIColorRBG(68, 68, 68);
    [viewThree addSubview:labelThreeAddress];
    [labelThreeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewThree.mas_right).offset(-15);
        make.top.equalTo(ineViews.mas_bottom);
        make.width.offset(280);
        make.height.offset(50);
    }];
    //更换门店
    UIButton *updateStore = [[UIButton alloc] init];
    [updateStore setTitle:@"更换绑定门店" forState:UIControlStateNormal];
    [updateStore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    updateStore.backgroundColor = UIColorRBG(3, 133, 219);
    updateStore.titleLabel.font = [UIFont systemFontOfSize:16];
    [updateStore addTarget:self action:@selector(updateStore) forControlEvents:UIControlEventTouchUpInside];
    updateStore.layer.cornerRadius = 5.0;
    [self.view addSubview:updateStore];
    [updateStore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(viewThree.mas_bottom).offset(65);
        make.height.offset(44);
        make.width.offset(self.view.fWidth - 30);
    }];
    
}
//选择门店位置
-(void)selectStoreAddress{
    
}
//申请门店负责人
-(void)ApplyStoreDuty{
       //跳转申请负责人
        WZApplyStorePersonController *applyVc = [[WZApplyStorePersonController alloc] init];
        applyVc.statusBlock = ^(NSString *status) {
            if ([status isEqual:@"0"]) {
                [_button setTitle:@"申请门店负责人" forState:UIControlStateNormal];
            }else if([status isEqual:@"2"]){
                [_button setTitle:@"门店管理" forState:UIControlStateNormal];
                _button.enabled = YES;
                [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _button.backgroundColor = UIColorRBG(3, 133, 219);
                [_button removeTarget:self action:@selector(ApplyStoreDuty) forControlEvents:UIControlEventTouchUpInside];
                [_button addTarget:self action:@selector(storeAdministration) forControlEvents:UIControlEventTouchUpInside];
            }else if([status isEqual:@"1"]){
                [_button setTitle:@"门店负责人认证中" forState:UIControlStateNormal];
                _button.enabled = NO;
            }else{
                [_button setTitle:@"门店负责人认证失败" forState:UIControlStateNormal];
            }
        };
        [self.navigationController pushViewController:applyVc animated:YES];
}
//门店管理
-(void)storeAdministration{
    WZStoreAdministrationController *store = [[WZStoreAdministrationController alloc] init];
    store.url = [NSString stringWithFormat:@"%@/store/getuuid.html",HTTPH5];
    WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:store];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//更换门店
-(void)updateStore{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(270, 457);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, 392)];
    imageView.image = [UIImage imageNamed:@"pop_3"];
    [view addSubview:imageView];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelOne.text = @"1.更换门店需要下一家门店的门店编码或名片\n\n2.更换门店前的订单、客户、业绩、佣金，只和上一家门店关联\n\n3.更换门店审核成功后的订单、客户、业绩、佣金将和新门店关联";
    labelOne.numberOfLines = 0;
    [view addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(158);
        make.width.offset(view.fWidth - 60);
    }];
    UIButton *storeUpdate = [[UIButton alloc] init];
    [storeUpdate setTitle:@"确认更换门店" forState:UIControlStateNormal];
    [storeUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeUpdate addTarget:self action:@selector(updateStores) forControlEvents:UIControlEventTouchUpInside];
    storeUpdate.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    storeUpdate.backgroundColor = UIColorRBG(3, 133, 219);
    storeUpdate.layer.cornerRadius = 4.0;
    [view addSubview:storeUpdate];
    [storeUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(labelOne.mas_bottom).offset(46);
        make.width.offset(view.fWidth - 60);
        make.height.offset(35);
    }];
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"closes"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(35);
        make.width.offset(30);
        make.height.offset(30);
    }];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:NO];
}
//确认更换门店
-(void)updateStores{
    [self close];
    WZUpdateStoreController *store = [[WZUpdateStoreController alloc] init];
    [self.navigationController pushViewController:store animated:YES];
}
//关闭提示框
-(void)close{
    [GKCover hide];
}
-(void)joinStore{
    if ([_realtorStatus isEqual:@"1"]) {
        [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
    }else{
        WZJionStoreAndStoreHeadController *JionStore = [[WZJionStoreAndStoreHeadController alloc] init];
        JionStore.type = @"1";
        JionStore.jionType = @"1";
        WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.labelThreeAddress resignFirstResponder];
}

@end
