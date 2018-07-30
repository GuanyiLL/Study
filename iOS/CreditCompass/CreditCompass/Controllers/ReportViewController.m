//
//  ReportViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "ReportViewController.h"
#import <WebKit/WebKit.h>
#import "UserDefault.h"

@interface ReportViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"风险报告";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                    CGRectGetWidth(self.view.frame),
                                    CGRectGetMinY(self.tabBarController.tabBar.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://h5.huocc.cn/list.html?token=%@",[UserDefault loginToken]]]]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"Finish");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
}

- (WKWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[WKWebView alloc] init];
    _webView.navigationDelegate = self;
    return _webView;
}

@end
