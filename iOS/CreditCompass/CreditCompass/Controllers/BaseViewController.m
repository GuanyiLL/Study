//
//  BaseViewController.m
//  CreditCompass
//
//  Created by Guanyi on 2018/8/1.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count> 1) {
        
        UIView *closeButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 10, 10, 20);
        [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"ic_title_back"] forState:UIControlStateNormal];
        [closeButton addSubview:button];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
        
    }
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
