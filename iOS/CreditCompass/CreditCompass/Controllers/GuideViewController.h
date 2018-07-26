//
//  GuideViewController.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GuideViewControllerCompletionBlock) (void);

@interface GuideViewController : UIViewController

- (instancetype)initWithCompetion:(GuideViewControllerCompletionBlock)competion;

@end
