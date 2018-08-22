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
@interface WZReportSuccessController ()<UITextViewDelegate>
//楼盘名
@property (nonatomic,strong)UILabel *labelOne;

//上客时间
@property (nonatomic,strong)UILabel *labelFour;
//未签约提醒
@property (nonatomic,strong)UITextView *labels;
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
     _labelFour.text = [NSString stringWithFormat:@"报备成功，最晚上客时间 %@",[contacts valueForKey:@"boardingEnd"]];
    
    if ([_status isEqual:@"2"]) {
        [_labels setHidden:YES];
        [_labelRed setHidden:YES];
        
    }else{
        [_labels setHidden:NO];
        [_labelRed setHidden:NO];
        if ([_status isEqual:@"1"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你所在经纪门店与该楼盘未签约，在最晚上客时间内，楼盘负责人将会与你联系，或你可致电%@了解签约事宜",_telphone]];
            [attributedString addAttribute:NSLinkAttributeName value:@"cilck://" range:[[attributedString string] rangeOfString:_telphone]];
             [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
            _labels.attributedText = attributedString;
            _labels.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorRBG(102, 221, 85),NSUnderlineColorAttributeName:UIColorRBG(102, 102, 102), NSUnderlineStyleAttributeName: @(NSUnderlinePatternDot)};
    
            _labelRed.text = @"楼盘须与门店签约，未签约可能会影响佣金结算，请及时签约";
        }else{
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你所在经纪门店和该楼盘的签约已过期，在最晚上客时间内，楼盘负责人将会与你联系，或你可致电%@了解续约事宜",_telphone]];
            [attributedString addAttribute:NSLinkAttributeName value:@"cilck://" range:[[attributedString string] rangeOfString:_telphone]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
            _labels.attributedText = attributedString;
            _labels.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorRBG(102, 221, 85),NSUnderlineColorAttributeName:UIColorRBG(102, 102, 102), NSUnderlineStyleAttributeName: @(NSUnderlinePatternDot)};
            _labelRed.text = @"楼盘须与门店签约，签约过期可能影响佣金结算，请及时续约";
        }
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"cilck"]) {
        [self playPhone];
        return NO;
    }
    return YES;
}

-(void)ceartorController{
   
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(35,kApplicationStatusBarHeight+65,self.view.fWidth-70,420);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = UIColorRBG(255, 221, 128).CGColor;
    view.layer.shadowOpacity = 0.05f;
    view.layer.shadowRadius = 20.0f;
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"bb_succeed"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).with.offset(31);
        make.height.mas_offset(90);
        make.width.mas_offset(90);
    }];
    //项目名称
    _labelOne = [[UILabel alloc] init];
    _labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    _labelOne.textColor = UIColorRBG(51, 51, 51);
    _labelOne.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_labelOne];
    [_labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(21);
        make.height.mas_offset(16);
        make.width.offset(view.fWidth-10);
    }];
    //提示上客时间
    _labelFour = [[UILabel alloc] init];
    _labelFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _labelFour.textColor = UIColorRBG(153, 153, 153);
    _labelFour.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_labelFour];
    [_labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(_labelOne.mas_bottom).with.offset(16);
        make.height.mas_offset(12);
        make.width.offset(view.fWidth-10);
    }];
    //项目未签约提示
    UITextView *label  = [[UITextView alloc] init];
    _labels = label;
    label.delegate = self;
    label.editable = NO;//必须禁止输入，否则点击将会弹出输入键盘
    label.scrollEnabled = NO;//可选的，视具体情况而定
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(_labelFour.mas_bottom).with.offset(15);
        make.width.mas_offset(view.fWidth - 40);
    }];
    //警告
    UILabel *labelRed  = [[UILabel alloc] init];
    labelRed.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    labelRed.textColor = UIColorRBG(255, 108, 0);
    labelRed.numberOfLines = 0;
    _labelRed = labelRed;
    [view addSubview:labelRed];
    [labelRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(label.mas_bottom).offset(17);
        make.width.mas_offset(view.fWidth - 50);
    }];
    //继续报备
    _viewOrder = [[UIButton alloc] init];
    [_viewOrder setTitle:@"继续报备" forState: UIControlStateNormal];
    [_viewOrder setTitleColor: UIColorRBG(255, 224, 0) forState:UIControlStateNormal];
    _viewOrder.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [_viewOrder addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_viewOrder];
    [_viewOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.bottom.equalTo(view.mas_bottom).with.offset(-20);
        make.width.mas_offset(view.fWidth/2.0);
        make.height.mas_offset(42);
    }];
    
    //查看订单
    _resportButton = [[UIButton alloc] init];
    [_resportButton setTitle:@"查看订单" forState: UIControlStateNormal];
    [_resportButton setTitleColor:UIColorRBG(255, 224, 0) forState:UIControlStateNormal];
    
    _resportButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    [_resportButton addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_resportButton];
    [_resportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom).with.offset(-20);
        make.width.mas_offset(view.fWidth/2.0);
        make.height.mas_offset(42);
    }];
   
    //创建为你推荐
    UIView *likeView = [[UIView alloc] init];
    likeView.frame = CGRectMake(35,view.fY+view.fHeight+19,self.view.fWidth-70,100);
    [self.view addSubview:likeView];
    
    UIView *sV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, likeView.fWidth, likeView.fHeight)];
    [likeView addSubview:sV];
    //自定义一个tableview
    WZReportSuccessTableView *tbView = [[WZReportSuccessTableView alloc] initWithFrame:CGRectMake(0, 0, sV.fHeight, sV.fWidth)];
    NSArray *array = [_reportData valueForKey:@"projectList"];
    tbView.projectArray = [WZLikeProjectItem mj_objectArrayWithKeyValuesArray:array];
    [tbView reloadData];
    tbView.backgroundColor = [UIColor clearColor];
    [sV addSubview:tbView];
}
//打电话
-(void)playPhone{
    NSString *phone = _telphone;
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
