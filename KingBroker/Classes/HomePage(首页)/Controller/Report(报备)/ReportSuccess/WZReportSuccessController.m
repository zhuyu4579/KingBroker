//
//  WZReportSuccessController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZReportSuccessController.h"
#import "UIBarButtonItem+Item.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZReportSuccessTableView.h"
#import "WZBoaringController.h"
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import "WZLikeProjectItem.h"
#import "WZTabBarController.h"
@interface WZReportSuccessController ()
//楼盘名
@property (nonatomic,strong)UILabel *labelOne;

//上客时间
@property (nonatomic,strong)UILabel *labelFour;
//未签约提醒
@property (nonatomic,strong)UILabel *labels;
//未签约提醒
@property (nonatomic,strong)UILabel *labelRed;
//电话
@property (nonatomic,strong)UIButton *phone;

@property (nonatomic,strong)UIButton *resportButton;

@property (nonatomic,strong)UIButton *viewOrder;
//猜你喜欢
@property(nonatomic,strong)NSDictionary *likes;
@end

@implementation WZReportSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNarItem];
    [self ceartorController];
    //填写数据
    [self Datas];
    //设置弹框样式
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];

}
-(void)Datas{
    //猜你喜欢
    if (!_reportData) {
        [SVProgressHUD showInfoWithStatus:@"网络有问题哦!"];
        return;
    }
    NSDictionary *like = [_reportData valueForKey:@"projectList"];
    _likes = like;
    //数据
    NSDictionary *contacts = [_reportData valueForKey:@"contacts"];
    _labelOne.text = [contacts valueForKey:@"projectName"];
     _labelFour.text = [NSString stringWithFormat:@"报备成功，最晚上客时间%@",[contacts valueForKey:@"boardingEnd"]];
    
    if ([_status isEqual:@"0"]) {
        [_labels setHidden:NO];
        [_phone setHidden:NO];
        [_labelRed setHidden:NO];
    }else{
        [_labels setHidden:YES];
        [_phone setHidden:YES];
        [_labelRed setHidden:YES];
    }
    
}
-(void)ceartorController{
   
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(15,kApplicationStatusBarHeight+88,self.view.fWidth-30,284);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((self.view.fWidth-47)/2,kApplicationStatusBarHeight+64,47,47);
    imageView.image = [UIImage imageNamed:@"succeed"];
    [self.view addSubview:imageView];
    
    _labelOne = [[UILabel alloc] init];
    _labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    _labelOne.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:_labelOne];
    [_labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).with.offset(43);
        make.height.mas_offset(17);
    }];
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, view.fWidth, 1)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:ineView];
    
    _labelFour = [[UILabel alloc] init];
    _labelFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _labelFour.textColor = UIColorRBG(102, 102, 102);
    [view addSubview:_labelFour];
    [_labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(ineView.mas_bottom).with.offset(25);
        make.height.mas_offset(14);
    }];
    UILabel *label  = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    label.textColor = UIColorRBG(187, 187, 187);
    label.numberOfLines = 0;
    label.text = @"你所在经纪门店未和该楼盘签约， 在最晚上客时间内楼盘负责人会联系你确认签约事宜，或你可致电";
    _labels = label;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(_labelFour.mas_bottom).with.offset(15);
        make.width.mas_offset(view.fWidth - 70);
    }];
    
    UIButton *telphone  = [[UIButton alloc] init];
    telphone.titleLabel.textAlignment = NSTextAlignmentLeft;
    telphone.titleLabel.font = [UIFont systemFontOfSize:12];
    [telphone setTitle:_telphone forState:UIControlStateNormal];
    [telphone setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _phone = telphone;
    [telphone addTarget:self action:@selector(playPhone:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(33);
        make.top.equalTo(label.mas_bottom);
        make.width.mas_offset(85);
        make.height.mas_offset(20);
    }];
    UILabel *labelRed  = [[UILabel alloc] init];
    labelRed.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    labelRed.textColor = UIColorRBG(255, 107, 1);
    labelRed.numberOfLines = 0;
    labelRed.text = @"注意:楼盘只会和门店签约,未签约时上客有可能无法结佣";
    _labelRed = labelRed;
    [view addSubview:labelRed];
    [labelRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(telphone.mas_bottom);
        make.width.mas_offset(view.fWidth - 70);
    }];
    //按钮一
    _resportButton = [[UIButton alloc] init];
    [_resportButton setTitle:@"查看订单" forState: UIControlStateNormal];
    [_resportButton setTitleColor: [UIColor colorWithRed:3/255.0 green:133/255.0 blue:219/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    _resportButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    
    _resportButton.layer.cornerRadius = 4.0;
    _resportButton.layer.masksToBounds = YES;
     [_resportButton.layer setBorderWidth:1.0];
    _resportButton.layer.borderColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0].CGColor;
    
    [_resportButton addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_resportButton];
    [_resportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_centerX).with.offset(-25);
        make.bottom.equalTo(view.mas_bottom).with.offset(-25);
        make.width.mas_offset(105);
        make.height.mas_offset(40);
    }];
    //按钮一
    _viewOrder = [[UIButton alloc] init];
    [_viewOrder setTitle:@"继续报备" forState: UIControlStateNormal];
    [_viewOrder setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    
    _viewOrder.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    
    _viewOrder.layer.cornerRadius = 4.0;
    _viewOrder.layer.masksToBounds = YES;
    _viewOrder.backgroundColor = UIColorRBG(3, 133, 219);
    
    [_viewOrder addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_viewOrder];
    [_viewOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_centerX).with.offset(25);
        make.bottom.equalTo(view.mas_bottom).with.offset(-25);
        make.width.mas_offset(105);
        make.height.mas_offset(40);
    }];
   
    //创建为你推荐
    UIView *likeView = [[UIView alloc] init];
    likeView.frame = CGRectMake(0,view.fY+view.fHeight+10,self.view.fWidth,266);
    likeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:likeView];
    UILabel *likelabel = [[UILabel alloc] init];
    likelabel.frame = CGRectMake((likeView.fWidth-71)/2,20,71,17);
    likelabel.text = @"猜你喜欢";
    likelabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    likelabel.textColor =UIColorRBG(68, 68, 68);
    [likeView addSubview:likelabel];
    
    UIView *sV = [[UIView alloc] initWithFrame:CGRectMake(0, 58, likeView.fWidth, 205)];
    sV.backgroundColor =[UIColor clearColor];
    [likeView addSubview:sV];
    //自定义一个tableview
    WZReportSuccessTableView *tbView = [[WZReportSuccessTableView alloc] initWithFrame:CGRectMake(0, 0, sV.fHeight, sV.fWidth-15)];
    NSArray *array = [_reportData valueForKey:@"projectList"];
    tbView.projectArray = [WZLikeProjectItem mj_objectArrayWithKeyValuesArray:array];
    [tbView reloadData];
    tbView.backgroundColor = [UIColor clearColor];
    [sV addSubview:tbView];
}
//打电话
-(void)playPhone:(UIButton *)button{
    NSString *phone = button.titleLabel.text;
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"号码为空"];
    }
}
#pragma mark -设置导航栏
-(void)setNarItem{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"报备成功";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(success) title:@"完成"];
}
#pragma mark -继续报备
-(void)report{
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -查看订单
-(void)order{
    WZBoaringController *boaringVC = [[WZBoaringController alloc] init];
    [self.navigationController pushViewController:boaringVC animated:YES];
}
#pragma mark -完成
-(void)success{
    WZTabBarController *tar = [[WZTabBarController alloc] init];
    tar.selectedViewController = [tar.viewControllers objectAtIndex:0];
    [self.navigationController presentViewController:tar animated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
