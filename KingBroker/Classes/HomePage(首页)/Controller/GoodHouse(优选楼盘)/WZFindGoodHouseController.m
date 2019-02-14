//
//  WZFindGoodHouseController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/11/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "WZGHouseCell.h"
#import "WZFindHouseListItem.h"
#import "NSString+LCExtension.h"
#import "UIBarButtonItem+Item.h"
#import "WZHouseDatisController.h"
#import "WZFindGoodHouseController.h"
#import "WZSupportHouseDatisController.h"
@interface WZFindGoodHouseController ()<UISearchBarDelegate>{
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

@property(nonatomic,strong)UIView *viewNo;

@end
//查询条数
static NSString *size = @"20";
static  NSString * const ID = @"cells";

@implementation WZFindGoodHouseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNoData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.hidesBackButton = YES;
    //创建搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth-40, 45)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchView.fWidth, 44)];
    searchBar.placeholder = @"请输入楼盘名,公司名";
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.delegate = self;
    _searchBar = searchBar;
    searchBar.showsCancelButton = YES;
    for (id cencelButton in [searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:UIColorRBG(255, 224, 0) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
    [searchField1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    searchField1.backgroundColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor blackColor];
    [searchView addSubview:searchBar];
    
    self.navigationItem.titleView = searchView;
    self.tableView.backgroundColor = UIColorRBG(242, 242, 242);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZGHouseCell" bundle:nil] forCellReuseIdentifier:ID];
    
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
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"provinceId"] = @"";
    paraments[@"cityId"] = @"";
    paraments[@"areaId"] = @"";
    paraments[@"minPrice"] = @"";
    paraments[@"maxPrice"] = @"";
    paraments[@"type"] = @"";
    paraments[@"proSort"] = @"";
    paraments[@"lableId"] = _ID;
    paraments[@"location"] = @"";
    paraments[@"search"] = @"0";
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    paraments[@"keyword"] = _name;
    
    NSString *url = [NSString stringWithFormat:@"%@/proProject/projectListByLabelIdV2",HTTPURL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
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
            if (_projectListArray.count>0) {
                [_viewNo setHidden:YES];
            }else{
                [_viewNo setHidden:NO];
            }
            _projectListArrays = [WZFindHouseListItem mj_objectArrayWithKeyValuesArray:_projectListArray];
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
//创建无图表
-(void)setNoData{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-50);
    [view setHidden:NO];
    _viewNo = view;
    [self.view addSubview:view];
    //    UIImageView *imageView = [[UIImageView alloc] init];
    //    imageView.image = [UIImage imageNamed:@"bb_ss_k"];
    //    [view addSubview:imageView];
    //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(view.mas_centerX);
    //        make.top.equalTo(view.mas_top).offset(120);
    //        make.width.offset(181);
    //        make.height.offset(150);
    //    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"小的无能，找不到你想要的，换个关键词试试吧";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(194);
    }];
    
}
//开始输入
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _name = searchText;
    _projectListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    //[searchBar setShowsCancelButton:NO animated:YES];
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    
}
//点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 293;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectListArrays.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZGHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WZFindHouseListItem *item = [[WZFindHouseListItem alloc] init];
    item = self.projectListArrays[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZGHouseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *selfEmployed = cell.selfEmployed;
    
    if ([selfEmployed isEqual:@"2"]) {
        WZSupportHouseDatisController *houseDatis = [[WZSupportHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [self.navigationController pushViewController:houseDatis animated:YES];
    }else{
        //点击跳转详情页
        WZHouseDatisController *houseDatis = [[WZHouseDatisController alloc] init];
        houseDatis.ID =  cell.ID;
        [self.navigationController pushViewController:houseDatis animated:YES];
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
@end
