//
//  WebViewController.h
//  CreditCompass
//
//  Created by Guanyi on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic) BOOL popToRoot;

@end
