//
//  LoginViewController.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/26.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginViewControllerCompletionBlock)(void);

@interface LoginViewController : UIViewController

- (instancetype)initWithLoginCompletion:(LoginViewControllerCompletionBlock)completion;

@end
