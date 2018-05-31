//
//  KQItem.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQItem.h"

CGFloat const kImageViewWidth = 46;
CGFloat const kImageViewHeight = 60;

@implementation KQItem

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.width / 2 - kImageViewWidth / 2,
                                      self.height / 2 - kImageViewHeight / 2,
                                      kImageViewWidth,
                                      kImageViewHeight);
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    return _imageView;
}

@end
