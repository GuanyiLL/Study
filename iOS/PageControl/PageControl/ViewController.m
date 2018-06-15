//
//  ViewController.m
//  PageControl
//
//  Created by Guanyi on 2018/6/14.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "ViewController.h"
#import "PageControl.h"

@interface ViewController ()

@property(nonatomic) PageControl *customPageControl;
@property(nonatomic) UIPageControl *page;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor blueColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    
    _page = [[UIPageControl alloc] init];
    _page.numberOfPages = 5;
//    _page.pageIndicatorTintColor = [UIColor greenColor];
//    _page.currentPageIndicatorTintColor = [UIColor blueColor];
    _page.backgroundColor = [UIColor orangeColor];
    [v addSubview:_page];
    [_page addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    
    _customPageControl = [[PageControl alloc] init];
    _customPageControl.numberOfPages = 5;
    _customPageControl.backgroundColor = [UIColor blueColor];
    [v addSubview:_customPageControl];
    
//    _customPageControl.pageIndicatorTintColor = [UIColor clearColor];
//    _customPageControl.pageIndicatorBorderColor = [UIColor colorWithRed:0 green:255 blue:173 alpha:1];
//    _customPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:255 blue:173 alpha:1];
    
    
    [_customPageControl addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChanged {
    NSLog(@"%zd",self.page.currentPage);
    NSLog(@"%zd",self.customPageControl.currentPage);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.page.frame = CGRectMake(20, 100, 200, 50);
    self.customPageControl.frame = CGRectMake(20, 180, 200, 50);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.page.currentPage = 3;
    self.customPageControl.currentPage = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
