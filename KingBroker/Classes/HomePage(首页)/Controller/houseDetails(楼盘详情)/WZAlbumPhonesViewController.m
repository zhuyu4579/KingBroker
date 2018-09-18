//
//  WZAlbumPhonesViewController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/7.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  相片浏览
#import <WXApi.h>
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZAlbumsItem.h"
#import "WZPhotoNameCell.h"
#import "WZPhotoTypeNameView.h"
#import "UIBarButtonItem+Item.h"
#import "WZAlbumsViewController.h"
#import "WZAllPhotosCollectionView.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "WZAlbumPhonesViewController.h"


@interface WZAlbumPhonesViewController (){
    CGFloat _lastScale;
}
@property(nonatomic,strong)WZAllPhotosCollectionView *photosCV;
@property(nonatomic,strong)WZPhotoTypeNameView *photosName;
@property(nonatomic,strong)UILabel *page;
@property(nonatomic,strong)NSString *num;

@property(nonatomic,strong)NSIndexPath *oldIndexPath;
//当前页面
@property(nonatomic,strong)NSIndexPath *IndexPath;

@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)UIView *views;
@property (nonatomic,assign) CGFloat totalScale;
//分享弹框
@property(nonatomic,strong) UIView *redView;
//下载视频类型
@property(nonatomic,strong) NSString *downLoadType;
@end

@implementation WZAlbumPhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //创建导航
    [self setNav];
    //设置图片显示区域
    [self showView];
    
    [self finsDates];
    
    [self shareTasks];
}
//请求数据
-(void)finsDates{
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    self.totalScale = 1.0;
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _projectId;
    NSString *url = [NSString stringWithFormat:@"%@/proProjectPicture/pictureList",HTTPURL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"list"];
            
            NSString *num = [data valueForKey:@"num"];
            _num = num;
            _page.text = [NSString stringWithFormat:@"1/%@",num];
            
             NSArray *array = [WZAlbumsItem mj_objectArrayWithKeyValuesArray:rows];
             _list = array;
                _photosCV.array = array;
                _photosName.arrays = array;
                //[UIView setAnimationsEnabled:NO];
                [UIView performWithoutAnimation:^{
                    //刷新界面
                    [_photosCV reloadData];
                    [_photosName reloadData];
                    //[_photosName reloadSections:[NSIndexSet indexSetWithIndex:0]];
                }];
                [self selectPhoto];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code ==-1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
    
}

