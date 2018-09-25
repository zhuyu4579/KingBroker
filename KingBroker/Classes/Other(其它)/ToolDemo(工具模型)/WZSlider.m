//
//  WZSlider.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/4.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZSlider.h"
#import "UIView+Dimension.h"
#import "WZHouseController.h"
#import "UIButton+WZEnlargeTouchAre.h"
@interface WZSlider ()

@property (nonatomic,assign)CGFloat CurrentMinNum;

@property (nonatomic,assign)CGFloat CurrentMaxNum;


@end
@implementation WZSlider
{
    
    UIView *_minSliderLine;
    UIView *_maxSliderLine;
    UIView *_mainSliderLine;
    
    
    CGFloat _constOffY;
    CGFloat _tatols;
    CGFloat _tatol;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        if (frame.size.height < 80.0f) {
            self.height = 80.0f;
        }
        [self createMainView];
    }
    return self;
}

- (void)createMainView
{
    _minLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, self.width/2.0f, 14)];
    _minLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _minLabel.textColor = UIColorRBG(255, 168, 66);
    _maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2.0f-16, 10 ,self.width/2.0f , 14)];
    _maxLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _maxLabel.textColor = UIColorRBG(255, 168, 66);
    _minLabel.textAlignment = NSTextAlignmentLeft;
    _maxLabel.textAlignment = NSTextAlignmentRight;
    _minLabel.adjustsFontSizeToFitWidth = YES;
    _maxLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_minLabel];
    [self addSubview:_maxLabel];
    
    self.minNum = 0;
    self.maxNum = 1450;
    self.unit = @"万";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,40, self.width, 34)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    //2.设置阴影偏移范围
    view.layer.shadowOffset = CGSizeMake(0, 1);
    //3.设置阴影颜色的透明度
    view.layer.shadowOpacity = 0.31;
    //4.设置阴影半径
    view.layer.shadowRadius = 2;
    view.layer.cornerRadius = 17;
    [self addSubview:view];
    
    _mainSliderLine = [[UIView alloc]initWithFrame:CGRectMake(12,14, self.width-24, 7)];
    _mainSliderLine.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:_mainSliderLine];
    
    _minSliderLine = [[UIView alloc]initWithFrame:CGRectMake(12, _mainSliderLine.top, 0, _mainSliderLine.height)];
    _minSliderLine.backgroundColor = [UIColor redColor];
    [view addSubview:_minSliderLine];
    
    _maxSliderLine = [[UIView alloc]initWithFrame:CGRectMake(self.width-12, _mainSliderLine.top, 0, _mainSliderLine.height)];
    _maxSliderLine.backgroundColor = [UIColor redColor];
    [view addSubview:_maxSliderLine];
    
    
    UIButton *minSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(0,7, 20, 20)];
    [minSliderButton setBackgroundImage:[UIImage imageNamed:@"slide-button"] forState:UIControlStateNormal];
    [minSliderButton setEnlargeEdge:20];
    minSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    minSliderButton.layer.masksToBounds = YES;
    minSliderButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    minSliderButton.layer.borderWidth = 0.5;
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [view addSubview:minSliderButton];
    _minSlider = minSliderButton;
    
    
    UIButton *maxSliderButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-24, 7, 20, 20)];
    [maxSliderButton setBackgroundImage:[UIImage imageNamed:@"slide-button"] forState:UIControlStateNormal];
    [maxSliderButton setEnlargeEdge:20];
    maxSliderButton.layer.cornerRadius = minSliderButton.width/2.0f;
    maxSliderButton.layer.masksToBounds = YES;
    maxSliderButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    maxSliderButton.layer.borderWidth = 0.5;
    UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
    [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
    [view addSubview:maxSliderButton];
    _maxSlider = maxSliderButton;
    _constOffY = _minSlider.centerY;
    
}

