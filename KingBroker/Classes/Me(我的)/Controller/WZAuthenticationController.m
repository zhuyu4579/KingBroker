//
//  WZAuthenticationController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAuthenticationController.h"
#import "GKCover.h"
#import "WZAlertView.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "NSString+LCExtension.h"
#import "ZDAlertView.h"
@interface WZAuthenticationController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIImage *image;

@end

@implementation WZAuthenticationController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@""]];
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"实名认证";
    _headHeight.constant = kApplicationStatusBarHeight+54;
    _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _titleLabel.textColor = UIColorRBG(153, 153, 153);
    _getUpButton.backgroundColor = UIColorRBG(3, 133, 219);
    [_getUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    _getUpButton.layer.cornerRadius = 5.0;
    _getUpButton.layer.masksToBounds = YES;
    _name.keyboardType = UIKeyboardTypeDefault;
    _name.delegate = self;
    _idCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _idCode.delegate = self;
    //给照片view绑定点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [_codeImage addGestureRecognizer:tapGesture];
    _codeImage.userInteractionEnabled = YES;
    
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
    
    if (toBeString.length>20) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//点击图片拍照
-(void)clickImage{
   WZAlertView *redView = [WZAlertView new];
    redView.imageName = @"sketchmap";
    redView.fSize = CGSizeMake(KScreenW, 327);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    redView.imageBlock = ^(UIImage *image) {
        [_codeImage setImage:image];
        _image = image;
    };
}

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_idCode resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
//提交实名认证
- (IBAction)comfireButton:(id)sender {
    UIButton *button = sender;
    if (!_image) {
      [SVProgressHUD showInfoWithStatus:@"请上传身份证照片"];
        return;
    }
    NSString *name = _name.text;
    if (!name) {
        [SVProgressHUD showInfoWithStatus:@"真实姓名不能为空"];
        return;
    }
    NSString *idCode = _idCode.text;
    if(!idCode || idCode.length!=18){
        [SVProgressHUD showInfoWithStatus:@"请输入正确的身份证号码"];
        return;
    }
  
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
        [SVProgressHUD showWithStatus:@"提交中"];
        button.enabled = NO;
        //创建会话
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 60;
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"realname"] =name;
        paraments[@"idCard"] = idCode;
        NSString *url = [NSString stringWithFormat:@"%@/sysAuthenticationInfo/realnameAuthentication",URL];
        [mgr POST:url parameters:paraments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            NSData *imageData = [ZDAlertView imageProcessWithImage:_image];//进行图片压缩
            // 使用日期生成图片名称
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
            // 任意的二进制数据MIMEType application/octet-stream
            [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            
            NSString *code = [responseObject valueForKey:@"code"];
             button.enabled = NO;
            [SVProgressHUD dismiss];
            if ([code isEqual:@"200"]) {
                NSString *status = [responseObject valueForKey:@"data"];
                if (_statusBlock) {
                    _statusBlock(status);
                }
                [SVProgressHUD showSuccessWithStatus:@"实名认证审核中"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            button.enabled = NO;
            [SVProgressHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }];
   
}
@end
