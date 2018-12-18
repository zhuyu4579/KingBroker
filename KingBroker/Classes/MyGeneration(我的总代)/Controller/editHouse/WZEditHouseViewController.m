//
//  WZEditHouseViewController.m
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
#import "ZDMapController.h"
#import "WZOSSImageUploader.h"
#import "NSString+LCExtension.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZEditHouseViewController.h"

@interface WZEditHouseViewController ()<UITextFieldDelegate,UITextViewDelegate,HXPhotoViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *viewTen;
//公司名称
@property(nonatomic,strong)UITextField *companyName;
//公司名称
@property(nonatomic,strong)UITextField *houseName;
//楼盘位置
@property(nonatomic,strong)UILabel *houseAddress;
//楼盘坐标
@property(nonatomic,strong)NSString *houseLnglat;
//楼盘AdCode
@property(nonatomic,strong)NSString *houseAdCode;
//楼盘地址
@property(nonatomic,strong)UITextField *houseAddr;
//总价
@property(nonatomic,strong)UITextField *totalPrice;
//均价
@property(nonatomic,strong)UITextField *averagePrice;
// 标签数组
@property (nonatomic, strong) NSArray *markArray;
// 选中标签数组(数字)
@property (nonatomic, strong) NSMutableArray *selectedMarkArray;
@property (nonatomic, strong) NSString *houseType;
//佣金
@property(nonatomic,strong)UITextField *commission;
//结佣时间
@property(nonatomic,strong)UITextField *CommissionTime;
//佣金规则
@property (nonatomic, retain) UITextView *commissionTextView;
//文本提示语
@property (nonatomic, retain) UILabel *commissionLabels;
//文本数量
@property (nonatomic, retain) UILabel *commissionLabelSum;
//渠道负责人
@property(nonatomic,strong)UITextField *realName;
//联系电话
@property(nonatomic,strong)UITextField *telphone;
//楼盘动态
@property (nonatomic, retain) UITextView *houseDynamic;
//文本提示语
@property (nonatomic, retain) UILabel *houseDynamicLabels;
//文本数量
@property (nonatomic, retain) UILabel *houseDynamicSum;
//楼盘简介
@property (nonatomic, retain) UITextView *houseIntroduce;
//文本提示语
@property (nonatomic, retain) UILabel *houseIntroduceLabels;
//文本数量
@property (nonatomic, retain) UILabel *houseIntroduceSum;
//报备说明
@property (nonatomic, retain) UITextView *reportExplain;
//文本提示语
@property (nonatomic, retain) UILabel *reportExplainLabels;
//文本数量
@property (nonatomic, retain) UILabel *reportExplainSum;
//展示图
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) HXPhotoView *photoView;
//图片数组
@property (strong, nonatomic) NSArray<UIImage *> *imageArray;
//图片地址
@property (strong, nonatomic) NSMutableArray *imageArrays;
@property (strong, nonatomic) NSString *showUrl;
@end
static const CGFloat kPhotoViewMargin = 15.0;
@implementation WZEditHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    NSLog(@"%@",_data);
    //创建view
    [self createView];
}
#pragma mark-创建view
-(void)createView{
    //创建UIScrollView
    UIScrollView *meScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.fX,0, self.view.fWidth, self.view.fHeight-134-JF_BOTTOM_SPACE-kApplicationStatusBarHeight)];
    meScrollView.backgroundColor = UIColorRBG(247,247,247);
    meScrollView.bounces = NO;
    meScrollView.showsVerticalScrollIndicator = NO;
    meScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:meScrollView];
    self.scrollView = meScrollView;
   
    //第二个view
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 8, meScrollView.fWidth, 99)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewTwo];
    //获取数据
    NSString *companyNames = [_data valueForKey:@"companyName"];
    UIView *viewTwo_one = [self createViewOne:@"公司名称" contents:companyNames fY:0 isDel:@"" unit:@"" setKeyboard:@""];
    [viewTwo addSubview:viewTwo_one];
    UITextField *companyName = [viewTwo_one viewWithTag:20];
    _companyName = companyName;
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewTwo.fWidth-30, 1)];
    ineTwo.backgroundColor = UIColorRBG(240, 240, 240);
    [viewTwo addSubview:ineTwo];
    //获取数据
    NSString *house = [_data valueForKey:@"name"];
    UIView *viewTwo_two = [self createViewOne:@"楼盘名称" contents:house fY:50 isDel:@"" unit:@"" setKeyboard:@""];
    [viewTwo addSubview:viewTwo_two];
    UITextField *houseName = [viewTwo_two viewWithTag:20];
    _houseName = houseName;
    
    //第三个view
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+viewTwo.fHeight+8, meScrollView.fWidth, 99)];
    viewThree.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewThree];
    
    UIView *viewThree_one = [self createViewClass:@selector(selectAddress) image:[UIImage imageNamed:@"zc_map"] title:@"楼盘位置" fY:0 size:CGSizeMake(20, 26)];
    [viewThree addSubview:viewThree_one];
    //获取数据
    NSString *position = [_data valueForKey:@"position"];
    _houseLnglat = [_data valueForKey:@"lnglat"];
    _houseAdCode = [_data valueForKey:@"adcode"];
    
    UILabel *houseAddress = [viewThree_one viewWithTag:30];
    _houseAddress = houseAddress;
    houseAddress.text = position;
    houseAddress.textColor = UIColorRBG(51, 51, 51);
    
    UIView *ineThree = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewThree.fWidth-30, 1)];
    ineThree.backgroundColor = UIColorRBG(240, 240, 240);
    [viewThree addSubview:ineThree];
    //获取数据
    NSString *address = [_data valueForKey:@"address"];
    UIView *viewThree_two = [self createViewOne:@"楼盘地址" contents:address fY:50 isDel:@"" unit:@"" setKeyboard:@""];
    [viewThree addSubview:viewThree_two];
    UITextField *houseAddr = [viewThree_two viewWithTag:20];
    _houseAddr = houseAddr;
    
    //新增总价/均价
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY+viewThree.fHeight+8, meScrollView.fWidth, 99)];
    priceView.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:priceView];
    //获取数据
    NSString *totalPrices = [_data valueForKey:@"totalPrice"];
    UIView *viewPrice_one = [self createViewOne:@"总价" contents:totalPrices fY:0 isDel:@"2" unit:@"万元/套起" setKeyboard:@"1"];
    [priceView addSubview:viewPrice_one];
    UITextField *totalPrice = [viewPrice_one viewWithTag:20];
    _totalPrice = totalPrice;
    UIView *inePrice = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewTwo.fWidth-30, 1)];
    inePrice.backgroundColor = UIColorRBG(240, 240, 240);
    [priceView addSubview:inePrice];
    //获取数据
    NSString *averagePrices = [_data valueForKey:@"averagePrice"];
    UIView *viewPrice_two = [self createViewOne:@"均价" contents:averagePrices fY:50 isDel:@"2" unit:@"万元/平起" setKeyboard:@"1"];
    [priceView addSubview:viewPrice_two];
    UITextField *averagePrice = [viewPrice_two viewWithTag:20];
    _averagePrice = averagePrice;
    
    //第四个view
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, priceView.fY+priceView.fHeight+8, meScrollView.fWidth, 130)];
    viewFour.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewFour];
    
    UILabel *labelTitle = [[UILabel alloc] init];
    NSMutableAttributedString *stringOne = [[NSMutableAttributedString alloc] initWithString:@"楼盘类型" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName:UIColorRBG(51, 51, 51)}];
    labelTitle.attributedText = stringOne;
    [viewFour addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewFour.mas_left).offset(15);
        make.top.equalTo(viewFour.mas_top).offset(14);
        make.height.offset(15);
    }];
    
    UILabel *labelTitles = [[UILabel alloc] init];
    labelTitles.text = @"(多选)";
    labelTitles.textColor = UIColorRBG(204, 204, 204);
    labelTitles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 13];
    [viewFour addSubview:labelTitles];
    [labelTitles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelTitle.mas_right).offset(10);
        make.top.equalTo(viewFour.mas_top).offset(16);
        make.height.offset(13);
    }];
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(15, 42, viewFour.fWidth-30, 1)];
    ineFour.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFour addSubview:ineFour];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, ineFour.fY+1, viewFour.fWidth, 88)];
    [viewFour addSubview:buttonView];
    [self createMultipleButton:buttonView];
    //第五个view
    UIView *viewFive = [[UIView alloc] initWithFrame:CGRectMake(0, viewFour.fY+viewFour.fHeight+8, meScrollView.fWidth, 258)];
    viewFive.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewFive];
    //获取数据
    NSString *commissions = [_data valueForKey:@"commission"];
    UIView *viewFive_one = [self createViewOne:@"佣金" contents:commissions fY:0 isDel:@"" unit:@"" setKeyboard:@""];
    [viewFive addSubview:viewFive_one];
    UITextField *commission = [viewFive_one viewWithTag:20];
    _commission = commission;
    
    UIView *ineFive = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewFive.fWidth-30, 1)];
    ineFive.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFive addSubview:ineFive];
    //获取数据
    NSString *settlement = [_data valueForKey:@"settlement"];
    UIView *viewFive_two = [self createViewOne:@"结佣时间" contents:settlement fY:50 isDel:@"" unit:@"" setKeyboard:@""];
    [viewFive addSubview:viewFive_two];
    UITextField *commissionTime = [viewFive_two viewWithTag:20];
    _CommissionTime = commissionTime;
    
    UIView *ineFives = [[UIView alloc] initWithFrame:CGRectMake(0, 99, viewFive.fWidth, 1)];
    ineFives.backgroundColor = UIColorRBG(240, 240, 240);
    [viewFive addSubview:ineFives];
    //获取数据
    NSString *commissionRules = [_data valueForKey:@"commissionRule"];
    UIView *commissionRule = [[UIView alloc] initWithFrame:CGRectMake(0, 100, viewFive.fWidth, 159)];
    [viewFive addSubview:commissionRule];
    [self createReadView:commissionRule title:@"佣金规则" placeholder:@"输入佣金规则，例:主力户型11万/套，其他户型13万/套" sum:@"0/100"];
    _commissionTextView = [commissionRule viewWithTag:40];
    _commissionTextView.text = commissionRules;
    _commissionLabels = [commissionRule viewWithTag:50];
    [_commissionLabels setHidden:YES];
    _commissionLabelSum = [commissionRule viewWithTag:60];
    _commissionLabelSum.text = [NSString stringWithFormat:@"%ld/100",commissionRules.length];
    //第六个view
    UIView *viewSix = [[UIView alloc] initWithFrame:CGRectMake(0, viewFive.fY+viewFive.fHeight+8, meScrollView.fWidth, 99)];
    viewSix.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewSix];
    //获取数据
    NSString *chargeMan = [_data valueForKey:@"chargeMan"];
    UIView *viewSix_one = [self createViewOne:@"渠道负责人" contents:chargeMan fY:0 isDel:@"" unit:@"" setKeyboard:@""];
    [viewSix addSubview:viewSix_one];
    UITextField *realName = [viewSix_one viewWithTag:20];
    _realName = realName;
    
    UIView *ineSix = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewFive.fWidth-30, 1)];
    ineSix.backgroundColor = UIColorRBG(240, 240, 240);
    [viewSix addSubview:ineSix];
    //获取数据
    NSString *telphones = [_data valueForKey:@"telphone"];
    UIView *viewSix_two = [self createViewOne:@"联系电话" contents:telphones fY:50 isDel:@"" unit:@"" setKeyboard:@"1"];
    [viewSix addSubview:viewSix_two];
    UITextField *telphone = [viewSix_two viewWithTag:20];
    _telphone = telphone;
    //第七个view
    UIView *viewSeven = [[UIView alloc] initWithFrame:CGRectMake(0, viewSix.fY+viewSix.fHeight+8, meScrollView.fWidth, 223)];
    viewSeven.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewSeven];
    //获取数据
    NSString *dynamic = [_data valueForKey:@"dynamic"];
    [self createReadView:viewSeven title:@"楼盘动态" placeholder:@"输入楼盘最新活动，例：目前在售楼盘住宅面积96-165平，均价2.5万/平，体量充足" sum:@"0/200"];
    _houseDynamic = [viewSeven viewWithTag:40];
    _houseDynamicLabels = [viewSeven viewWithTag:50];
    _houseDynamicSum = [viewSeven viewWithTag:60];
    _houseDynamic.text = dynamic;
    [_houseDynamicLabels setHidden:YES];
    _houseDynamicSum.text = [NSString stringWithFormat:@"%ld/200",dynamic.length];
    //第八个view
    UIView *viewEight = [[UIView alloc] initWithFrame:CGRectMake(0, viewSeven.fY+viewSeven.fHeight+8, meScrollView.fWidth, 223)];
    viewEight.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewEight];
    //获取数据
    NSString *outlining = [_data valueForKey:@"outlining"];
    [self createReadView:viewEight title:@"楼盘简介" placeholder:@"输入楼盘介绍，例：项目占地面积约200亩，总建筑面积约20万㎡，总户数为836户，其中排屋175户，花园洋房661户。分南、北苑开发。平层面积70㎡—140㎡左右项目采用法式建筑风格，以清新、亮丽、典雅为基调，推崇优雅、高贵和浪漫，通体洋溢着新古典主义的法式风格" sum:@"0/1000"];
    _houseIntroduce = [viewEight viewWithTag:40];
    _houseIntroduceLabels = [viewEight viewWithTag:50];
    _houseIntroduceSum = [viewEight viewWithTag:60];
    _houseIntroduce.text = outlining;
    [_houseIntroduceLabels setHidden:YES];
    _houseIntroduceSum.text = [NSString stringWithFormat:@"%ld/1000",outlining.length];
    //第九个view
    UIView *viewNine = [[UIView alloc] initWithFrame:CGRectMake(0, viewEight.fY+viewEight.fHeight+8, meScrollView.fWidth, 159)];
    viewNine.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewNine];
    //获取数据
    NSString *reportDescribe = [_data valueForKey:@"reportDescribe"];
    [self createReadView:viewNine title:@"报备说明" placeholder:@"输入报备客户说明，例：前三后四报备，至少上客前30分钟报备" sum:@"0/100"];
    _reportExplain = [viewNine viewWithTag:40];
    _reportExplainLabels = [viewNine viewWithTag:50];
    _reportExplainSum = [viewNine viewWithTag:60];
    _reportExplain.text = reportDescribe;
    [_reportExplainLabels setHidden:YES];
    _reportExplainSum.text = [NSString stringWithFormat:@"%ld/100",reportDescribe.length];
    //第十个view
    UIView *viewTen = [[UIView alloc] initWithFrame:CGRectMake(0, viewNine.fY+viewNine.fHeight+8, meScrollView.fWidth, 166)];
    _viewTen = viewTen;
    viewTen.backgroundColor = [UIColor whiteColor];
    [meScrollView addSubview:viewTen];
    [self ctreatePhotographView:viewTen title:@"展示图"];
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
    meScrollView.contentSize = CGSizeMake(0, viewTen.fY+viewTen.fHeight);
}
#pragma mark-选择楼盘位置
-(void)selectAddress{
    [self touches];
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _houseAddress.textColor = UIColorRBG(51, 51, 51);
        _houseAddress.text = [address valueForKey:@"address"];
        _houseLnglat = [address valueForKey:@"lnglat"];
        _houseAdCode = [address valueForKey:@"adcode"];
    };
}

