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
//标签
@property (nonatomic,strong)UIView *imageOne;
//标签
@property (nonatomic,strong)UIView *imageTwo;
//未签约提醒
@property (nonatomic,strong)UITextView *labels;
//未签约提醒
@property (nonatomic,strong)UILabel *labelRed;
//背景图
@property (nonatomic,strong)UIImageView *imageViews;
//提示
@property (nonatomic,strong)UILabel *label;
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
   if ([_houseType isEqual:@"2"]) {
       
        [_labels setHidden:NO];
        [_labelRed setHidden:YES];
        [_imageTwo setHidden:YES];
        [_imageOne setHidden:NO];
        [_imageViews setHidden:YES];
        [_label setHidden:YES];
       _labels.textColor = UIColorRBG(102, 102, 102);
       _labels.text = @"售楼部可能未更新“扫码上客”功能，经纪人可在现场填写“客户报备单”，使用“凭证上客”功能上传纸质报备单，确认上客，审核通过后，上客成功";
   }else{
        
    if ([_status isEqual:@"2"]) {
        [_labels setHidden:YES];
        [_labelRed setHidden:YES];
        [_imageTwo setHidden:YES];
        [_imageOne setHidden:YES];
        [_imageViews setHidden:NO];
        [_label setHidden:NO];
    }else{
        [_labels setHidden:NO];
        [_labelRed setHidden:NO];
        [_imageTwo setHidden:NO];
        [_imageOne setHidden:NO];
        [_imageViews setHidden:YES];
        [_label setHidden:YES];
        if ([_status isEqual:@"1"]) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你所在经纪门店与该楼盘未签约，在最晚上客时间内，楼盘负责人将会与你联系，或你可致电%@了解签约事宜",_telphone]];
            [attributedString addAttribute:NSLinkAttributeName value:@"cilck://" range:[[attributedString string] rangeOfString:_telphone]];
             [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] range:NSMakeRange(0, attributedString.length)];
            _labels.attributedText = attributedString;
            _labels.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorRBG(255, 108, 0),NSUnderlineColorAttributeName:UIColorRBG(102, 102, 102), NSUnderlineStyleAttributeName: @(NSUnderlinePatternDot)};
    
            _labelRed.text = @"楼盘须与门店签约，未签约可能会影响佣金结算，请及时签约";
        }else{
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"你所在经纪门店和该楼盘的签约已过期，在最晚上客时间内，楼盘负责人将会与你联系，或你可致电%@了解续约事宜",_telphone]];
            [attributedString addAttribute:NSLinkAttributeName value:@"cilck://" range:[[attributedString string] rangeOfString:_telphone]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] range:NSMakeRange(0, attributedString.length)];
            _labels.attributedText = attributedString;
            _labels.linkTextAttributes = @{NSForegroundColorAttributeName:UIColorRBG(255, 108, 0),NSUnderlineColorAttributeName:UIColorRBG(102, 102, 102), NSUnderlineStyleAttributeName: @(NSUnderlinePatternDot)};
            _labelRed.text = @"楼盘须与门店签约，签约过期可能影响佣金结算，请及时续约";
        }
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
    view.frame = CGRectMake(0,kApplicationStatusBarHeight+78,self.view.fWidth,self.view.fHeight-34);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *viewOne = [[UIView alloc] init];
    viewOne.layer.shadowColor = UIColorRBG(0, 0, 0).CGColor;
    viewOne.layer.shadowOpacity = 0.05f;
    viewOne.layer.shadowRadius =5.0f;
    viewOne.layer.shadowOffset = CGSizeMake(0, 2);
    viewOne.layer.cornerRadius = 5;
    viewOne.layer.masksToBounds = NO;
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+53);
        make.height.mas_offset(60);
        make.width.mas_offset(self.view.fWidth-30);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"bb_succeed"];
    [viewOne addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).offset(18);
        make.top.equalTo(viewOne.mas_top).with.offset(13);
        make.height.mas_offset(35);
        make.width.mas_offset(35);
    }];
    //项目名称
    _labelOne = [[UILabel alloc] init];
    _labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    _labelOne.textColor = UIColorRBG(51, 51, 51);
    [viewOne addSubview:_labelOne];
    [_labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(23);
        make.top.equalTo(viewOne.mas_top).with.offset(16);
        make.height.mas_offset(16);
        make.width.offset(self.view.fWidth-115);
    }];
    //提示上客时间
    _labelFour = [[UILabel alloc] init];
    _labelFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _labelFour.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:_labelFour];
    [_labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(20);
        make.top.equalTo(_labelOne.mas_bottom).with.offset(6);
        make.height.mas_offset(12);
        make.width.offset(self.view.fWidth-115);
    }];
    //标签图
    UIView *imgViewOne = [[UIView alloc] init];
    imgViewOne.backgroundColor = UIColorRBG(255, 224, 0);
    imgViewOne.layer.cornerRadius = 2.0;
    imgViewOne.layer.masksToBounds = YES;
    _imageOne = imgViewOne;
    [view addSubview:imgViewOne];
    [imgViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(19);
        make.top.equalTo(view.mas_top).with.offset(65);
        make.height.mas_offset(14);
        make.width.offset(4);
    }];
    //项目未签约提示
    UITextView *label  = [[UITextView alloc] init];
    _labels = label;
    label.delegate = self;
    label.editable = NO;//必须禁止输入，否则点击将会弹出输入键盘
    label.scrollEnabled = NO;//可选的，视具体情况而定
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgViewOne.mas_left).offset(7);
        make.top.equalTo(view.mas_top).with.offset(55);
        make.width.mas_offset(view.fWidth - 52);
    }];
    //标签图
    UIView *imgViewTwo = [[UIView alloc] init];
    imgViewTwo.backgroundColor = UIColorRBG(255, 224, 0);
    imgViewTwo.layer.cornerRadius = 2.0;
    imgViewTwo.layer.masksToBounds = YES;
    _imageTwo = imgViewTwo;
    [view addSubview:imgViewTwo];
    [imgViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(19);
        make.top.equalTo(imgViewOne.mas_bottom).with.offset(53);
        make.height.mas_offset(14);
        make.width.offset(4);
    }];
    //警告
    UILabel *labelRed  = [[UILabel alloc] init];
    labelRed.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    labelRed.textColor = UIColorRBG(255, 108, 0);
    labelRed.numberOfLines = 0;
    _labelRed = labelRed;
    [view addSubview:labelRed];
    [labelRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgViewTwo.mas_right).offset(7);
        make.top.equalTo(imgViewOne.mas_bottom).offset(52);
        make.width.mas_offset(view.fWidth - 52);
    }];
    UIImageView *imageViews = [[UIImageView alloc] init];
    imageViews.image = [UIImage imageNamed:@"bb_suss_pic"];
    _imageViews = imageViews;
    [imageViews setHidden:YES];
    [view addSubview:imageViews];
    [imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(47);
        make.width.mas_offset(117);
        make.height.offset(92);
    }];
    UILabel *labels  = [[UILabel alloc] init];
    labels.text = @"报备成功!";
    labels.font =[UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labels.textColor = UIColorRBG(255, 196, 109);
    labels.textAlignment = NSTextAlignmentCenter;
    _label = labels;
    [labels setHidden:YES];
    [view addSubview:labels];
    [labels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageViews.mas_bottom).offset(22);
        make.height.mas_offset(14);
    }];
    
    //继续报备
    _viewOrder = [[UIButton alloc] init];
    [_viewOrder setTitle:@"继续报备" forState: UIControlStateNormal];
    [_viewOrder setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    _viewOrder.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _viewOrder.layer.cornerRadius = 3.0;
    _viewOrder.layer.masksToBounds = YES;
    _viewOrder.backgroundColor = UIColorRBG(74, 76, 91);
    [_viewOrder addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_viewOrder];
    [_viewOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).with.offset(200);
        make.width.mas_offset(view.fWidth/2.0-28);
        make.height.mas_offset(39);
    }];
    
    //查看订单
    _resportButton = [[UIButton alloc] init];
    [_resportButton setTitle:@"查看订单" forState: UIControlStateNormal];
    [_resportButton setTitleColor:UIColorRBG(74, 76, 91) forState:UIControlStateNormal];
    _resportButton.backgroundColor = UIColorRBG(250, 246, 254);
    _resportButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _resportButton.layer.cornerRadius = 3.0;
    _resportButton.layer.masksToBounds  = YES;
    _resportButton.layer.borderColor = UIColorRBG(185, 183, 186).CGColor;
    _resportButton.layer.borderWidth = 1.0;
    [_resportButton addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_resportButton];
    [_resportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-28);
        make.top.equalTo(_viewOrder.mas_top);
        make.width.mas_offset(view.fWidth/2.0-28);
        make.height.mas_offset(39);
    }];
    
    UIImageView *imageIne = [[UIImageView alloc] init];
    imageIne.image = [UIImage imageNamed:@"bb_ss_x"];
    [view addSubview:imageIne];
    [imageIne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(_resportButton.mas_bottom).offset(25);
        make.height.mas_offset(1);
        make.width.mas_offset(view.fWidth-30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"猜你喜欢";
    titleLabel.textColor = UIColorRBG(51, 51, 51);
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(_resportButton.mas_bottom).offset(43);
        make.height.mas_offset(16);
    }];
    //创建为你推荐
    UIView *likeView = [[UIView alloc] init];
    [view addSubview:likeView];
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.width.offset(view.fWidth);
        make.height.mas_offset(249);
    }];
    
    UIView *sV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, 249)];
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
