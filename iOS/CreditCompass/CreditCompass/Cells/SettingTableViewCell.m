//
//  SettingTableViewCell.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *rightImageView;

@end

@implementation SettingTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(20, 0, CGRectGetWidth(self.contentView.frame) - 40 - 30, CGRectGetHeight(self.contentView.frame));
    self.rightImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 14 - 20, CGRectGetHeight(self.contentView.frame) / 2 - 7, 8, 14);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    return _titleLabel;
}

- (UIImageView *)rightImageView {
    if (_rightImageView) {
        return _rightImageView;
    }
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.image = [UIImage imageNamed:@"ic_arrow_trim"];
    [self.contentView addSubview:_rightImageView];
    return _rightImageView;
}

@end
