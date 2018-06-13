//
//  WZRegistarView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZRegistarView.h"
#import "WZRegSetPWController.h"
#import "UIViewController+WZFindController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZNEWHTMLController.h"
@interface WZRegistarView()
//定时器
@property(nonatomic,weak)NSTimer *timer;

@end
@implementation WZRegistarView

+(instancetype)registarView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
#pragma mark -获取验证码
- (void)obtainYZMVerificationCode:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];

    //获取手机文本框的手机号码
   NSString  *phone = _regAdminText.text;
    
    NSString *type = @"1";
    //判断手机格式是否正确
    if (phone.length != 11) {
        [SVProgressHUD showInfoWithStatus:@"手机格式错误"];
        return;
    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 60;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = type;
    paraments[@"telphone"] = phone;
    NSString *url = [NSString stringWithFormat:@"%@/app/read/sendSmsByType",URL];
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
        [self openCountdown];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
                [self.findYZMText setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.findYZMText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.findYZMText.userInteractionEnabled = YES;
                self.findYZMText.backgroundColor = UIColorRBG(3, 133, 219);
            });
            
        }else{
           
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.findYZMText.userInteractionEnabled = NO;
                //设置按钮显示读秒效果
                [self.findYZMText setTitle:[NSString stringWithFormat:@"%.2d后重试", seconds] forState:UIControlStateNormal];
                [self.findYZMText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.findYZMText.backgroundColor = UIColorRBG(199, 199, 205);
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark -查看协议
- (IBAction)seeAgreement:(id)sender {
    WZNEWHTMLController *html = [[WZNEWHTMLController alloc] init];
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    html.url = @"https://www.jingfuapp.com/apph5/agreement.html";
    [Vc.navigationController pushViewController:html animated:YES];
}
#pragma mark -下一页
- (void)nextAction:(id)sender {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    WZRegSetPWController *ragSetPwVc = [[WZRegSetPWController alloc] init];
    //获取手机号和验证码存储带到下个页面
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    NSString *telephone = _regAdminText.text;
    //暂时
    dicty[@"phone"] = telephone;
    
    dicty[@"verificationCode"] = _regPasswordText.text;
    
    ragSetPwVc.registar = dicty;
    //跳转下一个页面
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"1";
    paraments[@"telphone"] = telephone;
    paraments[@"smsCode"] = _regPasswordText.text;
    NSString *url = [NSString stringWithFormat:@"%@/app/checkSmsCode",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        [self openCountdown];
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [Vc.navigationController pushViewController:ragSetPwVc animated:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    //传值
    if (_registarBlock) {
        ragSetPwVc.regBlock = ^(NSDictionary *regs) {
            _registarBlock(regs);
        };
    }
}

#pragma mark -设置按钮属性
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //设置验证码按钮
    [self.findYZMText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.findYZMText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.findYZMText addTarget:self action:@selector(obtainYZMVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.findYZMText.layer.cornerRadius = 3.0;
    self.findYZMText.layer.masksToBounds = YES;
    self.findYZMText.enabled = NO;
    //设置协议按钮
    [self.XYText setImage:[UIImage imageNamed:@"WechatIMG-ioc"] forState:UIControlStateNormal];
    [self.XYText setImage:[UIImage imageNamed:@"WechatIMG"] forState:UIControlStateSelected];
    [self.XYText addTarget:self action:@selector(agreementButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.XYText setEnlargeEdge:40];
    [_agreementButton setEnlargeEdge:20];
    //设置下一步按钮
    self.findYZMText.layer.cornerRadius = 4.0;
    self.findYZMText.layer.masksToBounds = YES;
    [self.nextText setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
    [self.nextText addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    self.nextText.enabled = NO;
    [self setTextFile];
}
#pragma mark -设置文本框的属性
-(void)setTextFile{
    //设置账户的底线
    self.regAdminText.placeholder = @"请输入手机号";
    self.regAdminText.textColor =  UIColorRBG(68, 68, 68);
    self.regAdminText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineView = [[UIView alloc] initWithFrame: CGRectMake(0,self.regAdminText.bounds.size.height-1, self.regAdminText.bounds.size.width, 1)];
    ineView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.regAdminText.keyboardType = UIKeyboardTypePhonePad;
    [self.regAdminText addSubview:ineView];
    [self.regAdminText becomeFirstResponder];
    //绑定值改变触发事件
    [self.regAdminText addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
   
    //设置验证码输入框的底线
    self.regPasswordText.placeholder = @"输入验证码";
    self.regPasswordText.textColor =    UIColorRBG(68, 68, 68);
    self.regPasswordText.font = [UIFont fontWithName:@"Arial" size:15.0f];
    UIView *ineViews = [[UIView alloc] initWithFrame: CGRectMake(0,self.regPasswordText.bounds.size.height-1, self.regPasswordText.bounds.size.width, 1)];
    ineViews.backgroundColor =[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    //绑定值改变触发事件
    [self.regPasswordText addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //键盘设置
    self.regPasswordText.keyboardType = UIKeyboardTypePhonePad;
    [self.regPasswordText addSubview:ineViews];
    //设置同意label颜色
    self.labels.textColor =  [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:226.0/255.0 alpha:1.0];
    [self.agreementButton setTitleColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0] forState:UIControlStateNormal];
}

//文本框值改变事件
-(void)usernameTextFieldChanged:(UITextField *)sender{
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    NSString *admin =  sender.text;
    NSInteger tag = sender.tag;
    UIButton *btu =(UIButton *) [Vc.view viewWithTag:(tag+1)];
    //判定获取验证码按钮是否亮起
    if(tag == 10){
        if (admin.length == 11) {
            self.findYZMText.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
            self.findYZMText.enabled = YES;
        }else{
            self.findYZMText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
     
            self.findYZMText.enabled = NO;
        }
        
    }
    //绑定clean点击事件
    if (admin.length==1) {
        [btu setImage:[UIImage imageNamed:@"clear-All"] forState:UIControlStateNormal];
        //绑定清楚点击事件
        [btu addTarget:self action:@selector(cleanAdmin:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (admin.length == 0) {
        [btu setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btu removeTarget:self action:@selector(cleanAdmin:) forControlEvents:UIControlEventTouchUpInside];
    }
    //判定下一步按钮是否亮起
    if(self.regAdminText.text.length==11&&self.regPasswordText.text.length==6&&self.XYText.selected){
        self.nextText.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
        self.nextText.enabled = YES;

    }else{
        self.nextText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
        self.nextText.enabled = NO;

    }
        
    
}
#pragma mark -清除账号
- (void)cleanAdmin:(UIButton *)button{
    
    NSInteger tag = button.tag;
    if (tag == 11) {
        
        self.regAdminText.text = @"";
        
        [self usernameTextFieldChanged:self.regAdminText];
    }
    if (tag == 21) {
        self.regPasswordText.text = @"";
        
        [self usernameTextFieldChanged:self.regPasswordText];
    }
      self.nextText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];

      self.nextText.enabled = NO;

}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.regAdminText resignFirstResponder];
    [self.regPasswordText resignFirstResponder];
}
#pragma mark -同意协议
- (void)agreementButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    //判断下一步按钮是否亮起绑定事件
    if(button.selected && self.regAdminText.text.length==11 && self.regPasswordText.text.length==6){
        self.nextText.backgroundColor = [UIColor colorWithRed:3.0/255.0 green:133.0/255.0 blue:219.0/255.0 alpha:1.0];
        self.nextText.enabled = YES;
    }else{
        self.nextText.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1.0];
        
        self.nextText.enabled = NO;
    }
    
}
@end
