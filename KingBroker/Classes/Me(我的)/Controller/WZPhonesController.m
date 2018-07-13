//
//  WZPhonesController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPhonesController.h"
#import <UIImageView+WebCache.h>

@interface WZPhonesController (){
    CGFloat _lastScale;
}
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
