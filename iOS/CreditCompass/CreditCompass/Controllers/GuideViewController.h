//
//  GuideViewController.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^GuideViewControllerCompletionBlock) (void);

@interface GuideViewController : BaseViewController

- (instancetype)initWithCompetion:(GuideViewControllerCompletionBlock)competion;

@end
