//
//  UIView+KQKQAddition.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/21.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "UIView+KQAddition.h"

@implementation UIView (KQAddition)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

@end
