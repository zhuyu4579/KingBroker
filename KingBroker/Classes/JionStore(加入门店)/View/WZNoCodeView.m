//
//  WZNoCodeView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/22.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZNoCodeView.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIViewController+WZFindController.h"
#import "WZExamineController.h"
#import "GKCover.h"
#import "WZAlertView.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "ZDMapController.h"
#import "WZNavigationController.h"
@interface WZNoCodeView()<UITextFieldDelegate>
//门店名称
@property(nonatomic,strong)UITextField *textStoreName;

@property(nonatomic,strong)UIViewController *Vc;
@property(nonatomic,strong)WZAlertView *redView;
@property(nonatomic,strong)UIButton *cardButton;
@property(nonatomic,strong)UIButton *cardButtonTwo;
//门店位置
@property(nonatomic,strong)UILabel *labelAddr;
//门店地址
@property(nonatomic,strong)UITextField *address;
//名片正面图片
@property(nonatomic,strong)UIImage *cardZ;
//名片反面图片
@property(nonatomic,strong)UIImage *cardF;
//名片正面图片
@property(nonatomic,strong)UIImage *imageOne;
//
@property(nonatomic,strong)UIImage *imageTwo;
//
@property(nonatomic,strong)NSString *lnglat;
//区域编码
@property(nonatomic,strong)NSString *adCode;
@end
@implementation WZNoCodeView

