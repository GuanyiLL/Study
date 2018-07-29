//
//  Product.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *originalPrice;
@property (nonatomic) NSInteger seq;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *productDescription;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *redirectUrl;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic) NSInteger isHot;

@end
