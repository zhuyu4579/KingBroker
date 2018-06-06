//
//  WZAddCustomerController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAddCustomerController.h"
#import "WZAddCustormCell.h"
#import "WZReportController.h"
#import "UIView+Frame.h"
#import "UIBarButtonItem+Item.h"
#import "WZCustomerItem.h"
#import "UIView+WZView.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "NSString+LCExtension.h"
@interface WZAddCustomerController (){
    //页数
    NSInteger current;
}
//占位
@property(nonatomic,strong)UIView *views;
//选择的button
@property(nonatomic,strong)UIButton *buttonOld;
//选择的数据
@property(nonatomic,strong)NSMutableArray *array;
//客户列表
@property(nonatomic,strong)NSMutableArray *custormerArray;
@end

static  NSString * const ID = @"cellOne";
//查询条数
static NSString *size = @"20";

@implementation WZAddCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray array];
    [self setNarItems];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZAddCustormCell" bundle:nil] forCellReuseIdentifier:ID];
    //设置分割线
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.tableView.showsVerticalScrollIndicator = NO;
     self.tableView.showsHorizontalScrollIndicator = NO;
    _custormerArray = [NSMutableArray array];
    current = 1;
    //请求数据
    [self loadData];
    
    [self headerRefresh];
}
//下拉刷新
-(void)headerRefresh{
    //创建下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic:)];
    
    // 设置文字
    [header setTitle:@"刷新完毕..." forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.mj_h = 60;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    self.tableView.mj_header = header;
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _custormerArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadData];
}
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *userId = [ user objectForKey:@"userId"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"userId"] = userId;
    paraments[@"current"] = [NSString stringWithFormat:@"%zd",current];;
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/order/contact",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSString *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            //转换模型_
            //将数据转换成模型
            if (rows.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<rows.count; i++) {
                    [_custormerArray addObject:rows[i]];
                }
                current +=1;
                [self.tableView.mj_footer endRefreshing];
            }
            if (_custormerArray.count!=0) {
                [_views setHidden:YES];
            }else{
                [_views setHidden:NO];
            }
          _arrayData =  [WZCustomerItem mj_objectArrayWithKeyValuesArray:rows];
            
           [self.tableView reloadData];
           [self.tableView.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            [NSString isCode:self.navigationController code:code];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];

}
-(void)setNarItems{
    self.navigationItem.title = @"选择客户";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(confirmCustomer) title:@"确定"];
    //创建占位图
    UIView *view = [UIView createView:CGRectMake(0, 150, self.view.fWidth, 157) image:[UIImage imageNamed:@"vacancy"] titles:@"没有历史客户!"];
    _views = view;
    [self.view addSubview:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WZAddCustormCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZCustomerItem *item = _arrayData[indexPath.row];
    [cell.selectButton addTarget:self action:@selector(selectCustomer:) forControlEvents:UIControlEventTouchUpInside];
    cell.item = item;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
//选择客户
-(void)selectCustomer:(UIButton *)button{
    CGPoint point = button.center;
    point = [self.tableView convertPoint:point fromView:button.superview];
    NSIndexPath* indexpath = [self.tableView indexPathForRowAtPoint:point];
    WZAddCustormCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"name"] = cell.name.text;
    dicty[@"telphone"] = cell.telephone.text;
    if ([_type isEqual:@"0"]) {
        _array = [NSMutableArray array];
        [_array addObject:dicty];
        _buttonOld.selected = NO;
        button.selected = YES;
        _buttonOld = button;
        
    }else if([_type isEqual:@"1"]){
        button.selected = !button.selected;
        [_array addObject:dicty];
    }
 
}
-(void)confirmCustomer{
    if (_cusBlock) {
        _cusBlock(_array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     _array = [NSMutableArray array];
}
@end