//设置导航
-(void)setNav{
    UIView *nav = [[UIView alloc] init];
    nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight);
        make.width.offset(self.view.fWidth);
        make.height.offset(44);
    }];
    //创建返回按钮
    UIButton *black = [[UIButton alloc] init];
    [black setImage:[UIImage imageNamed:@"more_unfold1"] forState:UIControlStateNormal];
    [black addTarget:self action:@selector(black) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:black];
    [black mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nav.mas_left);
        make.top.equalTo(nav.mas_top);
        make.width.offset(50);
        make.height.offset(44);
    }];
    //创建页数
    UILabel *page = [[UILabel alloc] init];
    page.textColor = [UIColor whiteColor];
    page.font = [UIFont systemFontOfSize:16];
    _page = page;
    [nav addSubview:page];
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nav.mas_centerX);
        make.centerY.equalTo(nav.mas_centerY);
        make.height.offset(16);
    }];
  
    //创建相册按钮
    UIButton *albums = [[UIButton alloc] init];
    [albums setTitle:@"相册" forState:UIControlStateNormal];
    [albums setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    albums.titleLabel.font = [UIFont systemFontOfSize:15];
    [albums addTarget:self action:@selector(allPhotos) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:albums];
    [albums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nav.mas_right);
        make.top.equalTo(nav.mas_top);
        make.width.offset(65);
        make.height.offset(44);
    }];
    //创建分享按钮
    UIButton *share = [[UIButton alloc] init];
    [share setBackgroundImage:[UIImage imageNamed:@"lpxq_share"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [share setEnlargeEdgeWithTop:10 right:0 bottom:10 left:10];
    [nav addSubview:share];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(albums.mas_left);
        make.top.equalTo(nav.mas_top).offset(13);
        make.width.offset(20);
        make.height.offset(20);
    }];
}
#pragma mark - 加载控件
-(void)showView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.fHeight - 280)/2.0, self.view.fWidth, 340)];
    view.backgroundColor = [UIColor clearColor];
    _views = view;
    [self.view addSubview:view];
   
    //创建一个layout布局类
    UICollectionViewFlowLayout *layouts = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layouts.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layouts.itemSize = CGSizeMake(view.fWidth, view.fHeight);
    layouts.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layouts.minimumLineSpacing = 0;
    WZAllPhotosCollectionView *allPhotos= [[WZAllPhotosCollectionView alloc]initWithFrame:CGRectMake(0, 0,view.fWidth, view.fHeight) collectionViewLayout:layouts];
    _photosCV = allPhotos;
    [view addSubview:allPhotos];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    [allPhotos addGestureRecognizer:pinch];
    
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"indexPath" object:nil];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fHeight-50-JF_BOTTOM_SPACE, self.view.fWidth, 50+JF_BOTTOM_SPACE)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    //创建一个layout布局类
    UICollectionViewFlowLayout *layoutN = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layoutN.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layoutN.estimatedItemSize = CGSizeMake(65, 50);
    layoutN.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layoutN.minimumLineSpacing = 10;
    WZPhotoTypeNameView *photoName= [[WZPhotoTypeNameView alloc]initWithFrame:CGRectMake(0, 0,buttonView.fWidth, buttonView.fHeight) collectionViewLayout:layoutN];
    _photosName = photoName;
    [buttonView addSubview:photoName];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changes:) name:@"indexPaths" object:nil];
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    UIGestureRecognizerState state = [recognizer state];
    
    if(state == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        //获取最后的比例
        _lastScale = [recognizer scale];
    }
    
    if (state == UIGestureRecognizerStateBegan ||
        state == UIGestureRecognizerStateChanged) {
        //获取当前的比例
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        //设置最大最小的比例
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 1.0;
        //设置
        
        //获取上次比例减去想去得到的比例
        CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        [recognizer view].transform = transform;
        // Store the previous scale factor for the next pinch gesture call
        //获取最后比例 下次再用
        _lastScale = [recognizer scale];
    }
    
}


