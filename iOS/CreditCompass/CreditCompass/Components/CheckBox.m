//
//  CheckBox.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "CheckBox.h"

@interface CheckBox()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageView;

@end

@implementation CheckBox

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _isSelected = false;
        [self addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, [self.titleLabel fittingSizeBasedOnWidth:CGRectGetWidth(self.frame)].width, CGRectGetHeight(self.frame));
}

- (void)didTap:(id)sender {
    self.isSelected = !self.isSelected;
    if (self.delegate) {
        [self.delegate didTapCheckBox];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        self.imageView.image = [UIImage imageNamed:@"ic_checkbox_on"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"ic_checkbox_off"];
    }
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"ic_checkbox_off"];
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = self.title;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor colorWithRed:195 / 255.0 green:195 / 255.0 blue:195 / 255.0 alpha:1];
    [self addSubview:_titleLabel];
    return _titleLabel;
}

@end
