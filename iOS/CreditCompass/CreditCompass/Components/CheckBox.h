//
//  CheckBox.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckBoxDelegate

@optional
- (void)didTapCheckBox;

@end

@interface CheckBox : UIControl

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) id<CheckBoxDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;

@end
