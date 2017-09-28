//
//  WebViewController.m
//  ATWebViewBridge
//
//  Created by Attu on 2017/9/28.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置Target
    [[ATWebViewBridge sharedInstance] setTarget:self];
}

//普通调用
- (void)testOne {
    NSLog(@"<testOne> - JS调用OC方法");
}

//JS传递参数到OC
- (void)testTwo:(id)params {
    NSLog(@"<testTwo> - 接收到JS传递来的参数 - %@", params);
}

//JS传递参数到OC、OC回调参数到JS
- (void)testThree:(id)params :(ATWebViewBridgeCallBack)callBack {
    NSLog(@"<testThree> - 接收到JS传递来的参数 - %@", params);
    callBack(@"testThree - OC回调给JS的参数");
}

//JS传递参数到OC、OC回调参数到JS、返回值到JS
- (NSString *)testFour:(id)params :(ATWebViewBridgeCallBack)callBack {     //方法名请参照该种写法
    NSLog(@"<testFour> - 接收到JS传递来的参数 - %@", params);
    callBack(@"testFour - OC回调给JS的参数");
    return @"testThree - OC返回值";  //返回值必须为对象类型
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
