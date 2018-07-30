//
//  UnderlineTextField.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "UnderlineTextField.h"

@interface UnderlineTextField()

@property (nonatomic) UIView *underLine;

@end

@implementation UnderlineTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self addSubview:_underLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _underLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) + 8 , CGRectGetWidth(self.frame), 2);
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 45, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 45, 0);
}


@end
