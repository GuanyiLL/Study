//
//  HttpManager.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;
@class HomeBanner;
@class Order;

@interface HttpManager : NSObject

+ (NSString*)h5Host;

+ (void)requestVerifyCodeWithParameter:(NSDictionary *)param success:(void (^) (void))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestLoginWithParameter:(NSDictionary *)param success:(void (^) (NSString *token))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestProducts:(NSDictionary *)param success:(void (^) (NSArray<Product *> *products))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestHomeBanner:(NSDictionary *)param success:(void (^) (NSArray<HomeBanner *> *banners))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestRefreshToken:(NSDictionary *)param failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestContactUpload:(NSDictionary *)param success:(void (^) (void))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestCreateOrder:(NSDictionary *)param success:(void (^) (Order *order))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestPay:(NSDictionary *)param success:(void (^) (NSString *orderString))success failure:(void (^) (NSString *errorMessage))failure;

+ (void)requestLogOut:(NSDictionary *)param success:(void (^) (void))success failure:(void (^) (NSString *errorMessage))failure;


@end
