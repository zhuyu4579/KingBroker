//
//  WZAlbumsViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAlbumsViewController.h"
#import "UIView+Frame.h"
#import "WZAlbumsCollectionView.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "WZAlbumsItem.h"
@interface WZAlbumsViewController ()
@property(nonatomic,weak)UIView *nView;

@property(nonatomic,strong)WZAlbumsCollectionView *collec;

@property(nonatomic,strong)NSArray *array;
@end

@implementation WZAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavTitle];
    //创建相册view
    [self setUpAlbumsView];
    //数据的请求
    [self finsDates];
    
}

-(void)setNavTitle{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"楼盘相册";
}
//请求数据
-(void)finsDates{
    
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
        [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setMinimumDismissTimeInterval:2.0f];

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
        NSString *url = [NSString stringWithFormat:@"%@/proProjectPicture/pictureList",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"list"];
                _array = rows;
                _collec.albumArray = [WZAlbumsItem mj_objectArrayWithKeyValuesArray:rows];
                [_collec reloadData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code ==-1001) {
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }
        }];
    
}
////导航栏
//-(void)setUpNavView{
//    UIView *narView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.view.fWidth, 44)];
//    narView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:narView];
//    self.nView = narView;
//    //创建按钮
//    [self navButton:narView];
//}
-(void)navButton:(UIView *)view{
    UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, view.fHeight)];
    buttonOne.tag = 10;
    [buttonOne setTitle:@"楼盘" forState:UIControlStateNormal];
    [buttonOne setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    [buttonOne setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
    buttonOne.selected = YES;
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:14];
     [buttonOne addTarget:self action:@selector(upButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonOne];
    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(view.fWidth/2-30, 0, 60, view.fHeight)];
    buttonTwo.tag = 11;
    [buttonTwo setTitle:@"户型" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    [buttonTwo setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonTwo addTarget:self action:@selector(upButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonTwo];
    UIButton *buttonThree = [[UIButton alloc] initWithFrame:CGRectMake(view.fWidth - 100, 0, 100, view.fHeight)];
    buttonThree.tag = 12;
    [buttonThree setTitle:@"位置及周边" forState:UIControlStateNormal];
    [buttonThree setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
    [buttonThree setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
    [buttonThree addTarget:self action:@selector(upButton:) forControlEvents:UIControlEventTouchUpInside];
    buttonThree.titleLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:buttonThree];

}
//点击按钮
-(void)upButton:(UIButton *)button{
    for (UIButton *button in _nView.subviews) {
        button.selected = NO;
    }
    button.selected = YES;
    NSInteger tag = button.tag;
    NSInteger n = 0;
    switch (tag) {
        case 10:
            n = 0;
            break;
        case 11:
            n = 3;
            break;
        case 12:
            n = _array.count -1;
            break;
      
    }
    if ([_collec.isLoaded isEqual:@"1"]) {
        
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:n];
        
        UICollectionViewLayoutAttributes *attr = [self.collec.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
        UIEdgeInsets insets = self.collec.scrollIndicatorInsets;
        
        CGRect rect = attr.frame;
        rect.size = self.collec.frame.size;
        rect.size.height -= insets.top + insets.bottom;
        CGFloat offset = (rect.origin.y + rect.size.height) - self.collec.contentSize.height;
        if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
        
        [_collec scrollRectToVisible:rect animated:YES];
    }
}

//创建相册
-(void)setUpAlbumsView{
    UIView *albumsView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, self.view.fHeight - kApplicationStatusBarHeight -45)];
    albumsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:albumsView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(165, 110);
    WZAlbumsCollectionView *albumsCV = [[WZAlbumsCollectionView alloc] initWithFrame:albumsView.bounds collectionViewLayout:layout];
    albumsCV.projectId = _ID;
    _collec = albumsCV;
    [albumsView addSubview:albumsCV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
