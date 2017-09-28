//
//  ViewController.m
//  ATWebViewBridge
//
//  Created by Attu on 2017/9/28.
//  Copyright © 2017年 Attu. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onClickButton:(UIButton *)sender {
    WebViewController *webViewVC = [[WebViewController alloc] init];
    webViewVC.h5URL = [NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:@"Test" ofType:@"html"]];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
