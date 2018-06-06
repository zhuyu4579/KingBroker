//
//  WZNEWHTMLController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/5/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZNEWHTMLController.h"
#import <WebKit/WebKit.h>
#import "UIView+Frame.h"
@interface WZNEWHTMLController ()
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *pV;
@end

@implementation WZNEWHTMLController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createWebView];
    UIProgressView *pV = [[UIProgressView alloc] init];
    _pV = pV;
    pV.backgroundColor = UIColorRBG(3, 133, 219);
    [self.view addSubview:pV];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _webView.frame = CGRectMake(0, 0, self.view.fWidth, self.view.fHeight);
    _pV.frame = CGRectMake(0, kApplicationStatusBarHeight+44, self.view.fWidth, 2);
}
- (void)createWebView
{
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    // 根据需要去设置对应的属性
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    //KVO监听标题
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
//监听值改变时就会调用
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.title = _webView.title;
    _pV.progress = _webView.estimatedProgress;
    _pV.hidden = _webView.estimatedProgress >= 1.0;
}
-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}


@end
