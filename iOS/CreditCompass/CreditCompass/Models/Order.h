//
//  Order.h
//  CreditCompass
//
//  Created by Guanyi on 2018/7/30.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic) NSInteger status;
@property (nonatomic, copy) NSString *outTradeno;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic) NSInteger prodId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bankCard;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic) NSInteger type;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *payPrice;
@property (nonatomic, copy) NSString *orderExpireStr;
@property (nonatomic, copy) NSString *orderTimeStr;
@property (nonatomic, copy) NSString *exceptionMsg;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic) NSInteger reportStatus;

@end
