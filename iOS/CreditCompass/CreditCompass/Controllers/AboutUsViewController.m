//
//  AboutUsViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/8/4.
//  Copyright © 2018年 ra1n. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic) UILabel *label;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.label = [[UILabel alloc] init];
    self.label.text = @"欢迎使用信用罗盘";
    [self.view addSubview:self.label];
    self.label.textAlignment = NSTextAlignmentCenter;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.label.frame = CGRectMake(0, CGRectGetMidY(self.view.frame) - 20, CGRectGetWidth(self.view.frame), 20);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
