//
//  LoginManager.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "LoginManager.h"
#import "UserDefault.h"
#import "LoginViewController.h"

@implementation LoginManager

+ (BOOL)hasLogined {
    NSString *token = [UserDefault loginToken];
    return token.length > 0;
}

+ (void)showLoginControlerWithParentController:(UIViewController *)parentController {
    UINavigationController *login = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] initWithLoginCompletion:^{
        
    }]];
    [parentController presentViewController:login animated:YES completion:nil];
}

@end
