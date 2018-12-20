//
//  WZCompanyInfoController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/12/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "ZDMapController.h"
#import "NSString+LCExtension.h"
#import "WZCompanyInfoController.h"

@interface WZCompanyInfoController ()<UITextFieldDelegate>
//公司ID
@property(nonatomic,strong)NSString *ID;
//公司名称
@property(nonatomic,strong)UITextField *companyName;
//楼盘位置
@property(nonatomic,strong)UILabel *houseAddress;
//楼盘坐标
@property(nonatomic,strong)NSString *houseLnglat;
//楼盘AdCode
@property(nonatomic,strong)NSString *houseAdCode;
//楼盘地址
@property(nonatomic,strong)UITextField *houseAddr;

@end

@implementation WZCompanyInfoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公司信息";
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+52, self.view.fWidth, 50)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    UIView *viewTwo_one = [self createViewOne:@"公司名称" contents:@"" fY:0 isDel:@"" unit:@"" setKeyboard:@""];
    [viewOne addSubview:viewTwo_one];
    UITextField *companyName = [viewTwo_one viewWithTag:20];
    _companyName = companyName;
    
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, viewOne.fY+viewOne.fHeight+8, self.view.fWidth, self.view.fHeight-viewOne.fY-viewOne.fHeight-8)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTwo];
    
    UIView *viewThree_one = [self createViewClass:@selector(selectAddress) image:[UIImage imageNamed:@"zc_map"] title:@"公司位置" fY:0 size:CGSizeMake(20, 26)];
    [viewTwo addSubview:viewThree_one];
    UILabel *houseAddress = [viewThree_one viewWithTag:30];
    _houseAddress = houseAddress;
    UIView *ineThree = [[UIView alloc] initWithFrame:CGRectMake(15, 49, viewTwo.fWidth-30, 1)];
    ineThree.backgroundColor = UIColorRBG(240, 240, 240);
    [viewTwo addSubview:ineThree];
    UIView *viewThree_two = [self createViewOne:@"公司地址" contents:@"" fY:50 isDel:@"" unit:@"" setKeyboard:@""];
    [viewTwo addSubview:viewThree_two];
    UITextField *houseAddr = [viewThree_two viewWithTag:20];
    _houseAddr = houseAddr;
    
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(15, 99, viewTwo.fWidth-30, 1)];
    ineFour.backgroundColor = UIColorRBG(240, 240, 240);
    [viewTwo addSubview:ineFour];
    //获取总代信息
    [self findGeneration];
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
        [self submission];
    };
}
#pragma mark -总代信息查询
-(void)findGeneration{
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
    
    NSString *url = [NSString stringWithFormat:@"%@/userCompany/userCompanyName",HTTPURL];
    
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            _ID = [data valueForKey:@"id"];
            _companyName.text = [data valueForKey:@"companyName"];
            _houseAddress.textColor = UIColorRBG(51, 51, 51);
            _houseAddress.text = [data valueForKey:@"position"];
            _houseLnglat = [data valueForKey:@"lnglat"];
            _houseAddr.text = [data valueForKey:@"address"];
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
        
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
#pragma mark -提交
-(void)submission{
    //公司名称
    NSString *companyName = _companyName.text;
    companyName = [companyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([companyName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"公司名称不能为空"];
        return;
    }
    //楼盘位置
    NSString *houseAddress = _houseAddress.text;
    houseAddress = [houseAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([houseAddress isEqual:@""]||[houseAddress isEqual:@"点击选择"]) {
        [SVProgressHUD showInfoWithStatus:@"公司位置不能为空"];
        return;
    }
    //楼盘地址
    NSString *houseAddr = _houseAddr.text;
    houseAddr = [houseAddr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([houseAddr isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"公司地址不能为空"];
        return;
    }
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
    paraments[@"id"] = _ID;
    paraments[@"companyName"] = companyName ;
    paraments[@"lnglat"] = _houseLnglat;
    paraments[@"adcode"] = _houseAdCode;
    paraments[@"address"] = houseAddr;
    NSString *url = [NSString stringWithFormat:@"%@/userCompany/createOrUpdate",HTTPURL];
    
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"保存成功"];
            //将总代数据保存
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[data valueForKey:@"companyName"] forKey:@"companyName"];
            [defaults synchronize];
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
        
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}

#pragma mark -抽取第一个view
-(UIView *)createViewOne:(NSString *)title contents:(NSString *)str fY:(CGFloat)fY isDel:(NSString *)isDel unit:(NSString *)unit setKeyboard:(NSString *)keyboard{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, fY, self.view.fWidth, 49)];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, fY, self.view.fWidth, 49)];
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
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self submission];
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
    
    [self.view endEditing:YES];
}
-(void)touches{
    
    [self.view endEditing:YES];
}

@end
