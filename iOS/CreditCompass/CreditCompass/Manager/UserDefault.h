//
//  UserDefault.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

+ (void)saveLoginToken:(NSString *)token;
+ (NSString *)loginToken;

+ (void)savePhoneNumber:(NSString *)phoneNumber;
+ (NSString *)phoneNumber;

@end
