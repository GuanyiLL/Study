//
//  UIView+Additions.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

+ (NSString *)reuseableIdentifier {
    return NSStringFromClass([self class]);
}

@end
