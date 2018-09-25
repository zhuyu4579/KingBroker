//
//  WZVideoTokerController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/21.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  视频拓客
#import <Masonry.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import "WZTokerTitleItem.h"
#import "WZTokerVideoItem.h"
#import "WZTokerVideoTableView.h"
#import "WZVideoTokerController.h"
#import "WZTokerLabelCollectionView.h"
@interface WZVideoTokerController ()
//热门话题标签
@property(nonatomic,strong)UIView *titleView;
//视频列表
@property(nonatomic,strong)UIView *videoView;
//热门话题
@property(nonatomic,strong)WZTokerLabelCollectionView *tokerTitleView;
//列表
@property(nonatomic,strong)WZTokerVideoTableView *tokerVideoView;
@end

@implementation WZVideoTokerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(247, 247, 247);
    self.navigationItem.title = @"视频拓客";
    //热门话题标签
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, 108)];
    titleView.backgroundColor = [UIColor whiteColor];
    _titleView = titleView;
    [self.view addSubview:titleView];
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = @"热门话题";
    labelTitle.textColor = UIColorRBG(51, 51, 51);
    labelTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    [titleView addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset(15);
        make.top.equalTo(titleView.mas_top).offset(12);
        make.height.offset(12);
    }];
    //视频列表
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.fY+titleView.fHeight+1, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-154)];
    videoView.backgroundColor = [UIColor clearColor];
    _videoView = videoView;
    [self.view addSubview:videoView];
    [self setList];
    
    [self finsDates];
    [self loadData];
}
#pragma mark - 设置列表
-(void)setList{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.estimatedItemSize = CGSizeMake(80, 23);
    //layout.itemSize = CGSizeMake(70, 25);
    WZTokerLabelCollectionView *collectionView = [[WZTokerLabelCollectionView alloc] initWithFrame:CGRectMake(0, 25, _titleView.fWidth, _titleView.fHeight-25) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    _tokerTitleView = collectionView;
    //禁止滑动
    collectionView.scrollEnabled = NO;
    [_titleView addSubview:collectionView];
    
    WZTokerVideoTableView *tableView = [[WZTokerVideoTableView alloc] initWithFrame:CGRectMake(0,0, _videoView.fWidth, _videoView.fHeight)];
    tableView.backgroundColor = [UIColor clearColor];
    _tokerVideoView = tableView;
    [_videoView addSubview:tableView];
    
}
#pragma mark -请求数据标签
-(void)finsDates{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/hotTopic/read/list",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
         
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            
            _tokerTitleView.albumArray = [WZTokerTitleItem mj_objectArrayWithKeyValuesArray:rows];
            [_tokerTitleView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code ==-1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
    
}
#pragma mark -视频列表
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    NSString *url = [NSString stringWithFormat:@"%@/videoClassfiy/read/list",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            
            _tokerVideoView.array = [WZTokerVideoItem mj_objectArrayWithKeyValuesArray:rows];
            [_tokerVideoView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code ==-1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
