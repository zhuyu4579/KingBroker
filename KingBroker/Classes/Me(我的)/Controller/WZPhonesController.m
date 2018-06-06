//
//  WZPhonesController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPhonesController.h"
#import <UIImageView+WebCache.h>
#define MaxSCale 2.0  //最大缩放比例
#define MinScale 0.5  //最小缩放比例
@interface WZPhonesController ()
@property (nonatomic,assign) CGFloat totalScale;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation WZPhonesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    self.totalScale = 1.0;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 131, SCREEN_WIDTH, SCREEN_WIDTH);
    imageView.userInteractionEnabled = YES;
    _imageView = imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:[UIImage imageNamed:@"bb_5_pic"]];
    [view addSubview:imageView];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [imageView addGestureRecognizer:pinch];
}
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    CGFloat scale = recognizer.scale;
    
    //放大情况
    if(scale > 1.0){
        if(self.totalScale > MaxSCale) return;
    }
    
    //缩小情况
    if (scale < 1.0) {
        if (self.totalScale < MinScale) return;
    }
    
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
    self.totalScale *=scale;
    recognizer.scale = 1.0;
    
}
-(void)event{
    [self.navigationController popViewControllerAnimated:YES];
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
