//
//  UserDefault.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "UserDefault.h"

NSString *const UserDefaultTokenKey = @"token";
NSString *const UserDefaultPhoneNumber = @"phoneNumber";

@implementation UserDefault

+ (void)saveLoginToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:UserDefaultTokenKey];
}

+ (NSString *)loginToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultTokenKey];
}

+ (void)savePhoneNumber:(NSString *)phoneNumber {
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:UserDefaultTokenKey];
}

+ (NSString *)phoneNumber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultPhoneNumber];
}

@end
