//
//  HomeBanner.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeBanner : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bannerDescription;
@property (nonatomic) NSInteger seq;

@end