//默认选择的照片
-(void)selectPhoto{
    int n = 0;
    int m = 0;
    for (int i = 0; i<_list.count; i++) {
        NSArray *picCollect = [_list[i] valueForKey:@"picCollect"];
        for (int j = 0; j<picCollect.count; j++) {
            NSString *ID = [picCollect[j] valueForKey:@"id"];
            if ([_photoId isEqual:ID]) {
                n = i;
                m = j;
                break;
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:m inSection:n];
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
    
    [_photosCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    UICollectionViewLayoutAttributes *attr = [self.photosCV.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    CGRect rect = attr.frame;
    rect.size = self.photosCV.frame.size;
    NSInteger page = rect.origin.x/self.view.fWidth +1;
    _page.text = [NSString stringWithFormat:@"%ld/%@",(long)page,_num];
    
    _oldIndexPath = indexPath1;
    _photosName.oldIndexPath = _oldIndexPath;
    _photosName.selectIndexPath = _oldIndexPath;
    
    [_photosName scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    WZPhotoNameCell *cell =(WZPhotoNameCell *) [_photosName cellForItemAtIndexPath:indexPath1];
    cell.name.textColor = UIColorRBG(49, 35, 6);
    cell.name.backgroundColor = UIColorRBG(255, 224, 0);
    _IndexPath = indexPath;
}
//1接收通知
-(void)change:(NSNotification *)notFi{
    NSDictionary *dicty = [notFi userInfo];
    _page.text = [NSString stringWithFormat:@"%@/%@",[dicty valueForKey:@"index"],_num];
    NSIndexPath *indexPath = [dicty valueForKey:@"indexPath"];
    _IndexPath = indexPath;
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
    [_photosName scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    WZPhotoNameCell *cell1 =(WZPhotoNameCell *) [_photosName cellForItemAtIndexPath:_oldIndexPath];
    cell1.name.textColor = UIColorRBG(203, 203, 203);
    cell1.name.backgroundColor = [UIColor clearColor];
    
    WZPhotoNameCell *cell =(WZPhotoNameCell *) [_photosName cellForItemAtIndexPath:indexPath1];
    cell.name.textColor = UIColorRBG(49, 35, 6);
    cell.name.backgroundColor = UIColorRBG(255, 224, 0);
    _oldIndexPath = indexPath1;
    _photosName.oldIndexPath = _oldIndexPath;
    
}
//2接收通知
-(void)changes:(NSNotification *)notFi{
    
    NSDictionary *dicty = [notFi userInfo];
    NSIndexPath *indexPath = [dicty valueForKey:@"indexPath"];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
    _IndexPath = indexPath1;
    [_photosCV scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    UICollectionViewLayoutAttributes *attr = [self.photosCV.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath1];
    
    CGRect rect = attr.frame;
    rect.size = self.photosCV.frame.size;
    NSInteger page = rect.origin.x/self.view.fWidth +1;
    _page.text = [NSString stringWithFormat:@"%ld/%@",(long)page,_num];
    _oldIndexPath = indexPath;
    
}
-(void)black{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)allPhotos{
    if ([_type isEqual:@"0"]) {
        WZAlbumsViewController *albums =[[WZAlbumsViewController alloc] init];
        albums.ID = _projectId;
        [self.navigationController pushViewController:albums animated:YES];
    }else if([_type isEqual:@"1"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
#pragma mark - 分享
-(void)share{
    [GKCover translucentCoverFrom:self.view content:_redView animated:YES];
}
#pragma mark - 分享弹框
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
    //创建朋友圈按钮
    UIButton *friendsButton = [[UIButton alloc] init];
    [friendsButton setBackgroundImage:[UIImage imageNamed:@"circle-of-friend"] forState:UIControlStateNormal];
    [friendsButton addTarget:self action:@selector(friendsButton) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:friendsButton];
    [friendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redView.mas_centerX);
        make.top.equalTo(redView.mas_top).offset(68);
        make.width.offset(50);
        make.height.offset(50);
    }];
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.textAlignment = NSTextAlignmentCenter;
    labelTwo.text = @"朋友圈";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelTwo.textColor =  UIColorRBG(68, 68, 68);
    [redView addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redView.mas_centerX);
        make.top.equalTo(friendsButton.mas_bottom).offset(9);
        make.height.offset(12);
    }];
    //创建微信按钮
    UIButton *WXButton = [[UIButton alloc] init];
    [WXButton setBackgroundImage:[UIImage imageNamed:@"wewhat"] forState:UIControlStateNormal];
    [WXButton addTarget:self action:@selector(WXShare) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:WXButton];
    [WXButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(friendsButton.mas_left).offset(-54);
        make.top.equalTo(redView.mas_top).offset(68);
        make.width.offset(50);
        make.height.offset(50);
    }];
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.textAlignment = NSTextAlignmentCenter;
    labelOne.text = @"微信好友";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [redView addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(WXButton.mas_centerX);
        make.top.equalTo(WXButton.mas_bottom).offset(9);
        make.height.offset(12);
    }];
    //创建下载按钮
    UIButton *downLoadButton = [[UIButton alloc] init];
    [downLoadButton setBackgroundImage:[UIImage imageNamed:@"XC_BUTTON2"] forState:UIControlStateNormal];
    [downLoadButton addTarget:self action:@selector(downLoad) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:downLoadButton];
    [downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendsButton.mas_right).offset(54);
        make.top.equalTo(redView.mas_top).offset(68);
        make.width.offset(50);
        make.height.offset(50);
    }];
    UILabel *labelThree = [[UILabel alloc] init];
    labelThree.textAlignment = NSTextAlignmentCenter;
    labelThree.text = @"保存至相册";
    labelThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelThree.textColor = UIColorRBG(68, 68, 68);
    [redView addSubview:labelThree];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(downLoadButton.mas_centerX);
        make.top.equalTo(downLoadButton.mas_bottom).offset(9);
        make.height.offset(12);
    }];
    
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
#pragma mark -关闭分享
-(void)closeGkCover{
    [GKCover hide];
}
#pragma mark -微信分享
-(void)WXShare{
    WZAlbumsItem *item = _list[_IndexPath.section];
    WZAlbumContensItem *items = item.picCollect[_IndexPath.row];
    NSString *type = items.type;
    NSString *url = items.url;
    NSString *videoPictureUrl = items.videoPictureUrl;
    if ([type isEqual:@"1"]) {
        //图片-可以直接分享
        [self WXShare:url];
    }else{
        //视频需要弹出提示框下载分享
        _downLoadType = @"1";
        [self downloadVideo:videoPictureUrl];
    }
}
#pragma mark -朋友圈分享
-(void)friendsButton{
    WZAlbumsItem *item = _list[_IndexPath.section];
    WZAlbumContensItem *items = item.picCollect[_IndexPath.row];
    NSString *type = items.type;
    NSString *url = items.url;
    NSString *videoPictureUrl = items.videoPictureUrl;
    if ([type isEqual:@"1"]) {
        //图片-可以直接分享
        [self friendsButton:url];
    }else{
        //视频需要弹出提示框下载分享
        _downLoadType = @"1";
        [self downloadVideo:videoPictureUrl];
    }
}
#pragma mark -保存至相册
-(void)downLoad{
    WZAlbumsItem *item = _list[_IndexPath.section];
    WZAlbumContensItem *items = item.picCollect[_IndexPath.row];
    NSString *type = items.type;
    NSString *url = items.url;
    NSString *videoPictureUrl = items.videoPictureUrl;
    if ([type isEqual:@"1"]) {
        //图片
        [self toSaveImage:url];
    }else{
        //视频
        _downLoadType = @"2";
        [self downloadVideo:videoPictureUrl];
    }
}
//分享到微信
-(void)WXShare:(NSString *)url{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    //2.创建多媒体消息中包含的图片数据对象
    WXImageObject *imgObj = [WXImageObject object];
    //图片真实数据
    imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //多媒体数据对象
    mediaMsg.mediaObject = imgObj;
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
-(void)friendsButton:(NSString *)url{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"shareSuccessType"];
    [defaults synchronize];
    //1.创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    
    //2.创建多媒体消息中包含的图片数据对象
    WXImageObject *imgObj = [WXImageObject object];
    //图片真实数据
    imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //多媒体数据对象
    mediaMsg.mediaObject = imgObj;
    //3.创建发送消息至微信终端程序的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    //多媒体消息的内容
    req.message = mediaMsg;
    //指定为发送多媒体消息（不能同时发送文本和多媒体消息，两者只能选其一）
    req.bText = NO;
    //指定发送到会话(朋友圈界面)
    req.scene = WXSceneTimeline;
    //发送请求到微信,等待微信返回onResp
    [WXApi sendReq:req];
    [self closeGkCover];
    
}
//保存图片到相册
- (void)toSaveImage:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
 
    //从网络下载图片
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    // 保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    
    if (error != NULL)
    {
        [SVProgressHUD showInfoWithStatus:@"保存图片失败"];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"保存图片成功"];
        [self closeGkCover];
    }
}

