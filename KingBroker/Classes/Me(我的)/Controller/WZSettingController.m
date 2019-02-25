//
//  WZSettingController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSettingController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZablumController.h"
#import "WZNewJionStoreController.h"
#import "WZNavigationController.h"
#import "WZUpdateCardController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZValidateCodeController.h"
#import "WZReadPassWordController.h"
#import "WZAuthenticationController.h"
#import "WZAuthenSuccessController.h"
#import <CloudPushSDK/CloudPushSDK.h>
@interface WZSettingController ()
@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;
@end

@implementation WZSettingController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    _headHeight.constant = kApplicationStatusBarHeight+54;
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"设置";
    self.cacha.textColor = UIColorRBG(102, 102, 102);
    _telphone.textColor = UIColorRBG(102, 102, 102);
    [_authenImage sizeToFit];
    [self.ExitLogon setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    
     _cacha.text = [self sizeStr];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSInteger businessCardStatus = [[user objectForKey:@"businessCardStatus"] integerValue];
    NSLog(@"%ld",(long)businessCardStatus);
    NSString *username = [user objectForKey:@"username"];
    if(username.length>0){
        NSString *top = [username substringToIndex:3];
        NSString *bottom = [username substringFromIndex:7];
        _telphone.text = [NSString stringWithFormat:@"%@****%@",top,bottom];
    }
    if (businessCardStatus == 0||businessCardStatus == 3) {
        
        if (businessCardStatus == 3) {
            _authenImage.image = [UIImage imageNamed:@"authenticated-1"];
        }
    }else if(businessCardStatus == 2){
        
        _authenImage.image = [UIImage imageNamed:@"authenticated2"];
        
    }
}

//退出登录
- (IBAction)exitLogin:(id)sender {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确认退出当前账号" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    _okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        // 1.清除用户名、密码的存储
        
        // 2.跳转到登录界面
        [self eixtLoginData];
    }];
    _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_okAction setValue:UIColorRBG(255, 216, 0) forKey:@"_titleTextColor"];
    [_cancelAction setValue:UIColorRBG(255, 216, 0) forKey:@"_titleTextColor"];
    [alert addAction:_okAction];
    [alert addAction:_cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];

}
//退出登录数据请求
-(void)eixtLoginData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/app/logout.api",HTTPURL];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            //清除持久数据
            [SVProgressHUD showInfoWithStatus:@"退出成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //退出的时候删除别名
            [CloudPushSDK removeAlias:[userDefaults objectForKey:@"userId"] withCallback:^(CloudPushCallbackResult *res) {
                NSLog(@"删除别名成功");
            }];
            
            NSDictionary *dic = [userDefaults dictionaryRepresentation];
            for (NSString *key in dic) {
                if (![key isEqual:@"oldName"] &&![key isEqual:@"appVersion"]&&![key isEqual:@"deviceId"]&&![key isEqual:@"timeOne"]) {
                    [userDefaults removeObjectForKey:key];
                }
            }
            [userDefaults synchronize];
            
            //获取指定item
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
            
            item.badgeValue= nil;
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"退出失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
//关于我们
- (IBAction)aboutus:(UIButton *)sender {
    //跳转关于我们界面
    WZablumController *aboutus = [[WZablumController alloc] init];
    [self.navigationController pushViewController:aboutus animated:YES];
}

- (IBAction)cacha:(UIButton *)sender {
    //获取文件夹管理者
    NSFileManager *mgr =  [NSFileManager defaultManager];
    //获取cache文件夹路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //获取路径
    NSArray *allPath =   [mgr contentsOfDirectoryAtPath:cachePath  error:nil];
    for (NSString *subPath in allPath) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:subPath];
        [mgr removeItemAtPath:filePath error:nil];
    }
    _cacha.text = [self sizeStr];
    [SVProgressHUD showInfoWithStatus:@"清除缓存成功"];
}
//修改手机号码
- (IBAction)modifyTelephone:(UIButton *)sender {
    WZReadPassWordController *readVc = [[WZReadPassWordController alloc] init];
    [self.navigationController pushViewController:readVc animated:YES];
}
//修改密码
- (IBAction)modifyPassWord:(UIButton *)sender {
    WZValidateCodeController *findPassWord = [[WZValidateCodeController alloc] init];
    findPassWord.navigationItem.title = @"修改登录密码";
    findPassWord.type = @"3";
    [self.navigationController pushViewController:findPassWord animated:YES];
}


//上传名片
- (IBAction)authenAction:(UIButton *)sender {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSInteger businessCardStatus = [[user objectForKey:@"businessCardStatus"] integerValue];
    NSString *realtorStatus = [ user objectForKey:@"realtorStatus"];
    if([realtorStatus isEqual:@"2"]){
        if (businessCardStatus == 0||businessCardStatus == 3) {
            WZUpdateCardController *updateCard = [[WZUpdateCardController alloc] init];
            [self.navigationController pushViewController:updateCard animated:YES];
            
        }else if(businessCardStatus == 1){
            [SVProgressHUD showInfoWithStatus:@"审核中"];
        }
        
    }else if([realtorStatus isEqual:@"0"] ||[realtorStatus isEqual:@"3"]){
        [self store];
    }else{
        [SVProgressHUD showInfoWithStatus:@"加入门店审核中"];
        [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    }
   
    
}
-(void)store{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"未加入门店" message:@"你还没有加入经纪门店，不能进行更多操作"  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"暂不加入" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"加入门店" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               WZNewJionStoreController *JionStore = [[WZNewJionStoreController alloc] init];
                                                               WZNavigationController *nav = [[WZNavigationController alloc] initWithRootViewController:JionStore]; JionStore.jionType = @"1";
                                                               [self.navigationController presentViewController:nav animated:YES completion:nil];
                                                           }];
    [cancelAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
    [defaultAction setValue:UIColorRBG(255, 168, 0) forKey:@"_titleTextColor"];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//自定义清除缓存
-(NSInteger)getfileSize:(NSString *)DirectoryPath{
    //获取文件夹管理者
    NSFileManager *mgr =  [NSFileManager defaultManager];
    //获取文件夹下所有子路径
    NSArray *subPaths = [mgr subpathsAtPath:DirectoryPath];
    //遍历所有文件计算尺寸
    NSInteger totleSize = 0;
    for (NSString *subPath in subPaths) {
        NSString *filePath = [DirectoryPath stringByAppendingPathComponent:subPath];
        //判断是否是隐藏文件夹
        if ([filePath containsString:@".DS"]) continue;
        //判断是否是文件夹
        BOOL isDirectory;
        BOOL isExist =   [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory)continue;
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        
        NSInteger fileSize =(NSInteger)[attr fileSize];
        
        totleSize +=fileSize;
    }
    return totleSize;
}
-(NSString *)sizeStr{
    //获取cache文件夹路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *str = @"0B";
    NSInteger size = [self getfileSize:cachePath];
    if (size>1000*1000) {
        //MB
        str = [NSString stringWithFormat:@"%.1fMB",size/1000.0/1000.0];
    }else if (size>1000){
        //kb
        str = [NSString stringWithFormat:@"%.1fKB",size/1000.0];
    }else if (size>0){
        //B
        str = [NSString stringWithFormat:@"%ldB",(long)size];
    }
    return str;
}

@end
