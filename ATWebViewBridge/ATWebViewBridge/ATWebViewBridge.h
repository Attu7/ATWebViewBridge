//
//  ATWebViewBridge.h
//  ATWebViewBridgeDemo
//
//  Created by Attu on 2017/9/20.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef void(^ATWebViewBridgeCallBack)(id response);

@interface ATWebViewBridge : NSObject<WKScriptMessageHandler>

extern NSString * const WebViewBridge;

@property (nonatomic, copy, readonly) NSString *injectJS;

@property (nonatomic, assign) id target;

+ (instancetype)sharedInstance;

- (void)configWebView:(WKWebView *)webView;

@end
