//
//  WZBoardingTableController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZBoardingTableController.h"
#import "WZBoaringCell.h"
#import "UIView+Frame.h"
#import "WZBoardingDetailsController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZBoardingItem.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "GKCover.h"
#import <UIImageView+WebCache.h>
@interface WZBoardingTableController (){
    //页数
    NSInteger current;
}
@property(nonatomic,weak)WZBoaringCell *cell;

//数据列表
@property(nonatomic,strong)NSArray *boaringItem;
//订单列表数据
@property(nonatomic,strong)NSMutableArray *listArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;

@property (nonatomic,strong)UIImageView *codeImage;
@property (nonatomic,strong)UIView *codeView;
@property (nonatomic,weak)UILabel *names;
@property (nonatomic,weak)UILabel *telephones;
@property (nonatomic,weak)UILabel *ItemNames;

@property (nonatomic,weak)UILabel *titles;
@end
//查询条数
static NSString *size = @"20";

@implementation WZBoardingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [self setNoData];
    self.view.backgroundColor = [UIColor clearColor];
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = YES;
    _listArray = [NSMutableArray array];
    current = 1;
    
    [self headerRefresh];
    
    [self setCodeViews];
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
    header.mj_h = 30;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    //创建上拉加载
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}
-(void)loadMoreTopic{
    [self.tableView.mj_footer beginRefreshing];
    [self loadDate];
}
#pragma mark -请求数据
-(void)loadDate{
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [user objectForKey:@"uuid"];
        NSString *userId = [ user objectForKey:@"userId"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        mgr.requestSerializer.timeoutInterval = 30;
        //申明返回的结果是json类型
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
       [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"userId"] = userId;
        paraments[@"types"] = @"1";
        paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
        paraments[@"size"] = size;
        NSString *url = [NSString stringWithFormat:@"%@/order/list",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSMutableDictionary *data = [responseObject valueForKey:@"data"];
                NSMutableArray *rows = [data valueForKey:@"rows"];
                //将数据转换成模型
                if (rows.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                   
                }else{
                    for (int i=0; i<rows.count; i++) {
                        [_listArray addObject:rows[i]];
                    }
                    current +=1;
                    [self.tableView.mj_footer endRefreshing];
                }
                if (_listArray.count != 0) {
                    [_viewNo setHidden:YES];
                }else{
                    [_viewNo setHidden:NO];
                }
                NSMutableArray *boaringItem =   [WZBoardingItem mj_objectArrayWithKeyValuesArray:_listArray];
                _boaringItem = boaringItem;
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
//创建无图表
-(void)setNoData{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-45);
    [view setHidden:NO];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"vacancy_2"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(94);
        make.width.offset(91);
        make.height.offset(105);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有任何订单哦~\n\n赶快去创建吧～";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(29);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 119;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _boaringItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"BoadingCellOne";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    WZBoardingItem *item = _boaringItem[indexPath.row];
    WZBoaringCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WZBoaringCell" owner:self options:nil] objectAtIndex:index];
    }
    self.cell = cell;
    cell.item = item;
    [cell.buttonOne addTarget:self action:@selector(boaringButtonOne:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//创建二维码的view
-(void)setCodeViews{
    //创建一个view
    UIView *codeView = [[UIView alloc] init];
    codeView.fSize = CGSizeMake(330, 500);
    codeView.backgroundColor = [UIColor clearColor];
    _codeView = codeView;
    UIView *codeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 330, 440)];
    codeView1.backgroundColor = [UIColor whiteColor];
    [codeView addSubview:codeView1];
    UILabel *name = [[UILabel alloc] init];
    _names = name;
    name.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    name.textColor = UIColorRBG(68, 68, 68);
    [codeView1 addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(codeView1.mas_top).with.offset(16);
        make.height.mas_offset(17);
    }];
    UILabel *telephone = [[UILabel alloc] init];
    _telephones = telephone;
    telephone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    telephone.textColor = UIColorRBG(153, 153, 153);
    [codeView1 addSubview:telephone];
    [telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(name.mas_bottom).with.offset(16);
        make.height.mas_offset(12);
    }];
    UILabel *ItemName = [[UILabel alloc] init];
    _ItemNames = ItemName;
    ItemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    ItemName.textColor = UIColorRBG(68, 68, 68);
    [codeView1 addSubview:ItemName];
    [ItemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(telephone.mas_bottom).with.offset(9);
        make.height.mas_offset(13);
    }];
    UIView *codeView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 99, 290, 290)];
    codeView2.backgroundColor = UIColorRBG(3, 133, 219);
    [codeView addSubview:codeView2];
    
    UIImageView *codeImage = [[UIImageView alloc] init];
    codeImage.image = [UIImage imageNamed:@"OR-code_2"];
    [codeView2 addSubview:codeImage];
    _codeImage = codeImage;
    [codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView2.mas_left).with.offset(48);
        make.top.equalTo(codeView2.mas_top).with.offset(48);
        make.width.mas_offset(196);
        make.height.mas_offset(196);
    }];

    UILabel *Titles = [[UILabel alloc] init];
    Titles.text = @"你所在门店未和该项目签约，可能无法结佣";
    Titles.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [Titles setHidden:YES];
    _titles = Titles;
    Titles.textColor = [UIColor redColor];
    [codeView1 addSubview:Titles];
    [Titles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeView1.mas_centerX);
        make.top.equalTo(codeImage.mas_bottom).with.offset(10);
        make.height.mas_offset(13);
    }];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(156, 461, 19, 19)];
    [closeButton setEnlargeEdge:44];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"icon_shut"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:closeButton];
}
//上客弹出二维码
- (void)boaringButtonOne:(UIButton *)button {
    
    CGPoint point = button.center;
    point = [self.tableView convertPoint:point fromView:button.superview];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    WZBoaringCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    NSString *sginStatus = cell.sginStatus;
    NSString *orderCreateTime1 = cell.orderCreateTime;
    long  orderCreateTime = [orderCreateTime1 longLongValue];
    
    if ([sginStatus isEqual:@"1"]) {
        [_titles setHidden:YES];
    }else{
        [_titles setHidden:NO];
    }
    _names.text = cell.nameOne.text;
    _telephones.text = cell.telephoneOne.text;
    _ItemNames.text = cell.ItemNameOne.text;
    [_codeImage sd_setImageWithURL:[NSURL URLWithString:cell.url] placeholderImage:[UIImage imageNamed:@"bb_5_pic"]];
    if (orderCreateTime != 0 ) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970]*1000;
        long time1 = time - orderCreateTime;
        if (time1 >30*60*1000) {
            [GKCover translucentWindowCenterCoverContent:_codeView animated:YES notClick:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"订单创建时间小于30分钟"];
        }
    }
    
}
#pragma mark -关闭二维码弹窗
-(void)closeAlert{
    [GKCover hide];
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}
#pragma mark -跳转详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取点击cell的数据
    WZBoaringCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *Identifier =  cell.reuseIdentifier;
    //跳转详情页
    WZBoardingDetailsController *detailVC = [[WZBoardingDetailsController alloc] init];
    detailVC.Identifier = Identifier;
    WZBoardingItem *item = _boaringItem[indexPath.row];
    detailVC.ID = item.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

@end
