//
//  HttpManager.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "HttpManager.h"
#import <AFNetworking.h>

@implementation HttpManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static HttpManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[HttpManager alloc] init];
    });
    return manager;
}

@end