#pragma mark-下一步
-(void)nextSubmission:(UIButton *)button{
    
    //公司名称
    NSString *companyName = _companyName.text;
    companyName = [companyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([companyName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"公司名称不能为空"];
        return;
    }
    //楼盘名称
    NSString *houseName = _houseName.text;
    houseName = [houseName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([houseName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"楼盘名称不能为空"];
        return;
    }
    //楼盘位置
    NSString *houseAddress = _houseAddress.text;
    houseAddress = [houseAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([houseAddress isEqual:@""]||[houseAddress isEqual:@"点击选择"]) {
        [SVProgressHUD showInfoWithStatus:@"楼盘位置不能为空"];
        return;
    }
    //楼盘地址
    NSString *houseAddr = _houseAddr.text;
    houseAddr = [houseAddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([houseAddr isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"楼盘地址不能为空"];
        return;
    }
    //楼盘类型
    if(_selectedMarkArray.count == 0){
        [SVProgressHUD showInfoWithStatus:@"楼盘类型不能为空"];
        return;
    }
    _houseType =[_selectedMarkArray componentsJoinedByString:@","];
    
    //佣金
    NSString *commission = _commission.text;
    commission = [commission stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([commission isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"佣金不能为空"];
        return;
    }
    //总价
    NSString *totalPrice = _totalPrice.text;
    totalPrice = [totalPrice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([totalPrice isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"总价不能为空"];
        return;
    }
    //均价
    NSString *averagePrice = _averagePrice.text;
    averagePrice = [averagePrice stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([averagePrice isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"均价不能为空"];
        return;
    }
    //结佣时间
    NSString *commissionTime = _CommissionTime.text;
    commissionTime = [commissionTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([commissionTime isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"佣金时间不能为空"];
        return;
    }
    //佣金规则
    NSString *commissionRule = _commissionTextView.text;
    commissionRule = [commissionRule stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([commissionRule isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"佣金规则不能为空"];
        return;
    }
    //渠道负责人
    NSString *dutyName = _realName.text;
    dutyName = [dutyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([dutyName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"渠道负责人不能为空"];
        return;
    }
    //联系电话
    NSString *telphone = _telphone.text;
    telphone = [telphone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telphone isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"联系电话不能为空"];
        return;
    }
    //楼盘动态
    NSString *dynamic = _houseDynamic.text;
    dynamic = [dynamic stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([dynamic isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"楼盘动态不能为空"];
        return;
    }
    //楼盘简介
    NSString *outlining = _houseIntroduce.text;
    outlining = [outlining stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([outlining isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"楼盘简介不能为空"];
        return;
    }
    
    //报备说明
    NSString *reportDescribe = _reportExplain.text;
    reportDescribe = [reportDescribe stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([reportDescribe isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"楼盘简介不能为空"];
        return;
    }
    //展示图
    if (_imageArrays.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"展示图上传失败,请重新选择图片"];
        return;
    }
    _showUrl = _imageArrays[0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = [_data valueForKey:@"id"];
    paraments[@"name"] = houseName;
    paraments[@"companyName"] = companyName ;
    paraments[@"lnglat"] = _houseLnglat;
    paraments[@"adcode"] = _houseAdCode;
    paraments[@"address"] = houseAddr;
    paraments[@"type"] = _houseType;
    paraments[@"totalPrice"] = totalPrice;
    paraments[@"averagePrice"] = averagePrice;
    paraments[@"commission"] = commission;
    paraments[@"settlement"] = commissionTime;
    paraments[@"commissionRule"] = commissionRule;
    paraments[@"chargeMan"] = dutyName;
    paraments[@"telphone"] = telphone;
    paraments[@"dynamic"] = dynamic;
    paraments[@"outlining"]=outlining;
    paraments[@"reportDescribe"] = reportDescribe;
    paraments[@"showUrl"] = _showUrl;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/upbaseInfoCreateOrUpdate",HTTPURL];
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
    NSString *type = [_data valueForKey:@"type"];
    _houseType = type;
    NSArray *arrays = [type componentsSeparatedByString:@","];
    _selectedMarkArray = arrays;
    
    NSArray *array = @[@"住宅", @"排屋别墅", @"写字楼", @"商铺", @"酒店式公寓"];
    _markArray = array;
    CGFloat top = 0;
    CGFloat height = 44;
    CGFloat width = view.fWidth/4.0;
    NSInteger maxCol = 4;
    for (NSInteger i = 0; i < 5; i++) {
        NSInteger col = i % maxCol; //列
        NSInteger row = i / maxCol; //行
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(col * width, top + row * height, width, height)];
        [view addSubview:btnView];
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"bb_choose_2"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"bb_icon"] forState:UIControlStateSelected];
        btn.tag = i+1;
        if ([type containsString:[NSString stringWithFormat:@"%ld",i+1]]) {
            btn.selected = YES;
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
        
        [self.selectedMarkArray addObject:[NSString stringWithFormat:@"%ld",btn.tag]];
    } else {
        
        [self.selectedMarkArray removeObject:[NSString stringWithFormat:@"%ld",btn.tag]];
        
    }
    
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
    titles.text = @"点击选择";
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
        make.right.equalTo(view.mas_right).offset(-23);
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
    _scrollView.contentSize = CGSizeMake(0, _viewTen.fY+_viewTen.fHeight+220);
    if (textView == _commissionTextView) {
        [_commissionLabels setHidden:YES];
    }
    if (textView == _houseDynamic){
        [_houseDynamicLabels setHidden:YES];
    }
    if (textView == _houseIntroduce){
        [_houseIntroduceLabels setHidden:YES];
    }
    if (textView == _reportExplain){
        [_reportExplainLabels setHidden:YES];
    }
}

//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *text = textView.text;
    if (text.length == 0) {
        if (textView == _commissionTextView) {
            [_commissionLabels setHidden:NO];
        }
        if (textView == _houseDynamic){
            [_houseDynamicLabels setHidden:NO];
        }
        if (textView == _houseIntroduce){
            [_houseIntroduceLabels setHidden:NO];
        }
        if (textView == _reportExplain){
            [_reportExplainLabels setHidden:NO];
        }
    }
    _scrollView.contentSize = CGSizeMake(0, _viewTen.fY+_viewTen.fHeight);
    
}
-(void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    if (textView == _commissionTextView) {
        _commissionLabelSum.text = [NSString stringWithFormat:@"%ld/100",text.length];
        if (text.length == 100) {
            textView.editable = NO;
        }
    }
    if (textView == _houseDynamic){
        _houseDynamicSum.text = [NSString stringWithFormat:@"%ld/200",text.length];
        if (text.length == 200) {
            textView.editable = NO;
        }
    }
    if (textView == _houseIntroduce){
        _houseIntroduceSum.text = [NSString stringWithFormat:@"%ld/1000",text.length];
        if (text.length == 1000) {
            textView.editable = NO;
        }
    }
    if (textView == _reportExplain){
        _reportExplainSum.text = [NSString stringWithFormat:@"%ld/100",text.length];
        if (text.length == 100) {
            textView.editable = NO;
        }
    }
}
#pragma mark -懒加载
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 1; //
        _manager.configuration.videoMaxNum = 0;  //
        _manager.configuration.maxNum = 1;
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
    labelTitles.text = @"(仅限1张，建议图片长：宽=3：2)";
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
    photoView.addImageName = @"camera";
    //photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [view addSubview:photoView];
    self.photoView = photoView;
    //_showUrl = [_data valueForKey:@"showUrl"];
    NSMutableArray *array = [NSMutableArray arrayWithObject:[_data valueForKey:@"showUrl"]];
    _imageArrays = array;
    HXCustomAssetModel *assetModel = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:[_data valueForKey:@"showUrl"]] selected:YES];
    [self.manager addCustomAssetModel:@[assetModel]];
    [self.photoView refreshView];
}
//获取图片数组
- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList{
    
    _imageArray = imageList;
    
    [self findUploadData:imageList];
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
            [SVProgressHUD showInfoWithStatus:@"获取上传凭证失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    _scrollView.contentSize = CGSizeMake(0, _viewTen.fY+_viewTen.fHeight+220);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _scrollView.contentSize = CGSizeMake(0, _viewTen.fY+_viewTen.fHeight);
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
    _scrollView.contentSize = CGSizeMake(0, _viewTen.fY+_viewTen.fHeight);
    [self.view endEditing:YES];
}
-(void)touches{
    _scrollView.contentSize = CGSizeMake(0, _viewTen.fY+_viewTen.fHeight);
    [self.view endEditing:YES];
}

@end