+(instancetype)noCodeView{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark -初始化控件
-(void)layoutSubviews{
    self.Vc = [UIViewController viewController:[self superview]];
    self.backgroundColor = [UIColor clearColor];
    //创建第一个view
    UIView *textNoView = [[UIView alloc] init];
    textNoView.frame = CGRectMake(0,0,SCREEN_WIDTH,137);
    textNoView.backgroundColor =UIColorRBG(255, 255, 255);
    [self addSubview:textNoView];
    //创建textNoView第一个lable
    UILabel *textNolabel = [[UILabel alloc] init];
    textNolabel.text = @"门店名称：";
    textNolabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    textNolabel.textColor = UIColorRBG(153, 153, 153);
    [textNoView addSubview:textNolabel];
    [textNolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNoView.mas_left).with.offset(15);
        make.top.equalTo(textNoView.mas_top).with.offset(15);
        make.height.mas_offset(14);
    }];
    //创建textNoView第二个lable
    UITextField *textNolabelTwo = [[UITextField alloc] init];
    textNolabelTwo.placeholder = @"必填";
    textNolabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    textNolabelTwo.textColor = UIColorRBG(68, 68, 68);
    _textStoreName = textNolabelTwo;
    textNolabelTwo.delegate = self;
    //键盘设置
    textNolabelTwo.keyboardType = UIKeyboardTypeDefault;
    [textNoView addSubview:textNolabelTwo];
    [textNolabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNolabel.mas_right).with.offset(0);
        make.top.equalTo(textNoView.mas_top).with.offset(0);
        make.height.mas_offset(45);
        make.width.offset(300);
    }];
    //绘制线
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(15,45, textNoView.fWidth-15, 1)];
    ineView.backgroundColor =UIColorRBG(242, 242, 242);
    [textNoView addSubview:ineView];
    
    UILabel *textNolabelAddr = [[UILabel alloc] init];
    textNolabelAddr.text = @"门店位置：";
    textNolabelAddr.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    textNolabelAddr.textColor = UIColorRBG(153, 153, 153);
    [textNoView addSubview:textNolabelAddr];
    [textNolabelAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNoView.mas_left).with.offset(15);
        make.top.equalTo(ineView.mas_bottom).with.offset(15);
        make.height.mas_offset(14);
    }];
    UIButton *addrButton = [[UIButton alloc] init];
    [addrButton setBackgroundImage:[UIImage imageNamed:@"place"] forState:UIControlStateNormal];
    [addrButton setEnlargeEdgeWithTop:20 right:200 bottom:20 left:20];
    [addrButton addTarget:self action:@selector(selectAddr) forControlEvents:UIControlEventTouchUpInside];
    [textNoView addSubview:addrButton];
    [addrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNolabelAddr.mas_right).with.offset(0);
        make.top.equalTo(ineView.mas_bottom).with.offset(12);
        make.height.mas_offset(22);
        make.width.offset(16);
    }];
    UILabel *textAddr = [[UILabel alloc] init];
    textAddr.text = @"点击选择";
    textAddr.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    textAddr.textColor = UIColorRBG(68, 68, 68);
    _labelAddr = textAddr;
    [textNoView addSubview:textAddr];
    [textAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrButton.mas_right).with.offset(10);
        make.top.equalTo(ineView.mas_bottom).with.offset(15);
        make.height.mas_offset(14);
    }];
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(15,91, textNoView.fWidth-15, 1)];
    ineViews.backgroundColor =UIColorRBG(242, 242, 242);
    [textNoView addSubview:ineViews];
    
    UILabel *labelAddress = [[UILabel alloc] init];
    labelAddress.text = @"门店地址：";
    labelAddress.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelAddress.textColor = UIColorRBG(153, 153, 153);
    [textNoView addSubview:labelAddress];
    [labelAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNoView.mas_left).with.offset(15);
        make.top.equalTo(ineViews.mas_bottom).with.offset(15);
        make.height.mas_offset(14);
    }];
    //创建textNoView第二个lable
    UITextField *address = [[UITextField alloc] init];
    address.placeholder = @"必填";
    address.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    address.textColor = UIColorRBG(68, 68, 68);
    _address = address;
    address.delegate = self;
    //键盘设置
    address.keyboardType = UIKeyboardTypeDefault;
    [textNoView addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelAddress.mas_right).with.offset(0);
        make.top.equalTo(ineViews.mas_bottom).with.offset(0);
        make.height.mas_offset(45);
        make.width.offset(300);
    }];
    
    //创建第二个view
    UIView *textNoViewTwo = [[UIView alloc] init];
    textNoViewTwo.frame = CGRectMake(0,textNoView.fY+textNoView.fHeight+10,SCREEN_WIDTH,174);
    textNoViewTwo.backgroundColor =UIColorRBG(255, 255, 255);
    [self addSubview:textNoViewTwo];
    //创建第二个view中的lable
    UILabel *Cardlabel = [[UILabel alloc] init];
    Cardlabel.text = @"上传名片";
    Cardlabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    Cardlabel.textColor = UIColorRBG(133, 133, 133);
    [textNoViewTwo addSubview:Cardlabel];
    [Cardlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNoViewTwo).with.offset(15);
        make.top.equalTo(textNoViewTwo.mas_top).with.offset(15);
        make.height.mas_offset(13);
    }];
    //创建第二个view中的第一个按钮
    _cardButton = [[UIButton alloc] init];
    [_cardButton setBackgroundImage:[UIImage imageNamed:@"uplosdpictures_2"] forState:UIControlStateNormal];
    _cardButton.tag = 121;
    [_cardButton addTarget:self action:@selector(upCardPositive:) forControlEvents:UIControlEventTouchUpInside];
    [textNoViewTwo addSubview:_cardButton];
     _cardZ = _cardButton.currentBackgroundImage;
    [_cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textNoViewTwo).with.offset(25);
        make.top.equalTo(textNoViewTwo.mas_top).with.offset(58);
        make.height.mas_offset(85);
        make.width.mas_offset(138);
    }];
    
    //创建第二个view中的第二个按钮
    _cardButtonTwo = [[UIButton alloc] init];
    [_cardButtonTwo setBackgroundImage:[UIImage imageNamed:@"uplosdpictures_3"] forState:UIControlStateNormal];
    [_cardButtonTwo addTarget:self action:@selector(upCardPositive:) forControlEvents:UIControlEventTouchUpInside];
    _cardButtonTwo.tag = 122;
    [textNoViewTwo addSubview:_cardButtonTwo];
       _cardF = _cardButtonTwo.currentBackgroundImage;
    [_cardButtonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textNoViewTwo.mas_right).with.offset(-25);
        make.top.equalTo(textNoViewTwo.mas_top).with.offset(58);
        make.height.equalTo(_cardButton.mas_height);
        make.width.mas_offset(138);
    }];
    //创建self的lable
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"1.上传名片正反面照片，拍摄时确保名片边缘完整，字体清晰，亮度均匀\n2.照片必须真实拍摄，不得使用复印件和扫描件";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    labelOne.textColor = UIColorRBG(153, 153, 153);
    [labelOne setNumberOfLines:0];
    
    labelOne.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(textNoViewTwo.mas_bottom).with.offset(5);
       
    }];
    //按钮一
    UIButton *noSubitemButton = [[UIButton alloc] init];
    [noSubitemButton setTitle:@"提交审核" forState: UIControlStateNormal];
    [noSubitemButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [noSubitemButton setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    noSubitemButton.titleLabel.font = [UIFont systemFontOfSize:16];
    //textButton.enabled = NO;
    noSubitemButton.layer.cornerRadius = 4.0;
    noSubitemButton.layer.masksToBounds = YES;
    noSubitemButton.backgroundColor = UIColorRBG(3, 133, 219);
    
    [noSubitemButton addTarget:self action:@selector(noSubitemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noSubitemButton];
    [noSubitemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.mas_offset(44);
    }];

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
    
    if (toBeString.length>25) {
        return NO;
    }
    return YES;
}
#pragma mark -选择城市
-(void)selectAddr{
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.Vc.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _labelAddr.text = [address valueForKey:@"address"];
        _lnglat = [address valueForKey:@"lnglat"];
        _adCode = [address valueForKey:@"adcode"];
    };
}
#pragma mark -拍摄名片正面照
-(void)upCardPositive:(UIButton *)button{
    
    _redView = [WZAlertView new];
    if (button.tag == 121) {
        _redView.imageName = @"sketchmap_2";
    }else{
        _redView.imageName = @"sketchmap_3";
    }
    
    _redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:_Vc.view
           contentView:_redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
              ];
    _redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        if (button.tag == 121) {
            _imageOne = image;
        }else{
            _imageTwo = image;
        }
    };
    
}