//下载视频
-(void)downloadVideo:(NSString *)url{
    //下载视频到本地
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:[NSDate date]]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"video/mpeg",@"video/mp4",@"audio/mp3",nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", cachePath, fileName];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"正在下载视频到本地"];
    
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
        [SVProgressHUD showInfoWithStatus:@"保存视频失败"];
    }else{
        //保存成功
        [SVProgressHUD dismiss];
        [GKCover hide];
        [SVProgressHUD showInfoWithStatus:@"保存视频成功"];
        //弹窗提醒
        if ([_downLoadType isEqual:@"1"]) {
           [self shareRemind];
        }
        
    }
}
#pragma mark -提示弹框
-(void)shareRemind{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(243, 244);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"XC_PIC"];
    [imageView sizeToFit];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(view.fWidth);
        make.height.offset(view.fHeight);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"需要您上传视频才能分享";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    label.textColor = UIColorRBG(51, 51, 51);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(147);
        make.height.offset(15);
    }];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"xc_shareButton"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 18;
    button.layer.masksToBounds = YES;
    [button setTitle:@"去分享" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [button setTitleColor:UIColorRBG(49, 35, 6) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareVideo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-18);
        make.height.offset(36);
        make.width.offset(145);
    }];
    [GKCover translucentWindowCenterCoverContent:view animated:NO];
}
//分享视频
-(void)shareVideo{
    [GKCover hide];
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


@end
