//
//  CreateReportViewController.m
//  CreditCompass
//
//  Created by Guanyi on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "CreateReportViewController.h"
#import <MDRadialProgressView.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>
#import "WebViewController.h"
#import "Order.h"
#import "UserDefault.h"

@interface CreateReportViewController ()

@property (nonatomic) NSTimer *timer;
@property (nonatomic) MDRadialProgressView *progressView;
@property (nonatomic) UILabel *label;
@property (nonatomic) NSInteger count;

@end

@implementation CreateReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.count = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.labelColor = [UIColor blackColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    newTheme.thickness = 30;
    newTheme.sliceDividerHidden = NO;
    newTheme.sliceDividerColor = [UIColor whiteColor];
    newTheme.sliceDividerThickness = 2;
    
    _progressView = [[MDRadialProgressView alloc] init];
    
    _progressView.progressTotal = 10;
    _progressView.progressCounter = 0;
    _progressView.clockwise = YES;
    _progressView.theme.completedColor = [UIColor colorWithRed:90/255.0 green:200/255.0 blue:251/255.0 alpha:1.0];
    _progressView.theme.incompletedColor = [UIColor colorWithRed:82/255.0 green:237/255.0 blue:199/255.0 alpha:1.0];
    _progressView.theme.thickness = 30;
    _progressView.theme.sliceDividerHidden = NO;
    _progressView.theme.sliceDividerColor = [UIColor whiteColor];
    _progressView.theme.sliceDividerThickness = 2;
    [self.view addSubview:_progressView];
    
    _label = [[UILabel alloc] init];
    _label.text = @"正在生成报告...";
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.progressView.frame = CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 100, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 100, 200, 200);
    self.progressView.label.center = CGPointMake(CGRectGetWidth(self.progressView.frame) / 2, CGRectGetHeight(self.progressView.frame) / 2);
    
    self.label.frame = CGRectMake(0, CGRectGetMaxY(self.progressView.frame) + 50, CGRectGetWidth(self.view.frame), 30);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.timer fire];
}

- (void)refreshTime {
    self.count++;
    if (self.count > 100) {
        [self.timer invalidate];
        self.timer = nil;
        WebViewController *web = [[WebViewController alloc] init];
        if (self.order.type == 1) {
            web.url = [NSString stringWithFormat:@"http://h5.huocc.cn/risk-contacts.html?token=%@&outTradeno=%@",[UserDefault loginToken],self.order.outTradeno];
            web.title = @"通讯录风险报告";
        } else {
            web.url = [NSString stringWithFormat:@"http://h5.huocc.cn/risk-black.html?token=%@&outTradeno=%@",[UserDefault loginToken],self.order.outTradeno];
            web.title = @"黑名单风险报告";
        }
        web.popToRoot = YES;
        [self.navigationController pushViewController:web animated:YES];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progressCounter = self.count / 10;
        self.progressView.label.text = [NSString stringWithFormat:@"%ld%%",(long)self.count];
    });
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


@end
