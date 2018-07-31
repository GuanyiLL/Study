//
//  PaymentMethodSelectorCell.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaymentMethod;

@interface PaymentMethodSelectorCell : UITableViewCell

@property (nonatomic) BOOL isSelected;

- (void)refreshCell:(PaymentMethod *)data;

@end
