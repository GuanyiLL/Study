//
//  UIButton+Additions.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "UIButton+Additions.h"
#import <objc/runtime.h>

@implementation UIButton (Additions)

static NSString * const isDisableAssociatedKey = @"isDisableKey";

- (void)setIsDisable:(BOOL)isDisable {
    if (isDisable) {
        [self setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
        self.userInteractionEnabled = NO;
    } else {
        [self setBackgroundColor:[UIColor colorWithRed:107/255.0 green:151/255.0 blue:249/255.0 alpha:1]];
        self.userInteractionEnabled = YES;
    }
    NSNumber *number = [NSNumber numberWithBool: isDisable];
    objc_setAssociatedObject(self, &isDisableAssociatedKey, number, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isDisable {
    NSNumber *number =  objc_getAssociatedObject(self, &isDisableAssociatedKey);
    return [number boolValue];
}


@end
