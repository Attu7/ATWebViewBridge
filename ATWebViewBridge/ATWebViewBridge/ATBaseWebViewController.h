//
//  ATBaseWebViewController.h
//  ATWebViewBridgeDemo
//
//  Created by Attu on 2017/9/20.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATWebViewBridge.h"

@interface ATBaseWebViewController : UIViewController

@property (nonatomic, copy) NSString *h5URL;

@property (nonatomic, strong) WKWebView *webView;

//调用JS方法
- (void)invokeJSMethod:(NSString *)jsMethod;

@end
