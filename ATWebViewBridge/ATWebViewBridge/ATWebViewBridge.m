//
//  ATWebViewBridge.m
//  ATWebViewBridgeDemo
//
//  Created by Attu on 2017/9/20.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "ATWebViewBridge.h"

@interface ATWebViewBridge ()

@property (nonatomic, strong) WKWebView *webView;

@end

NSString * const WebViewBridge = @"ATWebViewBridge";

@implementation ATWebViewBridge

+ (instancetype)sharedInstance {
    static ATWebViewBridge *webViewBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webViewBridge = [[ATWebViewBridge alloc] init];
    });
    return webViewBridge;
}

- (void)configWebView:(WKWebView *)webView {
    _webView = webView;
}

- (NSString *)injectJS {
    NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"Resource" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [bundle pathForResource:@"ATWebViewBridge" ofType:@"js"];
    NSString *jsString = [NSString stringWithContentsOfFile:path encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:nil];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsString;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wincompatible-pointer-types-discards-qualifiers"
    if ([message.name isEqualToString:WebViewBridge]) {
    #pragma clang diagnostic pop
    
        NSString *methodName = message.body[@"methodName"];
        NSDictionary *params = message.body[@"params"];
        NSString *callBackName = message.body[@"callBackName"];
        __weak typeof(_webView) weakWebView = _webView;
        id returnValue;
        if (callBackName) {
            returnValue = [self performWithMethodName:methodName params:params callBack:^(id response) {
                NSString *js = [NSString stringWithFormat:@"ATWebViewBridge.callBack('%@','%@')", callBackName, response];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakWebView evaluateJavaScript:js completionHandler:nil];
                });
            }];
        } else {
            returnValue = [self performWithMethodName:methodName params:params callBack:nil];
        }
        if (returnValue) {
            NSString *returnValueName = [methodName stringByAppendingString:@"ReturnValue"];
            NSString *returnJS = [NSString stringWithFormat:@"ATWebViewBridge.returnValue('%@','%@')", returnValueName, returnValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakWebView evaluateJavaScript:returnJS completionHandler:nil];
            });
        }
    }
}

- (id)performWithMethodName:(NSString *)methodName params:(NSDictionary *)params callBack:(void(^)(id response))callBack {
    
    NSMutableArray *paramsArray = [NSMutableArray array];
    if (params && ![params isKindOfClass:[NSNull class]]) {
        methodName = [methodName stringByAppendingString:@":"];
        [paramsArray addObject:params];
    }
    if (callBack) {
        methodName = [methodName stringByAppendingString:@":"];
        [paramsArray addObject:callBack];
    }
    
    SEL selector = NSSelectorFromString(methodName);
    if ([self.target ? self.target : self respondsToSelector:selector]) {
        return [self at_performSelector:selector withObjects:paramsArray];
    }
    return nil;
}

- (id)at_performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    id target = self.target ? self.target : self;
    NSMethodSignature *signature = [target methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        id tempObject = object;
        [invocation setArgument:&tempObject atIndex:++i];
    }
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        __autoreleasing id data = nil;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

@end
