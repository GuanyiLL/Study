//
//  InspectController.h
//  CreditCompass
//
//  Created by Guanyi on 2018/7/30.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;
@class CheckBox;

typedef NS_ENUM(NSUInteger, InspectControllerType) {
    InspectControllerTypeContact,
    InspectControllerTypeBlacklist,
};

@interface InspectController : UIViewController

@property (nonatomic) Product *product;
@property (nonatomic) CheckBox *checkBox;
@property (nonatomic) UIButton *inspectButton;
@property (nonatomic) UIImageView *imageView;

+ (instancetype)inspectWithType:(InspectControllerType)type product:(Product *)product;

@end