#pragma mark -提交审核
-(void)noSubitemAction:(UIButton *)button{
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    [self performSelector:@selector(loadData) withObject:self afterDelay:1];
    
}
-(void)loadData{
    UITextField *textName = (UITextField *) [self.superview.superview viewWithTag:199];
    [textName resignFirstResponder];
    if([_JName isEqual:@""]){
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"经纪人姓名不能为空"];
        return;
    }
    //门店位置
    NSString *storeAddr = _labelAddr.text;
    if ([storeAddr isEqual:@"点击选择"]||!storeAddr) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    //门店名称
    NSString *storeName = _textStoreName.text;
    if ([storeName isEqual:@""]||!storeName) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"门店名称不能为空"];
        return;
    }
    //门店地址
    NSString *address = _address.text;
    if ([address isEqual:@""]||!address) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"门店地址不能为空"];
        return;
    }
    UIImage *imageOne = _cardButton.currentBackgroundImage;
    UIImage *imageTwo = _cardButtonTwo.currentBackgroundImage;
    if ([_cardZ isEqual:imageOne]||[_cardF isEqual:imageTwo]) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"名片不能为空"];
        return;
    }
    //创建会话
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *parament = [NSMutableDictionary dictionary];
    parament[@"realname"] = _JName;
    parament[@"cityName"] = storeAddr;
    parament[@"address"] = address;
    parament[@"storeName"] = storeName;
    parament[@"lnglat"] = _lnglat;
    parament[@"adCode"] = _adCode;
    parament[@"type"] = _type;
    NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/cardAuthentication",URL];
    [mgr POST:url parameters:parament constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = [WZAlertView imageProcessWithImage:_imageOne];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
        NSData *imageData1 = [WZAlertView imageProcessWithImage:_imageTwo];//进行图片压缩
        // 使用日期生成图片名称
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName1 = [NSString stringWithFormat:@"%@.png",[formatter1 stringFromDate:[NSDate date]]];
        // 任意的二进制数据MIMEType application/octet-stream
        [formData appendPartWithFileData:imageData1 name:@"opposite" fileName:fileName1 mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [GKCover hide];
            [SVProgressHUD dismiss];
             WZExamineController *exVc = [[WZExamineController alloc] init];
             WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:exVc];
            [self.Vc.navigationController presentViewController:nav animated:YES completion:nil];
            
        }else{
            [GKCover hide];
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textStoreName resignFirstResponder];
    [self.address resignFirstResponder];
}
@end