- (void)panMinSliderButton:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self];
    static CGPoint center;
    if (pgr.state == UIGestureRecognizerStateBegan) {
        center = pgr.view.center;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    
    
    if (pgr.view.right > _maxSlider.left) {
        pgr.view.right = _maxSlider.left;
    }else{
        if (pgr.view.centerX < 12) {
            pgr.view.centerX = 12;
        }
        if (pgr.view.centerX > self.width-12) {
            pgr.view.centerX = self.width-12;
        }
    }
    _minSliderLine.frame = CGRectMake(_minSliderLine.left, _minSliderLine.top,  pgr.view.centerX-_minSliderLine.left, _minSliderLine.height);
    
    [self valueMinChange:pgr.view.centerX];
}

- (void)panMaxSliderButton:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self];
    static CGPoint center;
    if (pgr.state == UIGestureRecognizerStateBegan) {
        center = pgr.view.center;
    }
    pgr.view.center = CGPointMake(center.x + point.x, center.y + point.y);
    pgr.view.centerY = _constOffY;
    
    if (pgr.view.left < _minSlider.right) {
        pgr.view.left = _minSlider.right;
    }else{
        if (pgr.view.centerX < 24) {
            pgr.view.centerX = 24;
        }
        if (pgr.view.centerX > self.width-12) {
            pgr.view.centerX = self.width-12;
        }
    }
    _maxSliderLine.frame = CGRectMake(pgr.view.centerX, _maxSliderLine.top, self.width-pgr.view.centerX-12, _maxSliderLine.height);
    
    [self valueMaxChange:pgr.view.centerX];
}

- (void)valueMinChange:(CGFloat)num
{
    int n =  ceilf((num-12) /_tatols);
    if (n <= 50) {
        if (n * 10 == 0) {
            _minLabel.text = [NSString stringWithFormat:@"%i",n * 10];
            
        }else{
            _minLabel.text = [NSString stringWithFormat:@"%i",n * 10];
            
        }
        
        _currentMinValue = n * 10;
    }else{
        _minLabel.text = [NSString stringWithFormat:@"%i",(n-50) * 50 + 50*10];
        
        _currentMinValue = (n-50) * 50 + 50*10;
    }
}

- (void)valueMaxChange:(CGFloat)num
{

    int n =  ceilf((num-24) /_tatol);
    if (n <= 50) {
        _maxLabel.text = [NSString stringWithFormat:@"%i",n * 10];
        _currentMinValue = n * 10;
    }else{
        _currentMinValue = (n-50) * 50 + 50*10;
        
        if((n-50) * 50 + 50*10 == 1450){
            _maxLabel.text =@"不限";
        }else{
            _maxLabel.text = [NSString stringWithFormat:@"%i",(n-50) * 50 + 50*10];
        }
    }
    
}


-(void)setMinNum:(CGFloat)minNum
{
    //前三分之二每十万递增
    //后三分之一每五十万递增
    _minNum = minNum;
    _tatols = (self.width-48)/69.0;
    _minLabel.text = [NSString stringWithFormat:@"%.0f",minNum];
    _currentMinValue = minNum;
    
}

-(void)setMaxNum:(CGFloat)maxNum
{
    _maxNum = maxNum;
    _tatol = (self.width-36)/69.0;
    if (maxNum == 1450) {
        _maxLabel.text = @"不限";
        _currentMaxValue = maxNum;
    }
    
}

-(void)setMinTintColor:(UIColor *)minTintColor
{
    _minTintColor = minTintColor;
    _minSliderLine.backgroundColor = minTintColor;
}

-(void)setMaxTintColor:(UIColor *)maxTintColor
{
    _maxTintColor = maxTintColor;
    _maxSliderLine.backgroundColor = maxTintColor;
}

-(void)setMainTintColor:(UIColor *)mainTintColor
{
    _mainTintColor = mainTintColor;
    _mainSliderLine.backgroundColor = mainTintColor;
}

-(void)setUnit:(NSString *)unit
{
    _unit = unit;
}


@end
