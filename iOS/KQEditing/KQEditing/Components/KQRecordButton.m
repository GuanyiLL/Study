//
//  KQRecordButton.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/28.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQRecordButton.h"

@interface KQRecordButton()

@property (nonatomic) CAShapeLayer *borderLayer;
@property (nonatomic) CALayer *centerLayer;


@end

@implementation KQRecordButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setIsRecording:(BOOL)isRecording {
    _isRecording = isRecording;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isRecording) {
            self.centerLayer.frame = CGRectMake(15, 15, CGRectGetWidth(self.frame) - 30, CGRectGetWidth(self.frame) - 30);
            self.centerLayer.cornerRadius = 5;
        } else {
            self.centerLayer.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetWidth(self.frame) - 10);
            self.centerLayer.cornerRadius = CGRectGetWidth(self.frame) / 2 - 5;
        }
    });
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){0,0,CGRectGetWidth(frame),CGRectGetWidth(frame)}];
    self.borderLayer.path = path.CGPath;
    
    if (self.isRecording) {
        self.centerLayer.frame = CGRectMake(15, 15, CGRectGetWidth(self.frame) - 30, CGRectGetWidth(self.frame) - 30);
        self.centerLayer.cornerRadius = 5;
    } else {
        self.centerLayer.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetWidth(self.frame) - 10);
        self.centerLayer.cornerRadius = CGRectGetWidth(self.frame) / 2 - 5;
    }
}

- (CALayer *)centerLayer {
    if (_centerLayer) {
        return _centerLayer;
    }
    _centerLayer = [CALayer layer];
    _centerLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:_centerLayer];
    return _centerLayer;
}

- (CAShapeLayer *)borderLayer {
    if (_borderLayer) {
        return _borderLayer;
    }
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.lineWidth = 5;
    _borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_borderLayer];
    return _borderLayer;
}

@end
