//
//  WZSharePhoneCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/7/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZSharePhoneCollectionView.h"
#import "WZSharePhoneCollectionCell.h"
#import "WZVideoDailtelController.h"
#import "UIViewController+WZFindController.h"
static NSString * const ID = @"Cell";
@interface WZSharePhoneCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@end
@implementation WZSharePhoneCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.frame = frame;
    self.bounces = YES;
    [self setCollectionViewLayout:layout];
    
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZSharePhoneCollectionCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZSharePhoneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.item = _array[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSharePhoneCollectionCell *cell = (WZSharePhoneCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"id"] = cell.id;
    dicty[@"title"] = cell.title;
    dicty[@"videoUrl"] = cell.videoUrl;
    dicty[@"realname"] = cell.realname;
    dicty[@"portrait"] = cell.portrait;
    [self loadUpVideo];
    WZVideoDailtelController *videoDail = [[WZVideoDailtelController alloc] init];
    videoDail.dicty = dicty;
    UIViewController *Vc = [UIViewController viewController:self.superview.superview];
    [Vc.navigationController pushViewController:videoDail animated:YES];
}
#pragma mark -点击视频
-(void)loadUpVideo{
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
    NSString *url = [NSString stringWithFormat:@"%@/video/videoClick",HTTPURL];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
