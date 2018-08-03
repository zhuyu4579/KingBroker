//
//  WZShareVideoController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZShareVideoCell.h"
#import "WZShareDetailsItem.h"
#import "WZShareVideoController.h"
#import "NSString+LCExtension.h"
#import "WZHouseShareDetailController.h"
@interface WZShareVideoController (){
    //页数
    NSInteger current;
}
@property(nonatomic,weak)WZShareVideoCell *cell;
//数据列表
@property(nonatomic,strong)NSArray *videoItem;
//列表数据
@property(nonatomic,strong)NSMutableArray *listArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
//分享弹框
@property(nonatomic,strong) UIView *redView;
//分享按钮赏字
@property (nonatomic, strong) UIImageView *imageViewDetail;
//分享url
@property (nonatomic, strong) NSString *url;
//分享ID
@property (nonatomic, strong) NSString *ID;
@end
//查询条数
static NSString *size = @"20";
static  NSString * const ID = @"cell";
@implementation WZShareVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [self setNoData];
    _isRequestFinish = YES;
    _listArray = [NSMutableArray array];
    current = 1;
    self.view.backgroundColor = [UIColor clearColor];
    //设置分割线
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZShareVideoCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = YES;
    
    [self loadDate];
    [self headerRefresh];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewTopics) name:@"RefreshShare" object:nil];
}
//下拉刷新
-(void)headerRefresh{
    //创建下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
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
-(void)loadNewTopic{
    
    [self.tableView.mj_header beginRefreshing];
    _listArray = [NSMutableArray array];
    current = 1;
    [self loadDate];
}
-(void)loadNewTopics{
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
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 60;
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _projectId;
    paraments[@"type"] = @"2";
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/share",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSMutableDictionary *data = [responseObject valueForKey:@"data"];
            NSMutableArray *rows = [data valueForKey:@"rows"];
//            NSLog(@"%@",rows);
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
            NSMutableArray *videoItem =   [WZShareDetailsItem mj_objectArrayWithKeyValuesArray:_listArray];
            _videoItem = videoItem;
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
        _isRequestFinish = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        _isRequestFinish = YES;
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
    label.text = @"没有分享内容";
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
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZShareVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.shareButton addTarget:self action:@selector(shares:) forControlEvents:UIControlEventTouchUpInside];
    WZShareDetailsItem *item = _videoItem[indexPath.row];
    cell.item = item;
    self.cell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 282;
}
#pragma mark -跳转详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取点击cell的数据
   // WZShareVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    
}

//分享弹框
-(void)shareTasks:(NSString *)taskType{
    //弹出分享页
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT -250, self.view.fWidth, 250)];
    redView.backgroundColor = UIColorRBG(246, 246, 246);
    _redView = redView;
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(16,16,50,12);
    label.text = @"分享至：";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    label.textColor = UIColorRBG(102, 102, 102);
    [redView addSubview:label];
    //创建微信按钮
    UIButton *WXButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0-87, 67, 50, 50)];
    [WXButton setBackgroundImage:[UIImage imageNamed:@"wewhat"] forState:UIControlStateNormal];
    [WXButton addTarget:self action:@selector(WXShare) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:WXButton];
    
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.frame = CGRectMake(redView.fWidth/2.0-87,126,50,12);
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.text = @"微信好友";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [redView addSubview:labelOne];
    
    //创建悬赏标识
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+48, 45, 27, 18)];
    if ([taskType isEqual:@"1"]) {
        imageView.image = [UIImage imageNamed:@""];
    }else if([taskType isEqual:@"2"]){
        imageView.image = [UIImage imageNamed:@"label"];
    }else{
        imageView.image = [UIImage imageNamed:@"label_2"];
    }
    _imageViewDetail = imageView;
    [redView addSubview:imageView];
    //创建朋友圈按钮
    UIButton *friendsButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+37, 67, 50, 50)];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"circle-of-friend"] forState:UIControlStateNormal];
    [friendsButton addTarget:self action:@selector(WXShare) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:friendsButton];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.frame = CGRectMake(redView.fWidth/2.0+37,126,50,12);
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.text = @"朋友圈";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelTwo.textColor =  UIColorRBG(68, 68, 68);
    [redView addSubview:labelTwo];
    
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, redView.fWidth, 1)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [redView addSubview:ineView];
    //创建取消按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 201, redView.fWidth, 49)];
    [cleanButton setTitle:@"取消" forState:UIControlStateNormal];
    [cleanButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    
    [cleanButton addTarget:self action:@selector(closeGkCover) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:cleanButton];
    [GKCover translucentCoverFrom:[self.view superview].superview content:_redView animated:YES];
    
}
#pragma mark -分享
-(void)shares:(UIButton *)button{
    CGPoint point = button.center;
    point = [self.tableView convertPoint:point fromView:button.superview];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    WZShareVideoCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    NSString *type = cell.type;
    _url = cell.url;
    //删除弹框
    [_redView removeFromSuperview];
    [self shareTasks:type];
    
}
-(void)WXShare{
    [self closeGkCover];
    //下载视频到本地
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:[NSDate date]]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"video/mpeg",@"video/mp4",@"audio/mp3",nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", cachePath, fileName];
    NSURL *urlNew = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在下载视频"];
    
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       
                       [self saveVideo:fullPath];
                   }];
    [task resume];
}
//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        //保存失败
        [SVProgressHUD dismiss];
        [GKCover hide];
        [SVProgressHUD showInfoWithStatus:@"下载视频失败"];
    }else{
        //保存成功
        [SVProgressHUD dismiss];
        [GKCover hide];
        [SVProgressHUD showInfoWithStatus:@"下载视频成功"];
        //弹窗提醒
        [self shareRemind];
    }
}
//提示弹框
-(void)shareRemind{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(295, 240);
    UIView *viewTwo = [[UIView alloc] init];
    viewTwo.frame = CGRectMake(0, 57, view.fWidth, 183);
    viewTwo.backgroundColor = [UIColor whiteColor];
    viewTwo.layer.cornerRadius = 7.0;
    viewTwo.layer.masksToBounds = YES;
    [view addSubview:viewTwo];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon"];
    [imageView sizeToFit];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"需要您上传视频才能分享";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    label.textColor = UIColorRBG(51, 51, 51);
    [viewTwo addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewTwo.mas_centerX);
        make.top.equalTo(viewTwo.mas_top).offset(82);
        make.height.offset(15);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"background_2"] forState:UIControlStateNormal];
    [button setTitle:@"去分享" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [viewTwo addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left);
        make.bottom.equalTo(viewTwo.mas_bottom);
        make.height.offset(51);
        make.width.offset(viewTwo.fWidth);
    }];
    [GKCover translucentWindowCenterCoverContent:view animated:NO];
}
//关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
//分享视频
-(void)shareVideo{
    
    [self shareSuccess];
    [GKCover hide];
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
//分享回调
-(void)shareSuccess{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    paraments[@"num"] = @"";
    NSString *url = [NSString stringWithFormat:@"%@/projectTask/callback",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD valueForKey:@"网络不给力"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
