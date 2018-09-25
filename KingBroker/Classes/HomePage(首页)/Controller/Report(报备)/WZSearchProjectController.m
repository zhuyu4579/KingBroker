//
//  WZSearchProjectController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSearchProjectController.h"
#import "WZNewReportController.h"
#import "WZSelectProjectCell.h"
#import "UIView+Frame.h"
#import "WZSelcetProjectItem.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
static  NSString * const ID = @"cell";
@interface WZSearchProjectController ()<UISearchBarDelegate>{
    //页数
    NSInteger current;
}
@property (strong, nonatomic) UISearchBar *searchBar;
//楼盘列表数据
@property(nonatomic,strong)NSMutableArray *projectListArray;
//楼盘列表数据s
@property(nonatomic,strong)NSMutableArray *projectListArrays;
//搜索内容
@property(nonatomic,strong)NSString *name;
@end
//查询条数
static NSString *size = @"20";

@implementation WZSearchProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
     self.navigationItem.hidesBackButton = YES;
    //创建搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth-40, 45)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchView.fWidth, 44)];
    searchBar.placeholder = @"请输入楼盘名称";
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    _searchBar = searchBar;
    UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
    [searchField1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    searchField1.backgroundColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor blackColor];
    [searchView addSubview:searchBar];
    
    self.navigationItem.titleView = searchView;
    self.tableView.backgroundColor = UIColorRBG(242, 242, 242);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZSelectProjectCell" bundle:nil] forCellReuseIdentifier:ID];
    
     [self headerRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelector:@selector(setCorrectFocus) withObject:NULL afterDelay:0.5];
}
-(void) setCorrectFocus {
    [self.searchBar becomeFirstResponder];
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
    footer.mj_h +=JF_BOTTOM_SPACE + 20;
    self.tableView.mj_footer = footer;
    
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadData];
}
//请求数据列表
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *storeId = [ user objectForKey:@"storeId"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"storeId"] = storeId;
    paraments[@"name"] = _name;
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/projectCompany/projectList",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *dacty = [responseObject valueForKey:@"data"];
            NSMutableArray *houseDatas = [dacty valueForKey:@"rows"];
            if (houseDatas.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<houseDatas.count; i++) {
                    [_projectListArray addObject:houseDatas[i]];
                }
                current +=1;
                [self.tableView.mj_footer endRefreshing];
            }
            _projectListArrays = [WZSelcetProjectItem mj_objectArrayWithKeyValuesArray:_projectListArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
//开始输入
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for (id cencelButton in [searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    _name = searchBar.text;
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _projectListArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZSelectProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZSelcetProjectItem *item = _projectListArrays[indexPath.row];
    cell.item = item;
    return cell;
}
//选择数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZSelectProjectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
     WZSelcetProjectItem *item = _projectListArrays[indexPath.row];
    dicty[@"projectName"] = cell.projectName.text;
    dicty[@"projectId"] = cell.projectId;
    dicty[@"signStatus"]= item.signStatus;
    dicty[@"telphone"]= item.tel;
    dicty[@"orderTelFlag"] = item.orderTelFlag;
    if (_blockItem) {
        _blockItem(dicty);
    }
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WZNewReportController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}


@end
