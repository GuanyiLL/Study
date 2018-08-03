//
//  WebViewController.m
//  CreditCompass
//
//  Created by Guanyi on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                    CGRectGetWidth(self.view.frame),
                                    [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)pop {
    if (self.popToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (WKWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    return _webView;
}



@end
