//
//  WZSetInfertionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSetInfertionView.h"
#import "ZDAlertView.h"
#import "GKCover.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <BRPickerView.h>
#import "WZBelongedStoreController.h"
#import "UIViewController+WZFindController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
@interface WZSetInfertionView()<UITextFieldDelegate>
//性别
@property(nonatomic,strong)NSString *sexs;
//姓名
@property(nonatomic,strong)NSString *relname;
//籍贯
@property(nonatomic,strong)NSString *navitePlace;
//入职时间
@property(nonatomic,strong)NSString *hiredate;
//从业时间
@property(nonatomic,strong)NSString *startWorkTime;
//出生日期
@property(nonatomic,strong)NSString *birthday;
//数据字典
@property(nonatomic,strong)NSDictionary *loginItem;
@end
@implementation WZSetInfertionView
//返回自己
+(instancetype)setInforation{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
//初始化控件
-(void)layoutSubviews{
    _name.textColor = UIColorRBG(51, 51, 51);
    _name.keyboardType = UIKeyboardTypeDefault;
    _name.delegate = self;
   
    _sex.textColor = UIColorRBG(204, 204, 204);
    _manSex.textColor = UIColorRBG(204, 204, 204);
    
    _birthDate.textColor = UIColorRBG(204, 204, 204);
    _birthAddress.textColor = UIColorRBG(204, 204, 204);
    _employmentTime.textColor = UIColorRBG(204, 204, 204);
    _entryTime.textColor = UIColorRBG(204, 204, 204);
   
    _headImage.layer.cornerRadius=self.headImage.frame.size.width/2;//裁成圆角
    _headImage.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    _headImage.layer.borderWidth = 0.5f;//边框宽度
    _headImage.layer.borderColor = [UIColor whiteColor].CGColor;//边框颜色
    
    [_selectWomanSex setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [_selectSexMan setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
}
//保存修改个人信息
-(void)loadData:(UIImage *)image{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"realname"] = _relname;
    paraments[@"sex"] = _sexs;
    paraments[@"navitePlace"] = _navitePlace;
    paraments[@"hiredate"] = _hiredate;
    paraments[@"startWorkTime"] = _startWorkTime;
    paraments[@"birthday"] = _birthday;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/update",HTTPURL];
    [mgr POST:url parameters:paraments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            NSData *imageData = [ZDAlertView imageProcessWithImage:image];//进行图片压缩
            // 使用日期生成图片名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            // 任意的二进制数据MIMEType application/octet-stream
            [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if([code isEqual:@"200"]){
            if (image) {
                 _headImage.image = image;
            }
           
            NSDictionary *data = [responseObject valueForKey:@"data"];
            _loginItem = data;
            [self setDatas];
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
//设置数据
-(void)setDatas{
    
    _manSex.textColor = UIColorRBG(204, 204, 204);
    _sex.textColor = UIColorRBG(204, 204, 204);
    _selectSexMan.selected = NO;
    _selectWomanSex.selected = NO;
    
    //姓名
    _name.text = [_loginItem valueForKey:@"realname"];
    //性别
    NSString *sex = [_loginItem valueForKey:@"sex"];
    if ([sex isEqual:@"1"]) {
        _selectSexMan.selected = YES;
        _manSex.textColor = UIColorRBG(51, 51, 51);
    }else if([sex isEqual:@"2"]){
        _selectWomanSex.selected = YES;
        _sex.textColor = UIColorRBG(51, 51, 51);
    }else{
        _selectSexMan.selected = YES;
        _manSex.textColor = UIColorRBG(51, 51, 51);
    }
    
    //出生年月
    NSString *birthDate = [_loginItem valueForKey:@"birthday"];
    if (birthDate&&![birthDate isEqual:@""]) {
        _birthDate.text = birthDate;
    }else{
        _birthDate.text = @"请选择";
    }
    //籍贯
    NSString *birthAddress = [_loginItem valueForKey:@"navitePlace"];
    if (birthAddress&&![birthAddress isEqual:@""]){
        _birthAddress.text = birthAddress;
    }else{
        _birthAddress.text = @"请选择";
    }
    //从业时间
    NSString *employmentTime = [_loginItem valueForKey:@"startWorkTime"];
    if (employmentTime&&![employmentTime isEqual:@""]){
       _employmentTime.text = employmentTime;
    }else{
        _employmentTime.text = @"请选择";
    }
    //入职时间
    NSString *entryTime = [_loginItem valueForKey:@"hiredate"];
    if (entryTime&&![entryTime isEqual:@""]){
        _entryTime.text = entryTime;
    }else{
        _entryTime.text = @"请选择";
    }
    _url = [_loginItem valueForKey:@"portrait"];
}
//设置头像
- (IBAction)setUpHeadImage:(UIButton *)sender {
    [self.name resignFirstResponder];
    ZDAlertView  *redView = [ZDAlertView new];
    redView.url = _url;
    redView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.8];
    redView.fSize = CGSizeMake(KScreenW, 211);
    [GKCover coverFrom:self.superview.superview
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
       
        [self loadData:image];
    };
}
//选择性别
- (IBAction)selectSex:(UIButton *)sender {
    _manSex.textColor = UIColorRBG(204, 204, 204);
    _sex.textColor = UIColorRBG(204, 204, 204);
    _selectSexMan.selected = NO;
    _selectWomanSex.selected = NO;
    sender.selected = YES;
    if (sender.tag == 10) {
        _manSex.textColor = UIColorRBG(51, 51, 51);
        _sexs = @"1";
    }else{
        _sex.textColor = UIColorRBG(51, 51, 51);
        _sexs = @"2";
    }
    [self loadData:nil];
}
// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField{
     _relname = textField.text;
     [self loadData:nil];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length>15) {
        return NO;
    }
    return YES;
}

//出生日期
- (IBAction)setUpBirthDate:(UIButton *)sender {
    [self.name resignFirstResponder];
    [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
        _birthday = selectValue;
        [self loadData:nil];
    }];
}

- (IBAction)setUpEmploymentTime:(UIButton *)sender {
    [self.name resignFirstResponder];
    [BRDatePickerView showDatePickerWithTitle:@"从业时间" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
        _startWorkTime = selectValue;
        [self loadData:nil];
    }];
}

- (IBAction)setUpBirthAddress:(id)sender {
    [self.name resignFirstResponder];
    
    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@"浙江省",@"杭州市",@"西湖区"] resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        _navitePlace = [NSString stringWithFormat:@"%@%@%@",province.name,city.name,area.name];
        [self loadData:nil];
    }];
//    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea defaultSelected:@[@"浙江省",@"杭州市",@"西湖区"] isAutoSelect:NO themeColor:nil resultBlock:^(NSArray *selectAddressArr) {
//        NSString *addr = @"";
//        for (NSString *str in selectAddressArr) {
//            addr = [NSString stringWithFormat:@"%@%@",addr,str];
//        }
//        _navitePlace = addr;
//        [self loadData:nil];
//    } cancelBlock:^{
//
//    }];
}
//入职时间
- (IBAction)setUpEntryTime:(UIButton *)sender {
    [BRDatePickerView showDatePickerWithTitle:@"入职时间" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
        _hiredate = selectValue;
        [self loadData:nil];
    }];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.name resignFirstResponder];
}
@end
