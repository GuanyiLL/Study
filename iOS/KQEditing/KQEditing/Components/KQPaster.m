//
//  KQPaster.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQPaster.h"

CGFloat const kMinimumWidth = 40;
CGFloat const kMinimumHeight = 52;
CGFloat const kButtonSize = 30;
CGFloat const kMargin = 15;

@implementation KQPaster {
    UIImageView *_backgroundView;
    UIImageView *_deleteButton;
    UIImageView *_scaleButton;
    CGPoint _previousPoint;
    CGFloat _previousAngle;
    BOOL _isRotating;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

#pragma mark- Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    _isRotating = CGRectContainsPoint(self.scaleButton.frame, touchLocation);
    _previousPoint = touchLocation;
    self.editing = YES;
    [self.delegate didTapPaster:self];
}

- (void)deleteAction:(UITapGestureRecognizer *)tapGesture {
    [self removeFromSuperview];
    [self.delegate removePaster:self];
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    if (_isRotating) { return; };
    CGPoint translation = [panGesture translationInView:self.superview];
    CGPoint newCenter = CGPointMake(panGesture.view.center.x + translation.x,
                                    panGesture.view.center.y + translation.y);
    panGesture.view.center = newCenter;
    [panGesture setTranslation:CGPointZero inView:self.superview];
}

- (void)resizeAction:(UIPanGestureRecognizer *)resizeGesture {
    
    if (resizeGesture.state == UIGestureRecognizerStateBegan) {
        _previousPoint = [resizeGesture locationInView:self];
        _previousAngle = atan2(self.frame.origin.y + self.frame.size.height - self.center.y,
                               self.frame.origin.x + self.frame.size.width - self.center.x) ;
    } else if (resizeGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [resizeGesture locationInView:self];
        CGFloat widthOffset = 0, heightOffset = 0;
        
        widthOffset = (point.x - _previousPoint.x);
        CGFloat widthRatioChange = widthOffset / CGRectGetHeight(self.bounds);
        heightOffset = widthRatioChange * CGRectGetHeight(self.bounds);
        
        CGFloat finalWidth = MAX(CGRectGetWidth(self.bounds) + widthOffset, kMinimumWidth);
        CGFloat finalHeight = MAX(CGRectGetHeight(self.bounds) + heightOffset, kMinimumHeight);
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
        self.backgroundView.frame = CGRectMake(kMargin,
                                               kMargin,
                                               CGRectGetWidth(self.bounds) - kButtonSize,
                                               CGRectGetHeight(self.bounds) - kButtonSize);
        self.scaleButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - kButtonSize,
                                            CGRectGetHeight(self.bounds) - kButtonSize,
                                            kButtonSize,
                                            kButtonSize);
        _previousPoint = [resizeGesture locationOfTouch:0 inView:self];

        CGFloat currentAngle = atan2([resizeGesture locationInView:self.superview].y - self.center.y,
                          [resizeGesture locationInView:self.superview].x - self.center.x);
        CGFloat angleDifference = _previousAngle - currentAngle;
        self.transform = CGAffineTransformMakeRotation(-angleDifference);
    } else if (resizeGesture.state == UIGestureRecognizerStateEnded) {
        _previousPoint = [resizeGesture locationInView:self];
    }
}

#pragma mark- Setter

- (void)setImage:(UIImage *)image {
    _image = image;
    self.backgroundView.image = image;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    self.backgroundView.layer.borderWidth = editing;
    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.deleteButton.hidden = !editing;
    self.scaleButton.hidden = !editing;
}

#pragma mark- Getter

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin,
                                                                        kMargin,
                                                                        CGRectGetWidth(self.bounds) - kButtonSize,
                                                                        CGRectGetHeight(self.bounds) - kButtonSize)];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundView.layer.borderWidth = 1;
        _backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
        _backgroundView.userInteractionEnabled = YES;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIImageView *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      kButtonSize,
                                                                      kButtonSize)];
        _deleteButton.image = [UIImage imageNamed:@"ic_circle_close"];
        _deleteButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction:)];
        [_deleteButton addGestureRecognizer: gesture];
        [self addSubview:_deleteButton];
    }
    return _deleteButton;
}

- (UIImageView *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - kButtonSize,
                                                                     CGRectGetHeight(self.frame) - kButtonSize,
                                                                     kButtonSize,
                                                                     kButtonSize)];
        _scaleButton.image = [UIImage imageNamed:@"ic_circle_stretch"];
        _scaleButton.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(resizeAction:)];
        [_scaleButton addGestureRecognizer:pan];
        [self addSubview:_scaleButton];
    }
    return _scaleButton;
}

@end
