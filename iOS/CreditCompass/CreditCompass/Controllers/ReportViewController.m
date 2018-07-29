//
//  ReportViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "ReportViewController.h"
#import <WebKit/WebKit.h>

@interface ReportViewController ()

@property (nonatomic) WKWebView *webView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"风险报告";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                    CGRectGetWidth(self.view.frame),
                                    CGRectGetMinY(self.tabBarController.tabBar.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (WKWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[WKWebView alloc] init];
    return _webView;
}

@end
