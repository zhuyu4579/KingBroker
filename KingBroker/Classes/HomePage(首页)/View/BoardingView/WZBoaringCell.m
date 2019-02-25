//
//  WZBoaringCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  订单cell

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZBoaringCell.h"
#import "WZBoardingItem.h"
#import "WZNewReportController.h"
#import "WZVoucherDealController.h"
#import "WZBoardingDetailsController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZVoucherBoardingController.h"
#import "UIViewController+WZFindController.h"
@implementation WZBoaringCell
-(void)setItem:(WZBoardingItem *)item{
    _item = item;
    //设置客户名称
    _nameOne.text = item.clientName;
    _nameTwo.text = item.clientName;
    _nameThree.text = item.clientName;
    _nameFour.text = item.clientName;
    //设置客户电话
    _telephoneOne.text = item.missContacto;
    _telephoneTwo.text =item.missContacto;
    _telephoneThree.text = item.missContacto;
    _telephoneFour.text = item.missContacto;
    //楼盘名称
    _ItemNameOne.text = item.projectName;
    _ItemNameTwo.text = item.projectName;
    _ItemNameThree.text = item.projectName;
    _ItemNameFour.text = item.projectName;
    //订单时间
    _boaringTimeOne.text = item.createDate;
    _boaringTimeTwo.text = item.createDate;
    _boaringTimeThree.text = item.createDate;
    _boaringTimeFour.text = item.createDate;
    //楼盘类型
    NSString *selfEmployed = item.selfEmployed;
    _selfEmployed = selfEmployed;
   
    //状态
    NSArray *stateArray = @[@"已报备", @"上客审核中",@"已上客",@"成交审核中", @"已成交",@"已失效"];
    NSString *state = item.dealStatus;
    //审核状态
    NSString *verify = item.verify;
    int verifys = [verify intValue];
    int states = [state intValue];
   
    //订单状态判断
    if (states == 1) {
        //已报备
        if (verifys == 3) {
            _stateOne.text = stateArray[0];
            if ([selfEmployed isEqual:@"2"]) {
                [_buttonOne setHidden:YES];
                [_buttonOne setEnabled:NO];
                [_button_one setHidden:NO];
                [_button_one setEnabled:YES];
                [_button_ones setHidden:NO];
                [_button_ones setEnabled:YES];
                [_houseTypeOne setHidden:NO];
                _ItemOneX.constant = 80;
                _boardingButtonX.constant = 10;
            }else{
                [_button_one setHidden:YES];
                [_button_one setEnabled:NO];
                [_button_ones setHidden:YES];
                [_button_ones setEnabled:NO];
                [_buttonOne setHidden:NO];
                [_buttonOne setEnabled:YES];
                [_houseTypeOne setHidden:YES];
                _ItemOneX.constant = 10;
                _boardingButtonX.constant = 97;
            }
        }
    }
    if(states == 2){
        //上客审核中
        if (verifys == 2) {
            _stateOne.text = stateArray[1];
            [_buttonOne setHidden:YES];
            [_buttonOne setEnabled:NO];
            [_button_one setHidden:YES];
            [_button_one setEnabled:NO];
            [_button_ones setHidden:YES];
            [_button_ones setEnabled:NO];
            if ([selfEmployed isEqual:@"2"]) {
                [_houseTypeOne setHidden:NO];
                _ItemOneX.constant = 80;
            }else{
                [_houseTypeOne setHidden:YES];
                _ItemOneX.constant = 10;
            }
        }else if(verifys == 3){
            //上客成功
            _stateTwo.text = stateArray[2];
            
            if ([selfEmployed isEqual:@"2"]) {
                [_buttonTwo setHidden:YES];
                [_buttonTwo setEnabled:NO];
                [_button_two setHidden:NO];
                [_button_two setEnabled:YES];
                [_houseTypeTwo setHidden:NO];
                _ItemTwoX.constant = 80;
                _buttonTwoX.constant = 97;
                _button_two.backgroundColor = UIColorRBG(255, 224, 0);
                [_button_two setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
            }else {
            
                [_buttonTwo setHidden:NO];
                [_buttonTwo setEnabled:YES];
                [_button_two setHidden:YES];
                [_button_two setEnabled:NO];
                [_houseTypeTwo setHidden:YES];
                _ItemTwoX.constant = 10;
                _buttonTwoX.constant = 10;
                _buttonTwo.backgroundColor = UIColorRBG(255, 224, 0);
                [_buttonTwo setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
            }
        }
    }
    if (states == 3){
        //成交审核中
        if (verifys == 2) {
            _stateTwo.text = stateArray[3];
            
            if ([selfEmployed isEqual:@"2"]) {
                [_buttonTwo setHidden:YES];
                [_buttonTwo setEnabled:NO];
                [_button_two setHidden:NO];
                [_button_two setEnabled:NO];
                [_houseTypeTwo setHidden:NO];
                _ItemTwoX.constant = 80;
                _buttonTwoX.constant = 97;
                _button_two.backgroundColor = UIColorRBG(221, 221, 221);
                [_button_two setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
            }else{
                [_buttonTwo setHidden:NO];
                [_buttonTwo setEnabled:NO];
                [_button_two setHidden:YES];
                [_button_two setEnabled:NO];
                [_houseTypeTwo setHidden:YES];
                _ItemTwoX.constant = 10;
                _buttonTwoX.constant = 10;
                _buttonTwo.backgroundColor = UIColorRBG(221, 221, 221);
                [_buttonTwo setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
            }
        }else if (verifys == 3) {
            //成交成功
            if ([selfEmployed isEqual:@"2"]) {
                [_houseTypeThree setHidden:NO];
                _ItemThreeX.constant = 80;
            } else {
                [_houseTypeThree setHidden:YES];
                _ItemThreeX.constant = 10;
            }
        }
    }
    if(states == 4){
        //失效
         _stateFour.text = stateArray[5];
        if ([selfEmployed isEqual:@"2"]) {
            [_houseTypeFour setHidden:NO];
            _ItemFourX.constant = 80;
        } else {
            [_houseTypeFour setHidden:YES];
            _ItemFourX.constant = 10;
        }
    }
    
    
    //楼盘ID
    _itemIdOne = item.projectId;
    _itemIdTwo = item.projectId;
    _itemIdThree = item.projectId;
    _itemIdFour = item.projectId;
    _boaringId = item.id;
    _url = item.url;
    _sginStatus = item.sginStatus;
    _proTelphone = item.proTelphone;
    _orderTelFlag = item.orderTelFlag;
    _orderCreateTime = item.orderCreateTime;
    _boardingLimitTime = item.boardingLimitTime;
    _partPersonNum = item.partPersonNum;
    _lunchNum = item.lunchNum;
    _departureCity = item.departureCity;
    _partWay = item.partWay;
    _boardingPlane = item.boardingPlanes;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    //读取数据字典
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"dictGroup.plist"];
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    for (NSDictionary *obj in result) {
        NSString *code = [obj valueForKey:@"code"];
        //类型
        if ([code isEqual:@"shzt"]) {
            _SHStatus = [obj valueForKey:@"dicts"];
            
        }
    }
    _viewOne.layer.cornerRadius = 5.0;
    _viewTwo.layer.cornerRadius = 5.0;
    _viewThree.layer.cornerRadius = 5.0;
    _viewFour.layer.cornerRadius = 5.0;
    
    _houseTypeOne.layer.cornerRadius = 8.0;
    _houseTypeOne.layer.masksToBounds = YES;
    _houseTypeTwo.layer.cornerRadius = 8.0;
    _houseTypeTwo.layer.masksToBounds = YES;
    _houseTypeThree.layer.cornerRadius = 8.0;
    _houseTypeThree.layer.masksToBounds = YES;
    _houseTypeFour.layer.cornerRadius = 8.0;
    _houseTypeFour.layer.masksToBounds = YES;
    _nameOne.textColor = UIColorRBG(51, 51, 51);
    _nameTwo.textColor = UIColorRBG(51, 51, 51);
    _nameThree.textColor = UIColorRBG(51, 51, 51);
    _nameFour.textColor = UIColorRBG(51, 51, 51);
    
    _telephoneOne.textColor = UIColorRBG(102, 102, 102);
    _telephoneTwo.textColor = UIColorRBG(102, 102, 102);
    _telephoneThree.textColor = UIColorRBG(102, 102, 102);
    _telephoneFour.textColor = UIColorRBG(102, 102, 102);
    
    _ItemNameOne.textColor = UIColorRBG(153, 153, 153);
    _ItemNameTwo.textColor = UIColorRBG(153, 153, 153);
    _ItemNameThree.textColor = UIColorRBG(153, 153, 153);
    _ItemNameFour.textColor = UIColorRBG(153, 153, 153);
    
    _boaringTimeOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _boaringTimeOne.textColor = UIColorRBG(204, 204, 204);
    _boaringTimeTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _boaringTimeTwo.textColor = UIColorRBG(204, 204, 204);
    _boaringTimeThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _boaringTimeThree.textColor = UIColorRBG(204, 204, 204);
    _boaringTimeFour.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _boaringTimeFour.textColor = UIColorRBG(204, 204, 204);
    
    _stateOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _stateOne.textColor = UIColorRBG(102, 96, 91);
    _stateTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _stateTwo.textColor = UIColorRBG(102, 96, 91);
    
    _stateFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    _stateFour.textColor = UIColorRBG(102, 96, 91);
    
    _buttonOne.backgroundColor = UIColorRBG(255, 224, 0);
    _buttonOne.layer.cornerRadius = 13.0;
    _buttonOne.layer.masksToBounds = YES;
    [_buttonOne setEnlargeEdge:10];
    
    _buttonTwo.backgroundColor = UIColorRBG(255, 224, 0);
    _buttonTwo.layer.cornerRadius = 13.0;
    _buttonTwo.layer.masksToBounds = YES;
    [_buttonTwo setEnlargeEdge:10];
    
    _buttonFour.backgroundColor = UIColorRBG(255, 224, 0);
    _buttonFour.layer.cornerRadius = 13.0;
    _buttonFour.layer.masksToBounds = YES;
    [_buttonFour setEnlargeEdge:10];
    
    _button_one.layer.cornerRadius = 12.5;
    _button_one.layer.masksToBounds = YES;
    [_button_one setEnlargeEdge:7];
    _button_ones.layer.cornerRadius = 12.5;
    _button_ones.layer.masksToBounds = YES;
    _button_ones.layer.borderColor = UIColorRBG(255, 209, 49).CGColor;
    _button_ones.layer.borderWidth = 1;
    [_button_ones setEnlargeEdge:7];
    _button_two.layer.cornerRadius = 12.5;
    _button_two.layer.masksToBounds = YES;
    [_button_two setEnlargeEdge:10];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setFrame:(CGRect)frame{
    frame.origin.y +=19;
    frame.size.height -=19;
    [super setFrame:frame];
    
}

//发起成交
- (IBAction)startDealButtonTwo:(id)sender {
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    UIButton *button = sender;
    
    NSString *boaringId = _boaringId;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = boaringId;
    NSString *url = [NSString stringWithFormat:@"%@/order/dealOrder",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            UILabel *label = [button.superview viewWithTag:30];
            label.text =  @"成交审核中";
            button.backgroundColor = UIColorRBG(221, 221, 221);
            [button setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
            button.enabled = NO;
            [SVProgressHUD showInfoWithStatus:@"发起成交成功"];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}

//重新报备
- (IBAction)newReportButtonFour:(id)sender {
    UIViewController *Vc =  [UIViewController viewController:[self superview]];
    WZNewReportController *report = [[WZNewReportController alloc] init];
    report.ItemNames = _ItemNameFour.text;
    report.itemId = _itemIdFour;
    report.sginStatu = _sginStatus;
    report.dutyTelphone = _proTelphone;
    report.custormNames = _nameFour.text;
    report.telphones = _telephoneFour.text;
    report.types = @"1";
    report.orderTelFlag = _orderTelFlag;
    report.loadTimes = _boardingPlane;
    report.peopleSums = _partPersonNum;
    report.setOutCitys = _departureCity;
    report.houseType = _selfEmployed;
    [Vc.navigationController pushViewController:report animated:YES];
}

- (IBAction)varochBoarding:(UIButton *)sender {
    int boardingLimitTime = [_boardingLimitTime intValue];
    NSString *orderCreateTime1 = _orderCreateTime;
    long orderCreateTime = [orderCreateTime1 longLongValue];
    if (orderCreateTime != 0 ) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970]*1000;
        long time1 = time - orderCreateTime;
        if (time1 >boardingLimitTime*60*1000) {
            UIViewController *Vc =  [UIViewController viewController:[self superview]];
            WZVoucherBoardingController *vb = [[WZVoucherBoardingController alloc] init];
            vb.ID = _boaringId;
            vb.boardingSuccess = ^(NSString * _Nonnull str) {
                if ([str isEqual:@"1"]) {
                    _stateOne.text = @"上客审核中";
                    [_buttonOne setHidden:YES];
                    [_buttonOne setEnabled:NO];
                    [_button_one setHidden:YES];
                    [_button_one setEnabled:NO];
                    [_button_ones setHidden:YES];
                    [_button_ones setEnabled:NO];
                }
            };
            [Vc.navigationController pushViewController:vb animated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"报备%d分钟后才能上客",boardingLimitTime]];
        }
    }
    
}

- (IBAction)launchDeal:(UIButton *)sender {
    
    UIViewController *Vc =  [UIViewController viewController:[self superview]];
    WZVoucherDealController *vb = [[WZVoucherDealController alloc] init];
    vb.ID = _boaringId;
    vb.dealSuccess = ^(NSString * _Nonnull str) {
        if ([str isEqual:@"1"]) {
            _stateOne.text = @"成交审核中";
            [_buttonTwo setHidden:YES];
            [_buttonTwo setEnabled:NO];
            [_button_two setHidden:NO];
            [_button_two setEnabled:NO];
            _button_two.backgroundColor = UIColorRBG(221, 221, 221);
            [_button_two setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
        }
    };
    [Vc.navigationController pushViewController:vb animated:YES];

}
- (IBAction)boardingButton:(UIButton *)sender {
    
    if (_boardingBlock) {
        _boardingBlock(self);
    }
}
@end
