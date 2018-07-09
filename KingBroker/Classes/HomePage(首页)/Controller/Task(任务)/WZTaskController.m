//
//  WZTaskController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZTaskController.h"
#import <WebKit/WebKit.h>
#import "UIView+Frame.h"
#import "WZShareController.h"
@interface WZTaskController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *pV;

@end

@implementation WZTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIProgressView *pV = [[UIProgressView alloc] init];
    _pV = pV;
    pV.backgroundColor = UIColorRBG(3, 133, 219);
    
    [self.view addSubview:pV];
    
   
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _webView.frame = CGRectMake(0, kApplicationStatusBarHeight-20, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight+20);
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
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    //KVO监听标题
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
     [[webView configuration].userContentController addScriptMessageHandler:self name:@"black"];
    
}
//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //设置JS
    NSString *inputValueJS =[NSString stringWithFormat:@"getuuid('%@')",uuid];
    //执行JS
    [webView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url rangeOfString:@"share.html"].location == NSNotFound) {
        
        NSURL *URL = navigationAction.request.URL;
        NSString *scheme = [URL scheme];
        if ([scheme isEqualToString:@"tel"]) {
            NSString *resourceSpecifier = [URL resourceSpecifier];
            NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
            /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            });
        }
       
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        //跳转分享页面
        NSString *param = navigationAction.request.URL.query;
        if(param.length>0){
            NSString *ID = [param substringFromIndex:3];
            
            WZShareController *shareVC= [[WZShareController alloc] init];
            shareVC.ID = ID;
            [self.navigationController pushViewController:shareVC animated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }
    
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
   
    if ([message.name isEqualToString:@"black"]) {
        
         [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
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
      [[_webView configuration].userContentController removeScriptMessageHandlerForName:@"closeWindow"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   // [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self createWebView];
}

@end
