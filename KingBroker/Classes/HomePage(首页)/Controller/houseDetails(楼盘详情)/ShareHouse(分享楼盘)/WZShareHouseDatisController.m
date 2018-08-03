//
//  WZShareHouseDatisController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <WXApi.h>
#import <WXApiObject.h>
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "WZShareDetailCell.h"
#import "WZShareDetailsItem.h"
#import "NSString+LCExtension.h"
#import "WZShareHouseDatisController.h"

@interface WZShareHouseDatisController (){
    //页数
    NSInteger current;
}
@property(nonatomic,weak)WZShareDetailCell *cell;
//数据列表
@property(nonatomic,strong)NSArray *detailItem;
//列表数据
@property(nonatomic,strong)NSMutableArray *listArray;
//无数据页面
@property(nonatomic,strong)UIView *viewNo;
//分享弹框
@property(nonatomic,strong) UIView *redView;
//分享内容
@property(nonatomic,strong)NSDictionary *detailShareContents;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
@end
//查询条数
static NSString *size = @"20";
static  NSString * const ID = @"cell";

@implementation WZShareHouseDatisController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [self setNoData];
    self.view.backgroundColor = [UIColor clearColor];
    //设置分割线
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WZShareDetailCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = YES;
    _listArray = [NSMutableArray array];
    current = 1;
    _isRequestFinish = YES;
    [self loadDate];
    [self headerRefresh];
    [self shareTasks];
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
    paraments[@"type"] = @"3";
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    NSString *url = [NSString stringWithFormat:@"%@/proProject/share",HTTPURL];
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
            NSMutableArray *videoItem =   [WZShareDetailsItem mj_objectArrayWithKeyValuesArray:_listArray];
            _detailItem = videoItem;
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
    return _detailItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZShareDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.shareDetail addTarget:self action:@selector(shareTaskDetail) forControlEvents:UIControlEventTouchUpInside];
    WZShareDetailsItem *item = _detailItem[indexPath.row];
    _detailShareContents = _listArray[indexPath.row];
    cell.item = item;
    self.cell = cell;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _detailShareContents = _listArray[indexPath.row];
    [GKCover translucentCoverFrom:[self.view superview].superview content:_redView animated:YES];
    //[GKCover translucentWindowCenterCoverContent:_redView animated:YES];
}
-(void)shareTaskDetail{
    [GKCover translucentCoverFrom:[self.view superview].superview content:_redView animated:YES];
}
//分享弹框
-(void)shareTasks{
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
    
    
    //创建朋友圈按钮
    UIButton *friendsButton = [[UIButton alloc] initWithFrame:CGRectMake(redView.fWidth/2.0+37, 67, 50, 50)];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"circle-of-friend"] forState:UIControlStateNormal];
    [friendsButton addTarget:self action:@selector(friendsButton) forControlEvents:UIControlEventTouchUpInside];
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
    
}
//分享到微信
-(void)WXShare{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    mediaMsg.title = [_detailShareContents valueForKey:@"name"];
    mediaMsg.description = [_detailShareContents valueForKey:@"outlining"];
     UIImage *image =  [self handleImageWithURLStr:[_detailShareContents valueForKey:@"url"]];
    [mediaMsg setThumbImage:image];
    //分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [_detailShareContents valueForKey:@"shareUrl"];
    mediaMsg.mediaObject = webpageObject;
    
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    req.scene = WXSceneSession;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    
    [self closeGkCover];
   
}
//分享到朋友圈
-(void)friendsButton{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    
    mediaMsg.title = [_detailShareContents valueForKey:@"name"];
    mediaMsg.description = [_detailShareContents valueForKey:@"outlining"];
    
    UIImage *image =  [self handleImageWithURLStr:[_detailShareContents valueForKey:@"url"]];
    [mediaMsg setThumbImage:image];
    
    //2.分享网站
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = [_detailShareContents valueForKey:@"shareUrl"];
    mediaMsg.mediaObject = webpageObject;
    
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(聊天界面)
    req.scene = WXSceneTimeline;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    [self closeGkCover];
  
}
//关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,(NSInteger)newSize.width, (NSInteger)newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
