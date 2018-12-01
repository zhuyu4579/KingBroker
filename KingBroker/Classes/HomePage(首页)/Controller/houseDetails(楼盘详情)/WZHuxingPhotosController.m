//
//  WZHuxingPhotosController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/19.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <WXApi.h>
#import <Masonry.h>
#import "GKCover.h"
#import "UIView+Frame.h"
#import "WZMainUnitItem.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "WZHuxingPhotosCell.h"
#import "WZHuxingPhotosController.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZHuxingPhotosController ()<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property(nonatomic,strong)UIView *views;

@property(nonatomic,strong)UICollectionView *photoView;
//分享弹框
@property(nonatomic,strong) UIView *redView;

@property(nonatomic,assign) NSInteger indexPath;

@property(nonatomic,strong) UIPageControl  *pageControl;
@end
static NSString * const ID = @"Cell";
@implementation WZHuxingPhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.bounds;
    view.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event)];
    //将手势添加到需要相应的view中去
    [view addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    [self.view addSubview:view];
    //设置导航栏
    UIView *naView = [[UIView alloc] init];
    [view addSubview:naView];
    [naView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(view.fWidth);
        make.height.offset(kApplicationStatusBarHeight+44);
    }];
    //创建分享按钮
    UIButton *share = [[UIButton alloc] init];
    [share setBackgroundImage:[UIImage imageNamed:@"lpxq_share"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [share setEnlargeEdge:20];
    if ([_type isEqual:@"2"]) {
        [share setHidden:YES];
        [share setEnabled:NO];
    } else {
        [share setHidden:NO];
        [share setEnabled:YES];
    }
    [naView addSubview:share];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(naView.mas_right).offset(-15);
        make.top.equalTo(naView.mas_top).offset(kApplicationStatusBarHeight+13);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+44,view.fWidth, view.fHeight-kApplicationStatusBarHeight-108)];
    views.backgroundColor = [UIColor clearColor];
    _views = views;
    [view addSubview:views];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(views.fWidth, views.fHeight);
    layout.minimumLineSpacing = 0;
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView *photoView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, views.fWidth, views.fHeight) collectionViewLayout:layout];
    photoView.backgroundColor = [UIColor clearColor];
    photoView.showsHorizontalScrollIndicator = NO;//隐藏滚动条
    photoView.pagingEnabled = YES;
    photoView.delegate = self;
    photoView.dataSource = self;
    //注册cell
    [photoView  registerNib:[UINib nibWithNibName:@"WZHuxingPhotosCell" bundle:nil] forCellWithReuseIdentifier:ID];
    _photoView = photoView;
    [views addSubview:photoView];
    //标题
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top).offset(view.fHeight/2.0+140);
        make.bottom.equalTo(view.mas_bottom);
        make.width.offset(view.fWidth);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.text = _titles;
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    title.textColor = [UIColor whiteColor];
    [titleView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset(15);
        make.top.equalTo(titleView.mas_top).offset(15);
        make.height.offset(14);
    }];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _item.count;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    //添加委托方法，当点击小白点就执行此方法
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];// 设置非选中页的圆点颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor]; // 设置选中页的圆点颜色
    [titleView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
        make.bottom.equalTo(titleView.mas_bottom).offset(-20);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    [self shareTasks];
}
#pragma mark -返回
-(void)event{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *url = _item[_indexPath];
    //图片-可以直接分享
    [self WXShare:url];
    
}
#pragma mark -朋友圈分享
-(void)friendsButton{
    NSString *url = _item[_indexPath];
    [self friendsButton:url];
   
}
#pragma mark -保存至相册
-(void)downLoad{
    NSString *url = _item[_indexPath];
    //图片
    [self toSaveImage:url];
    
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
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _item.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZHuxingPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.photo.contentMode = UIViewContentModeScaleAspectFit;
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:_item[indexPath.row]] placeholderImage:[UIImage imageNamed:@"lp_pic"]];
    return cell;
}

//分页效果
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    float pageWidth = self.view.fWidth; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    else
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    targetContentOffset->x = currentOffset;
    
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    
//    NSIndexPath *indexPath = [_photoView indexPathForItemAtPoint:CGPointMake(newTargetOffset, 0)];
    _indexPath = newTargetOffset;
    // 设置页码
    _pageControl.currentPage = newTargetOffset/pageWidth;
//    NSInteger currentIndex = newTargetOffset/pageWidth +1;
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle {
   
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
@end
