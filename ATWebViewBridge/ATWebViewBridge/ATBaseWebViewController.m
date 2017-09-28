//
//  ATBaseWebViewController.m
//  ATWebViewBridgeDemo
//
//  Created by Attu on 2017/9/20.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "ATBaseWebViewController.h"

@interface ATBaseWebViewController ()

@end

@implementation ATBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configWKWebview];
}

- (void)configWKWebview {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    WKUserScript *usrScript = [[WKUserScript alloc] initWithSource:[ATWebViewBridge sharedInstance].injectJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    [config.userContentController addUserScript:usrScript];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:[ATWebViewBridge sharedInstance] name:WebViewBridge];
    

    //通过默认的构造器来创建对象
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.h5URL]]];
    [self.view addSubview:self.webView];
    
    [[ATWebViewBridge sharedInstance] configWebView:self.webView];
}

#pragma mark - Public Method

- (void)invokeJSMethod:(NSString *)jsMethod {
    __weak typeof(_webView) weakWebView = _webView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakWebView evaluateJavaScript:jsMethod completionHandler:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //删除所有的回调事件
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:WebViewBridge];
    [self.webView evaluateJavaScript:@"ATWebViewBridge.removeAllCallBacks();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
}

@end
