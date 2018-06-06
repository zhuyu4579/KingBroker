//
//  WZReportController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZReportController.h"
#import "UIBarButtonItem+Item.h"
#import "WZAddCustomerController.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "WZBatchReport.h"
#import "ViewOneReport.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "WZCustomerItem.h"
#import "NSString+LCExtension.h"

@interface WZReportController ()
//子控制器
@property (nonatomic, strong)WZBatchReport *batchReportVc;
@property (nonatomic, strong)ViewOneReport *OneReportVc;
@property (nonatomic, strong)UIViewController *currentVc;
//导航栏
@property (nonatomic, strong)UISegmentedControl *segmented;
//获取项目字典数组
@property (nonatomic, strong)NSMutableArray *itemArray;
@end

@implementation WZReportController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];

    [super viewDidLoad];

    //设置导航栏标题
    [self setNarItem];
    
}

//获取项目名数据
-(void)findItem{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        NSString *storeId = [user objectForKey:@"storeId"];
    
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 30;
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"storeId"] = storeId;
    
        NSString *url = [NSString stringWithFormat:@"%@/projectCompany/projectList",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSMutableArray *array = [[responseObject valueForKey:@"data"] valueForKey:@"rows"];
                
                //遍历
                NSMutableArray *mr = [NSMutableArray array];
                for (NSMutableDictionary *dic in array) {
                    //创建新的字典
                    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
                    dicty[@"itemId"] = [dic valueForKey:@"projectId"];
                    dicty[@"name"] =[dic valueForKey:@"projectName"];
                    [mr addObject:dicty];
                }
                _itemArray = mr;
                
                _OneReportVc.itemNameArray = _itemArray;
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                 [NSString isCode:self.navigationController code:code];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }
        }];
        
    
    
}
-(ViewOneReport *)OneReportVc{
    if (_OneReportVc == nil) {
        _OneReportVc = [[ViewOneReport alloc] init];
        _OneReportVc.view.frame = CGRectMake(0, 64, self.view.fWidth, self.view.fHeight-64);
    }
    return _OneReportVc;
}
-(WZBatchReport *)batchReportVc{
    if (_batchReportVc == nil) {
        _batchReportVc = [[WZBatchReport alloc] init];
        _batchReportVc.view.frame = CGRectMake(0, 64, self.view.fWidth, self.view.fHeight-64);
    }
    
    return _batchReportVc;
}
#pragma mark -设置导航栏
-(void)setNarItem{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"报备", @"批量报备"]];
    _segmented  = segmented;
    
    segmented.frame = CGRectMake(0, 0, 139, 30);
    
    // 设置整体的色调
   segmented.tintColor = UIColorRBG(3, 133, 219);
    
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:UIColorRBG(3, 133, 219),NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    // 设置初始选中项
    segmented.selectedSegmentIndex = 0;
    
    [segmented addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
    
    // 设置点击后恢复原样，默认为NO，点击后一直保持选中状态
    [segmented setMomentary:NO];
    self.navigationItem.titleView = segmented;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed: @"add"] highImage:[UIImage imageNamed:@"add"] target:self action:@selector(addCustomer)];
   
    [self.view addSubview:self.OneReportVc.view];
   
    if (_itemID && _itemName) {
        _OneReportVc.ItemName.text = _itemName;
        _OneReportVc.itemId = _itemID;
        if ([_types isEqual:@"1"]) {
            [_OneReportVc.titemNameButton setHidden:YES];
            _OneReportVc.titemNameButton.enabled = NO;
        }else{
            [_OneReportVc.titemNameButton setHidden:NO];
             _OneReportVc.titemNameButton.enabled = YES;
        }
        _OneReportVc.telphone = _telphone;
        _OneReportVc.sginStatu = _sginStatus;
        if (_itemID && _itemName) {
            [_OneReportVc loadTimeData];
        }
        
    }
   
}
//点击切换子控制器
-(void)selectItem:(UISegmentedControl *)segmend{
    if(segmend.selectedSegmentIndex == 0){
        [self.batchReportVc.view removeFromSuperview];
        [self.view addSubview:self.OneReportVc.view];

    }else{
        
        [self.OneReportVc.view removeFromSuperview];
        [self.view addSubview:self.batchReportVc.view];
        if (_itemID && _itemName) {
            _batchReportVc.ItemName.text = _itemName;
            _batchReportVc.itemId = _itemID;
            if ([_types isEqual:@"1"]) {
                [_batchReportVc.titemNameButton setHidden:YES];
                _batchReportVc.titemNameButton.enabled = NO;
            }else{
                [_batchReportVc.titemNameButton setHidden:NO];
                _batchReportVc.titemNameButton.enabled = YES;
            }
            _batchReportVc.sginStatu = _sginStatus;
            _batchReportVc.telphone = _telphone;
        }
        _batchReportVc.itemNameArray = _itemArray;
        
        if (_itemID && _itemName) {
            [_batchReportVc loadTimeData];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -选择客户
-(void)addCustomer{
    //跳转选择客户页面
    NSInteger type  =  _segmented.selectedSegmentIndex;
    
    WZAddCustomerController *addVC = [[WZAddCustomerController alloc] init];
    addVC.type = [NSString stringWithFormat:@"%ld",(long)type];
    addVC.cusBlock = ^(NSArray *cusArray) {
        if(type == 0){
            [_OneReportVc selectCustoms:cusArray];
        }else if(type == 1){
            [_batchReportVc selectCustorms:cusArray];
        }
    };
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
@end
