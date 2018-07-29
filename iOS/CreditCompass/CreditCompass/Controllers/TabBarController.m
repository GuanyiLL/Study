//
//  TabBarController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "TabBarController.h"
#import "LoginManager.h"
#import "LoginViewController.h"

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.viewControllers[0] == viewController) { return YES; }
    if ([LoginManager hasLogined]) {
        return YES;
    } else {
        [LoginManager showLoginControlerWithParentController:self];
        return NO;
    }
}


@end
