//
//  PaymentMethodSelectorCell.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "PaymentMethodSelectorCell.h"
#import "PaymentMethod.h"

@interface PaymentMethodSelectorCell()

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end

@implementation PaymentMethodSelectorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.rightImageView.image = [UIImage imageNamed:isSelected ? @"ic_checkbox_on" : @"ic_checkbox_off"];
}

- (void)refreshCell:(PaymentMethod *)data {
    self.leftImageView.image = [UIImage imageNamed:data.image];
    self.titleLabel.text = data.title;
}


@end
