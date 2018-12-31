//
//  WZCyclePhotoView.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/3/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <UIImageView+WebCache.h>
#import "WZCyclePhotoView.h"
#import "UIView+Frame.h"
#define CC_CYCLEINDEX_CALCULATE(x,y) (x+y)%y  //计算循环索引
#define CC_DEFAULT_DURATION_TIME 5.0f         //默认持续时间
#define CC_DEFAULT_DURATION_FRAME CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,190)

BOOL flag = true;

@interface WZCyclePhotoView()<UIScrollViewDelegate>
@property (nonatomic, readwrite, strong)UIImageView * leftImageView;
@property (nonatomic, readwrite, strong)UIImageView * middleImageView;
@property (nonatomic, readwrite, strong)UIImageView * rightImageView;
@property (nonatomic, readwrite, strong)UIScrollView * containerView;

@property NSInteger currentNumber;
@end

@implementation WZCyclePhotoView

/**
初始化方法
@param frame    轮播图的frame
@param images   展示的图片的数组，支持image、string
@param imageKey 如果数组中是一个字典，则取图的key，如果不是字典，则传nil
@return 初始化
*/
#pragma mark - init function
- (instancetype)initWithImages:(NSArray *)images
{
return [self initWithImages:images withFrame:CC_DEFAULT_DURATION_FRAME];
}
- (instancetype)initWithImages:(NSArray *)images flag:(BOOL)flags
{
    flag = flags;
    return [self initWithImages:images withFrame:CC_DEFAULT_DURATION_FRAME];
}

- (instancetype)initWithImages:(NSArray *)images withFrame:(CGRect)frame
{
return [self initWithImages:images withPageViewLocation:CCCycleScrollPageViewPositionBottomCenter withPageChangeTime:CC_DEFAULT_DURATION_TIME withFrame:frame];
}

- (instancetype)initWithImages:(NSArray *)images withPageViewLocation:(CCCycleScrollPageViewPosition)pageLocation withPageChangeTime:(NSTimeInterval)changeTime withFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _images = [[NSArray alloc]initWithArray:images];
        _pageLocation = pageLocation;
        _pageChangeTime = changeTime;
        _currentNumber = 0;
        
        [self cycleViewConfig];
        //配置pageControl 初始化等
        if (flag) {
            [self pageControlCongfig];
            //初始化图片描述
            [self pageImageDescriLabelConfig];
        }
        //设置三个imageview的初始image，如果没有设置image 则直接跳过
        [self cycleImageViewConfig];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPageAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark -init configure
- (void)cycleViewConfig
{
    //self.frame = frame;
    //设置三个imageview的位置
    //初始化容器ScrollView和三个imageview
    _containerView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _containerView.contentSize = CGSizeMake(3*_containerView.frame.size.width, _containerView.frame.size.height);
    _containerView.contentOffset = CGPointMake(_containerView.frame.size.width, _containerView.frame.origin.y)//显示中间图片
    ;
    _containerView.backgroundColor = [UIColor whiteColor];
    self.leftImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(-9, 0 , _containerView.frame.size.width-9, _containerView.frame.size.height)];
    self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_containerView.frame.size.width-9, 0  , _containerView.frame.size.width-9, _containerView.frame.size.height)];
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*_containerView.frame.size.width-9, 0, _containerView.frame.size.width-9, _containerView.frame.size.height)];
    
    _containerView.delegate = self;
    [_containerView addSubview:_leftImageView];
    [_containerView addSubview:_rightImageView];
    [_containerView addSubview:_middleImageView];
    _containerView.scrollEnabled = YES;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.pagingEnabled = YES;
    
    [self addSubview:_containerView];
}

- (void)pageControlCongfig
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.currentPageIndicatorTintColor = UIColorRBG(255, 224, 0);
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPage = 0;
    [self pageControlPosition:_pageLocation];
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = _images.count;
}
- (void)pageImageDescriLabelConfig
{
    _pageDescripLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_pageControl.frame.origin.y -10, self.frame.size.width, 40)];
    [_pageDescripLabel setTextAlignment:NSTextAlignmentRight];
    _pageDescripLabel.backgroundColor = [UIColor clearColor];
    _pageDescripLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:_pageDescripLabel];
}

- (void)cycleImageViewConfig
{
    if ([_images count] == 0) {
        
        return;
    }
    
//    _middleImageView.image = (UIImage *)_images[CC_CYCLEINDEX_CALCULATE(_currentNumber,_images.count)];
    NSDictionary *date1 = _images[CC_CYCLEINDEX_CALCULATE(_currentNumber,_images.count)];
    NSString *url = [date1 valueForKey:@"pictureIds"];
    [_middleImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
//    _leftImageView.image = (UIImage *)_images[CC_CYCLEINDEX_CALCULATE(_currentNumber - 1,_images.count)];
    NSDictionary *date2 = _images[CC_CYCLEINDEX_CALCULATE(_currentNumber - 1,_images.count)];
    NSString *url2 = [date2 valueForKey:@"pictureIds"];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:url2]];
    
//    _rightImageView.image = (UIImage *)_images[CC_CYCLEINDEX_CALCULATE(_currentNumber + 1,_images.count)];
    NSDictionary *date3 = _images[CC_CYCLEINDEX_CALCULATE(_currentNumber + 1,_images.count)];
    NSString *url3 = [date3 valueForKey:@"pictureIds"];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:url3]];
    if (flag) {
        [self timeSetter];
    }
  
}

