//
//  UILabel+Additions.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (CGSize)fittingSizeBasedOnWidth:(CGFloat)width {
    CGSize size;
    size = [self.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    return size;
}

@end
