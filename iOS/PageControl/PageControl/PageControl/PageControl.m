//
//  PageControl.m
//  PageControl
//
//  Created by Guanyi on 2018/6/14.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "PageControl.h"

CGFloat const circleDiameter = 7.5;
CGFloat const circleSpace = 6.5;

@implementation PageControl {
    UIView *_container;
}

#pragma mark- Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    NSArray *circles = self.container.layer.sublayers;
    for (NSInteger i = 0; i < circles.count; i++) {
        CALayer *layer = circles[i];
        
        CGFloat diff = i - self.currentPage > 0 ? 3 * circleDiameter : 0;
        CGFloat width = 0;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (i == self.currentPage) {
            width = circleDiameter * 4;
            layer.borderWidth = 0;
            layer.backgroundColor = self.currentPageIndicatorTintColor.CGColor ?: [UIColor whiteColor].CGColor;
        } else {
            width = circleDiameter;
            layer.borderWidth = self.pageIndicatorBorderColor.CGColor ? 1 : 0;
            layer.borderColor = self.pageIndicatorBorderColor.CGColor;
            layer.backgroundColor = self.pageIndicatorTintColor.CGColor ?: [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        }
        [CATransaction commit];
        
        layer.frame = CGRectMake(i * (circleDiameter + circleSpace) + diff, 0, width, circleDiameter);
        layer.cornerRadius = circleDiameter / 2;
    }
    self.container.frame = CGRectMake(0, 0, self.numberOfPages * (circleSpace + circleDiameter) - circleSpace + 3 * circleDiameter, circleDiameter);
    self.container.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touchPoint.x > CGRectGetWidth(self.frame) / 2) {
        self.currentPage = MIN(++self.currentPage, self.numberOfPages - 1);
    } else {
        self.currentPage = MAX(0, --self.currentPage);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark- Setter

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    for (CALayer *circle in self.container.layer.sublayers) {
        [circle removeFromSuperlayer];
    }
    for (NSInteger i = 0; i < numberOfPages; i++) {
        CALayer *layer = [CALayer layer];
        [self.container.layer addSublayer:layer];
    }
}

#pragma mark- Getter

- (UIView *)container {
    if (_container) {
        return _container;
    }
    _container = [[UIView alloc] init];
    [self addSubview:_container];
    return _container;
}

@end
