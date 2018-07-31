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
#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ReportViewController () <UIWebViewDelegate>

//@property (nonatomic) WKWebView *webView;
@property (nonatomic) UIWebView *webView;

@property (nonatomic) JSContext *context;

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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };

    __weak __typeof(self) weakSelf = self;
    self.context[@"goToDetail"] = ^(NSString *order, NSInteger type){
        WebViewController *web = [[WebViewController alloc] init];
        NSString *url = @"";
        if (type == 1) {
            url = [NSString stringWithFormat:@"http://h5.huocc.cn/risk-contacts.html?token=%@&outTradeno=%@",[UserDefault loginToken],order];
        } else {
            url = [NSString stringWithFormat:@"http://h5.huocc.cn/risk-black.html?token=%@&outTradeno=%@",[UserDefault loginToken],order];
        }
        web.url = url;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController pushViewController:web animated:YES];
        });
    };

}

- (UIWebView *)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    return _webView;
}


@end
