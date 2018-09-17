//
//  WZAlbumsViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import "WZAlbumsViewController.h"
#import "UIView+Frame.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "WZAlbumsItem.h"
#import "WZCollectionHeaderView.h"
#import "WZCollectionViewCell.h"
#import "WZTitleCollectionViewCell.h"
@interface WZAlbumsViewController ()<UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *colleContent;

@property(nonatomic,strong)UICollectionView *colleTitle;

@property(nonatomic,strong)NSArray *array;

@property (nonatomic,strong)NSIndexPath *oldIndexPath;

@property(nonatomic,assign)NSString *isLoaded;
@end

static NSString * const ID = @"AlCell";

static NSString * const IDT = @"TCell";

@implementation WZAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏
    [self setNavTitle];
    //创建相册view
    [self setUpAlbumsView];
    
    
}

-(void)setNavTitle{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"楼盘相册";
}
//请求数据
-(void)finsDates{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
        NSString *url = [NSString stringWithFormat:@"%@/proProjectPicture/pictureList",HTTPURL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"list"];
                _array = [WZAlbumsItem mj_objectArrayWithKeyValuesArray:rows];
                //刷新界面
                [_colleTitle reloadData];
                [_colleContent reloadData];
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
                [self.colleTitle selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code ==-1001) {
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }
        }];
    
}
//创建相册
-(void)setUpAlbumsView{
    
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    
    UIView *albumsTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+44, self.view.fWidth, 49)];
    albumsTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:albumsTitleView];
    
    UICollectionViewFlowLayout * layouts = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layouts.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layouts.itemSize = CGSizeMake(60, 39);
    layouts.minimumLineSpacing = 15;
    layouts.sectionInset = UIEdgeInsetsMake(10, 15, 0, 15);
    
    UICollectionView *titleCollects = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, albumsTitleView.fWidth, 49) collectionViewLayout:layouts];
    titleCollects.backgroundColor = [UIColor clearColor];
    titleCollects.showsHorizontalScrollIndicator = NO;//隐藏滚动条
    titleCollects.delegate = self;
    titleCollects.dataSource = self;
    //注册cell
   [titleCollects registerClass:[WZTitleCollectionViewCell class] forCellWithReuseIdentifier:IDT];
    _colleTitle = titleCollects;
    [albumsTitleView addSubview:titleCollects];
    
    //图片
    UIView *albumsView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+94, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-94)];
    albumsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:albumsView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.itemSize = CGSizeMake(165*n, 110*n);
    layout.headerReferenceSize = CGSizeMake(300, 34);
    
    UICollectionView *albumsCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, albumsView.fWidth, albumsView.fHeight) collectionViewLayout:layout];
    albumsCV.backgroundColor = [UIColor whiteColor];
    albumsCV.showsHorizontalScrollIndicator = NO;//隐藏滚动条
    albumsCV.delegate = self;
    albumsCV.dataSource = self;
    
    [albumsCV registerClass:[WZCollectionViewCell class] forCellWithReuseIdentifier:ID];
    //注册分区头标题
    [albumsCV registerClass:[WZCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WZCollectionHeaderView"];
    _colleContent = albumsCV;
    [albumsView addSubview:albumsCV];
    
    //数据的请求
    [self finsDates];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (collectionView == _colleTitle) {
        return 1;
    }
    return self.array.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _colleTitle) {
        return _array.count;
    }
    WZAlbumsItem *detilItem = _array[section];
    return detilItem.picCollect.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _colleContent) {
        WZCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        WZAlbumsItem *item = self.array[indexPath.section];
        WZAlbumContensItem *items = item.picCollect[indexPath.row];
        cell.item = items;
        
        return cell;
    }else{
        
        WZTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDT forIndexPath:indexPath];
        cell.item = _array[indexPath.row];
        
        if (indexPath.row == 0) {
            _oldIndexPath = indexPath;
        }
       
        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    { // header
        reuseIdentifier = @"WZCollectionHeaderView";
        WZCollectionHeaderView *view = (WZCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                          withReuseIdentifier:reuseIdentifier
                                                                                 forIndexPath:indexPath];
        WZAlbumsItem *model = self.array[indexPath.section];
        view.headerTitle.text = model.picColectName;
        reusableView = view;
    }
   
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击标题栏上的标题 实现切换效果
    if (collectionView == self.colleTitle) {
        WZAlbumsItem *item = _array[indexPath.row];
        
        WZTitleCollectionViewCell *cell1 = (WZTitleCollectionViewCell *) [collectionView cellForItemAtIndexPath:_oldIndexPath];
        cell1.ineView.backgroundColor = [UIColor whiteColor];
        cell1.title.textColor = UIColorRBG(119, 119, 119);
        
        WZTitleCollectionViewCell *cell = (WZTitleCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        cell.ineView.backgroundColor = UIColorRBG(255, 224, 0);
        cell.title.textColor = UIColorRBG(255, 224, 0);
        _oldIndexPath = indexPath;
        if (item.picCollect.count>0) {
            //滑动被点击的标题 至中心 并设置状态为选中
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            //同时 根据点击的标题的indexPath.row 确定滑动至显示栏对应的section
            NSIndexPath *viewIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
            [_colleContent scrollToItemAtIndexPath:viewIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!(scrollView.isTracking || scrollView.isDecelerating) || ![scrollView isEqual:self.colleContent]) {
        //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
        return;
    }
    
    //用户滚动的才处理
    //获取categoryView下面一点的所有布局信息，用于知道，当前最上方是显示的哪个section
    CGRect topRect = CGRectMake(0, scrollView.contentOffset.y, self.view.fWidth, 1);
    UICollectionViewLayoutAttributes *topAttributes = [_colleContent.collectionViewLayout layoutAttributesForElementsInRect:topRect].firstObject;
    NSUInteger topSection = topAttributes.indexPath.section;
    if (topAttributes != nil) {
        if (_oldIndexPath.row != topSection - 1) {
            //不相同才切换
            if (scrollView.contentOffset.y<=0) {
                topSection = 0;
            }
            [self.colleTitle selectItemAtIndexPath:[NSIndexPath indexPathForItem:topSection inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            WZTitleCollectionViewCell *cell1 = (WZTitleCollectionViewCell *) [_colleTitle cellForItemAtIndexPath:_oldIndexPath];
            cell1.ineView.backgroundColor = [UIColor whiteColor];
            cell1.title.textColor = UIColorRBG(119, 119, 119);

            WZTitleCollectionViewCell *cell = (WZTitleCollectionViewCell *) [_colleTitle cellForItemAtIndexPath:[NSIndexPath indexPathForItem:topSection inSection:0] ];
            cell.ineView.backgroundColor = UIColorRBG(255, 224, 0);
            cell.title.textColor = UIColorRBG(255, 224, 0);
            _oldIndexPath = [NSIndexPath indexPathForItem:topSection  inSection:0];

        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
