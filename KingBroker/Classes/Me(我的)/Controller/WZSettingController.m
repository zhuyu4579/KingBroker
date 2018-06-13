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
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZfindPassWordController.h"
#import "WZReadPassWordController.h"
#import "WZAuthenticationController.h"
#import "WZAuthenSuccessController.h"
@interface WZSettingController ()
@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;
@end

@implementation WZSettingController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    _headHeight.constant = kApplicationStatusBarHeight+54;
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"设置";
    self.cacha.textColor = UIColorRBG(102, 102, 102);
    _authenStatus.textColor = UIColorRBG(102, 102, 102);
    [self.ExitLogon setTitleColor:UIColorRBG(255, 105, 110) forState:UIControlStateNormal];
    
     [_modifyPassWord setEnlargeEdgeWithTop:10 right:10 bottom:10 left:300];
     [_aboutUs setEnlargeEdgeWithTop:10 right:10 bottom:10 left:300];
     [_modifyTelephone setEnlargeEdgeWithTop:10 right:10 bottom:10 left:300];
     [_cleanCache setEnlargeEdgeWithTop:10 right:10 bottom:10 left:300];
     [_authen setEnlargeEdgeWithTop:10 right:10 bottom:10 left:300];
     _cacha.text = [self sizeStr];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger idcardStatus = [[user objectForKey:@"idcardStatus"] integerValue];
    if (idcardStatus == 0||idcardStatus == 3) {
        _authenStatus.text = @"未认证";
       
        if (idcardStatus == 3) {
            _authenStatus.text = @"认证失败";
        }
    }else if(idcardStatus == 1){
        
        _authenStatus.text = @"认证审核中";
    }else{
        _authenStatus.text = @"认证成功";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//退出登录
- (IBAction)exitLogin:(id)sender {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认注销吗？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    _okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        // 1.清除用户名、密码的存储
        
        // 2.跳转到登录界面
        [self eixtLoginData];
    }];
    _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
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
    NSString *url = [NSString stringWithFormat:@"%@/app/logout.api",URL];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            //清除持久数据
            [SVProgressHUD showInfoWithStatus:@"退出成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSDictionary *dic = [userDefaults dictionaryRepresentation];
            for (NSString *key in dic) {
                if (![key isEqual:@"oldName"] &&![key isEqual:@"appVersion"]) {
                    [userDefaults removeObjectForKey:key];
                }
            }
            [userDefaults synchronize];
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
}
//修改手机号码
- (IBAction)modifyTelephone:(UIButton *)sender {
    WZReadPassWordController *readVc = [[WZReadPassWordController alloc] init];
    [self.navigationController pushViewController:readVc animated:YES];
}
//修改密码
- (IBAction)modifyPassWord:(UIButton *)sender {
    WZfindPassWordController *findPassWord = [[WZfindPassWordController alloc] init];
    findPassWord.navigationItem.title = @"修改登录密码";
    [self.navigationController pushViewController:findPassWord animated:YES];
}


//实名认证
- (IBAction)authenAction:(UIButton *)sender {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger idcardStatus = [[user objectForKey:@"idcardStatus"] integerValue];
        if (idcardStatus == 0||idcardStatus == 3) {
            
            WZAuthenticationController *authen = [[WZAuthenticationController alloc] init];
            [self.navigationController pushViewController:authen animated:YES];
           
        }else if(idcardStatus == 2){
            WZAuthenSuccessController *authenSuccess = [[WZAuthenSuccessController alloc] init];
            [self.navigationController pushViewController:authenSuccess animated:YES];
        }
    
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
