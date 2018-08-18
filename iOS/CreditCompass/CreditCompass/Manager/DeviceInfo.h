//
//  DeviceInfo.h
//  CreditCompass
//
//  Created by Guanyi on 2018/8/3.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

+ (NSDictionary *)wifiInfo;

+ (NSString *)macAddress;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;


@end
