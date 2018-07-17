//
//  WZBoaringCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZBoaringCell.h"
#import "WZReportController.h"
#import "UIViewController+WZFindController.h"
#import "WZBoardingItem.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZBoardingDetailsController.h"
#import "UIButton+WZEnlargeTouchAre.h"
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
    _boaringTimeOne.text = item.updateDate;
    _boaringTimeTwo.text = item.updateDate;
    _boaringTimeThree.text = item.updateDate;
    _boaringTimeFour.text = item.updateDate;
    //状态
    NSArray *stateArray = @[@"已报备", @"已上客", @"已成交",@"已失效"];
    NSString *state = item.dealStatus;
    //审核状态
    NSString *verify = item.verify;
    int verifys = [verify intValue];
    int states = [state intValue];
    _stateOne.text = stateArray[states-1];
    _stateTwo.text = stateArray[states-1];
    _buttonTwo.backgroundColor = UIColorRBG(3, 133, 219);
    [_buttonTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buttonTwo.enabled = YES;
    if (states == 3) {
        if (verifys == 1) {
             _stateThree.text = stateArray[states-1];
        }else if(verifys == 2){
            _stateTwo.text =  [_SHStatus[0] valueForKey:@"label"];
             _buttonTwo.backgroundColor = UIColorRBG(242, 242, 242);
            [_buttonTwo setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
            _buttonTwo.enabled = NO;
        }
    }
    if(states == 4){
        if (verifys == 3) {
            _stateFour.text = stateArray[3];
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
    _orderCreateTime = item.orderCreateTime;
}
- (void)awakeFromNib {
    [super awakeFromNib];
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
     _nameOne.textColor = UIColorRBG(68, 68, 68);
     _nameTwo.textColor = UIColorRBG(68, 68, 68);
     _nameThree.textColor = UIColorRBG(68, 68, 68);
     _nameFour.textColor = UIColorRBG(68, 68, 68);
    
    _telephoneOne.textColor = UIColorRBG(153, 153, 153);
    _telephoneTwo.textColor = UIColorRBG(153, 153, 153);
    _telephoneThree.textColor = UIColorRBG(153, 153, 153);
    _telephoneFour.textColor = UIColorRBG(153, 153, 153);
    
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
    
    _stateOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _stateOne.textColor = UIColorRBG(204, 204, 204);
    _stateTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _stateTwo.textColor = UIColorRBG(204, 204, 204);
    _stateThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _stateThree.textColor = UIColorRBG(204, 204, 204);
    _stateFour.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _stateFour.textColor = UIColorRBG(255, 104, 109);
    
    _buttonOne.backgroundColor = UIColorRBG(3, 133, 219);
    _buttonOne.layer.cornerRadius = 4.0;
    _buttonOne.layer.masksToBounds = YES;
    [_buttonOne setEnlargeEdge:22];
    _buttonTwo.backgroundColor = UIColorRBG(3, 133, 219);
    _buttonTwo.layer.cornerRadius = 4.0;
    _buttonTwo.layer.masksToBounds = YES;
    [_buttonTwo setEnlargeEdge:22];
    _buttonFour.backgroundColor = UIColorRBG(3, 133, 219);
    _buttonFour.layer.cornerRadius = 4.0;
    _buttonFour.layer.masksToBounds = YES;
    [_buttonFour setEnlargeEdge:22];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setFrame:(CGRect)frame{
     frame.size.height -=10;
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
            label.text =  [_SHStatus[0] valueForKey:@"label"];
            button.backgroundColor = UIColorRBG(242, 242, 242);
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
     WZReportController *report = [[WZReportController alloc] init];
     report.itemName = _ItemNameFour.text;
     report.itemID = _itemIdFour;
     report.sginStatus = _sginStatus;
     report.telphone = _proTelphone;
     report.name = _nameFour.text;
     report.phone = _telephoneFour.text;
     report.types = @"1";
     [Vc.navigationController pushViewController:report animated:YES];
}
@end