- (void)clickPageAction
{
    if ([self.delegate respondsToSelector:@selector(cyclePageClickAction:)]) {
        [self.delegate cyclePageClickAction:_images[_currentNumber]];
    }else {
        
    }
}

#pragma mark - timer configure
//设置定时器
- (void)timeSetter
{
    //将定时器放入当前RUNLOOP中，可能会导致定时器的失效
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pageChangeTime target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    
    //将定时器放入主进程的RunLoop中
    self.timer = [NSTimer timerWithTimeInterval:self.pageChangeTime target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)timeChanged
{
    if (_images.count == 0) {
        
        return;
    }
    self.currentNumber =  CC_CYCLEINDEX_CALCULATE(_currentNumber+1,_images.count);
    self.pageControl.currentPage = self.currentNumber;
    [self setPageDescripText];
    [self pageChangeAnimationType:1];
    [self changeImageViewWith:self.currentNumber];
    self.containerView.contentOffset = CGPointMake(_containerView.frame.origin.x, _containerView.frame.origin.y);
}

#pragma mark - ScrollView  Delegate
//当用户手动个轮播时 关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (flag) {
      [self.timer invalidate];
    }
   
}

//当用户手指停止滑动图片时 启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (flag) {
       [self timeSetter];
    }
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = [self.containerView contentOffset];
    if (offset.x == 2*_containerView.frame.size.width) {
        self.currentNumber = CC_CYCLEINDEX_CALCULATE(_currentNumber  + 1,_images.count);
    } else if (offset.x == 0){
        self.currentNumber = CC_CYCLEINDEX_CALCULATE(_currentNumber  - 1,_images.count);
    }else{
        return;
    }
    
    self.pageControl.currentPage = self.currentNumber;
    [self changeImageViewWith:self.currentNumber];
    [self setPageDescripText];
    self.containerView.contentOffset = CGPointMake(_containerView.frame.size.width, _containerView.frame.origin.y);
    
}

#pragma mark - judge the pageControl's position
/**
 *  确定pageControl的位置，可以自定义设置
 *
 *  @param position 有三个位置：下左，下中，下右
 */
- (void)pageControlPosition:(CCCycleScrollPageViewPosition)position
{
    
    if (position == CCCycleScrollPageViewPositionBottomCenter) {
        _pageControl.frame = CGRectMake(self.center.x - 75, self.frame.size.height -30, 100, 30);
    }else if (position == CCCycleScrollPageViewPositionBottomLeft)
    {
        _pageControl.frame = CGRectMake(35, self.frame.size.height -30, 100, 30);
        
    }else if (position == CCCycleScrollPageViewPositionBottomRight)
    {
        _pageControl.frame = CGRectMake(self.frame.size.width - 100-35, self.frame.size.height -30, 100, 30);
    }
    
}

#pragma mark - iamgeView cycle changed
/**
 *  改变轮播的图片
 *
 *  @param imageNumber 设置当前，前，后的图片
 */
- (void)changeImageViewWith:(NSInteger)imageNumber
{
//    self.middleImageView.image = self.images[CC_CYCLEINDEX_CALCULATE(imageNumber,self.images.count)];
    
    NSDictionary *date1 = self.images[CC_CYCLEINDEX_CALCULATE(imageNumber,self.images.count)];
    NSString *url = [date1 valueForKey:@"pictureIds"];
    [_middleImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
//    self.leftImageView.image = self.images[CC_CYCLEINDEX_CALCULATE(imageNumber - 1,self.images.count)];
    NSDictionary *date2 = self.images[CC_CYCLEINDEX_CALCULATE(imageNumber - 1,self.images.count)];
    NSString *url2 = [date2 valueForKey:@"pictureIds"];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:url2]];
    
//    self.rightImageView.image = self.images[CC_CYCLEINDEX_CALCULATE(imageNumber + 1,self.images.count)];
    NSDictionary *date3 = self.images[CC_CYCLEINDEX_CALCULATE(imageNumber + 1,self.images.count)];
    NSString *url3 = [date3 valueForKey:@"pictureIds"];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:url3]];
}


#pragma mark - property setter
- (void)setPageLocation:(CCCycleScrollPageViewPosition)pageLocation
{
    [self pageControlPosition:pageLocation];
}

- (void)setPageDescrips:(NSArray *)pageDescrips
{
    _pageDescrips = [[NSArray alloc]initWithArray:pageDescrips];
    [self setPageDescripText];
}

- (void)setPageDescripText
{
    self.pageDescripLabel.text = self.pageDescrips[self.currentNumber];
    [self.pageDescripLabel sizeToFit];
}

- (void)setPageChangeTime:(NSTimeInterval)duration
{
    _pageChangeTime = duration;
    [_timer invalidate];
    [self timeSetter];
}

#pragma mark - page change animation type
- (void)pageChangeAnimationType:(NSInteger)animationType
{
    if (animationType == 0) {
        return;
    }else if (animationType == 1) {
        [self.containerView setContentOffset:CGPointMake(2*self.containerView.frame.size.width, 0) animated:YES];
    }else if (animationType == 2){
        self.containerView.contentOffset = CGPointMake(2*self.frame.size.width, 0);
        [UIView animateWithDuration:self.pageChangeTime delay:0.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}

@end
