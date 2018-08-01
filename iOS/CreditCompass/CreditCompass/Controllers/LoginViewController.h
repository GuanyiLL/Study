//
//  LoginViewController.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/26.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^LoginViewControllerCompletionBlock)(void);

@interface LoginViewController : BaseViewController

- (instancetype)initWithLoginCompletion:(LoginViewControllerCompletionBlock)completion;

@end
