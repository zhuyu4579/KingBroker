//
//  WZHDMapController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/9/18.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZHDMapController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface WZHDMapController ()<MAMapViewDelegate>
//地图
@property(nonatomic,strong)MAMapView *mapView;
//地图点
@property(nonatomic,strong)MAPointAnnotation *pointAnnotation;

@end

@implementation WZHDMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AMapServices sharedServices].apiKey = @"3bb40a8380b1fdd9927ccac85bcd9a6d";
    [AMapServices sharedServices].enableHTTPS = YES;
    //初始化地图
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView = mapView;
//    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.zoomLevel = 16.1;
    mapView.centerCoordinate = CLLocationCoordinate2DMake( [_lnglat[1] doubleValue], [_lnglat[0] doubleValue]);
    
    [self.view addSubview:mapView];
    
    mapView.delegate = self;
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([_lnglat[1] doubleValue], [_lnglat[0] doubleValue]);
    pointAnnotation.title = _address;
    _pointAnnotation = pointAnnotation;
    
    [mapView addAnnotation:pointAnnotation];
    
    [mapView selectAnnotation:pointAnnotation animated:YES];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"lpxq_place"];

        annotationView.canShowCallout= YES;//设置气泡可以弹出，默认为NO
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


@end
