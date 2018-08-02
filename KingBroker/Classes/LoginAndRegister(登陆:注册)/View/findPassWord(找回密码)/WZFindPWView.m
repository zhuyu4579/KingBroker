//
//  WZFindPWView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZFindPWView.h"
#import "UIViewController+WZFindController.h"
#import "WZSetNewPassWordController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZModifyPhoneController.h"
@interface WZFindPWView()
//用户名
@property(nonatomic,strong)NSString *username;

@end
@implementation WZFindPWView

+(instancetype)findPWView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark -下一步
- (void)findNextAction:(id)sender {
    //判定是修改绑定手机号
    NSString *type = _modityId;
    //获取手机文本框的手机号码
    NSString  *phone = _findPSText.text;
    if (_username) {
        phone = _username;
    }
    //判断手机格式是否正确
    if (phone.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    NSString *types = @"3";
    if(type){
        types = @"2";
    }
    NSString *YZM = self.findArgeementText.text;
    
    //[self openCountdown];
    
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = types;
    paraments[@"telphone"] = phone;
    paraments[@"smsCode"] = YZM;
    NSString *url = [NSString stringWithFormat:@"%@/app/checkSmsCode",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            //判定是否是修改手机号
            if (type) {
                WZModifyPhoneController *modifyPhone = [[WZModifyPhoneController alloc] init];
                modifyPhone.oldPhone = phone;
                modifyPhone.password = type;
                modifyPhone.oldYZM = YZM;
                modifyPhone.navigationItem.title = @"修改绑定手机";
                [Vc.navigationController pushViewController:modifyPhone animated:YES];
            }else{
                WZSetNewPassWordController *NewPWC = [[WZSetNewPassWordController alloc] init];
                NewPWC.phone = phone;
                NewPWC.YZM = YZM;
                [Vc.navigationController pushViewController:NewPWC animated:YES];
            }
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

#pragma mark -获取验证码
- (void)findYZMAction:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];

    //获取手机文本框的手机号码
    NSString  *phone = _findPSText.text;
    if (_username) {
        phone = _username;
    }
     NSString *type = @"3";
    if(_modityId){
       type = @"2";
    }
    
    //判断手机格式是否正确
    if (phone.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    [self openCountdown];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = type;
    paraments[@"telphone"] = phone;
    NSString *url = [NSString stringWithFormat:@"%@/app/read/sendSmsByType",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
       
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"已发送"];
            //修改按钮内容倒计时一分钟
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
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.findYZMTextTow setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.findYZMTextTow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.findYZMTextTow.userInteractionEnabled = YES;
                self.findYZMTextTow.backgroundColor = UIColorRBG(3, 133, 219);
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.findYZMTextTow setTitle:[NSString stringWithFormat:@"%.2d后重试", seconds] forState:UIControlStateNormal];
                [self.findYZMTextTow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.findYZMTextTow.userInteractionEnabled = NO;
                self.findYZMTextTow.backgroundColor = UIColorRBG(199, 199, 205);
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -设置按钮
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //设置发送验证码按钮
    self.findYZMTextTow.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    self.findYZMTextTow.layer.cornerRadius = 3.0;
    self.findYZMTextTow.layer.masksToBounds = YES;
    [self.findYZMTextTow addTarget:self action:@selector(findYZMAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置下一步按钮
    self.findNextText.layer.cornerRadius = 4.0;
    self.findNextText.layer.masksToBounds = YES;
    self.findNextText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.findNextText addTarget:self action:@selector(findNextAction:) forControlEvents:UIControlEventTouchUpInside];
    self.findNextText.enabled = NO;
    [self setFindFile];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [ user objectForKey:@"username"];
    
    if (username) {
        self.findPSText.text = username;
        _username = username;
        NSString *top = [username substringToIndex:3];
        NSString *bottom = [username substringFromIndex:7];
        self.findPSText.text = [NSString stringWithFormat:@"请输入%@****%@收到的短信验证码",top,bottom];
        self.findPSText.enabled = NO;
        [self.findArgeementText becomeFirstResponder];
        self.findYZMTextTow.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
        self.findYZMTextTow.enabled = YES;
    }else{
       [self.findPSText becomeFirstResponder];
      
    }
    
}
-(void)setFindFile{
    //设置账户的底线
    self.findPSText.placeholder = @"请输入手机号";
    self.findPSText.textColor =  UIColorRBG(68, 68, 68);
    self.findPSText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,self.findPSText.bounds.size.height-1, self.findPSText.bounds.size.width, 1)];
    ineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.findPSText.keyboardType = UIKeyboardTypeNumberPad;
    [self.findPSText addSubview:ineView];
    self.findPSText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.findPSText addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //设置验证码输入框的底线
    self.findArgeementText.placeholder = @"输入验证码";
    self.findArgeementText.textColor =   UIColorRBG(68, 68, 68);
    self.findArgeementText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(0,self.findArgeementText.bounds.size.height-1, self.findPSText .bounds.size.width, 1)];
    ineViews.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [self.findArgeementText addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //键盘设置
    self.findArgeementText.keyboardType = UIKeyboardTypeNumberPad;
    self.findArgeementText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.findArgeementText addSubview:ineViews];
}
//文本框值改变事件
-(void)usernameTextFieldChanged:(UITextField *)sender{
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    NSString *admin =  sender.text;
    NSInteger tag = sender.tag;
    UIButton *btu =(UIButton *) [Vc.view viewWithTag:(tag+1)];
    [btu setEnlargeEdge:20];
    //判定获取验证码按钮是否亮起
    if(tag == 10){
        if (admin.length == 11) {
            self.findYZMTextTow.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
            self.findYZMTextTow.enabled = YES;
            
        }else{
            self.findYZMTextTow.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
             self.findYZMTextTow.enabled = NO;
        }
        
    }
    
    //判定下一步按钮是否亮起
    if(self.findPSText.text.length==11&&self.findArgeementText.text.length==6){
        self.findNextText.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
        self.findNextText.enabled = YES;
    }else{
        if (_username && self.findArgeementText.text.length==6) {
            self.findNextText.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
            self.findNextText.enabled = YES;
        }else{
            self.findNextText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
            self.findNextText.enabled = NO;
        }
       
        
    }
}

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.findPSText resignFirstResponder];
    [self.findArgeementText resignFirstResponder];
}
@end
