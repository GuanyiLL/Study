//
//  HttpManager.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/28.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "HttpManager.h"
#import <AFNetworking.h>
#import "Product.h"
#import "HomeBanner.h"
#import "UserDefault.h"
#import "Order.h"

@interface HttpManager()

@end

static NSString * const h5_host = @"http://h5.huocc.cn";
static NSString * const host = @"cps.huocc.cn";
static NSString * const version = @"v1";

@implementation HttpManager

+ (NSString *)baseURL {
    return [NSString stringWithFormat:@"http://%@/napi/%@/",host,version];
}

+ (NSString*)h5Host {
    return h5_host;
}

+ (void)requestVerifyCodeWithParameter:(NSDictionary *)param success:(void (^) (void))success failure:(void (^) (NSString *errorMessage))failure {
    
    [self.manager POST:[NSString stringWithFormat:@"%@/sendCode/",[self baseURL]] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            success();
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestLoginWithParameter:(NSDictionary *)param success:(void (^) (NSString *token))success failure:(void (^) (NSString *errorMessage))failure {
    [self.manager POST:[NSString stringWithFormat:@"%@/login/",[self baseURL]] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            success(responseObject[@"token"]);
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestProducts:(NSDictionary *)param success:(void (^) (NSArray<Product *> *products))success failure:(void (^) (NSString *errorMessage))failure {
    [self.manager POST:[NSString stringWithFormat:@"%@/productList/",[self baseURL]] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *datas = responseObject[@"data"];
            for (NSDictionary *d in datas) {
                Product *m = [[Product alloc] init];
                m.type = [d[@"type"] integerValue];
                m.price = [NSString stringWithFormat:@"%.2f",[d[@"price"] floatValue]];
                m.originalPrice = [NSString stringWithFormat:@"%.2f",[d[@"orignalPrice"] floatValue]];
                m.seq = [d[@"seq"] integerValue];
                m.name = d[@"name"];
                m.productDescription = d[@"description"];
                m.redirectUrl = d[@"redirectUrl"];
                m.count = d[@"count"];
                m.cover = d[@"cover"];
                m.isHot = [d[@"isHot"] integerValue];
                m.productID = [d[@"id"] integerValue];
                [arr addObject:m];
            }
//            [arr sortUsingComparator:^NSComparisonResult(Product *obj1, Product *obj2) {
//                return obj1.seq < obj2.seq;
//            }];
            success([arr copy]);
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestHomeBanner:(NSDictionary *)param success:(void (^) (NSArray<HomeBanner *> *banners))success failure:(void (^) (NSString *errorMessage))failure {
    [self.manager POST:[NSString stringWithFormat:@"%@/pollList/",[self baseURL]] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *datas = responseObject[@"data"];
            for (NSDictionary *d in datas) {
                HomeBanner *m = [[HomeBanner alloc] init];
                m.bannerDescription = d[@"description"];
                m.url = d[@"path"];
                m.title = d[@"title"];
                m.seq = [d[@"seq"] integerValue];
                [arr addObject:m];
            }
            success([arr copy]);
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestRefreshToken:(NSDictionary *)param failure:(void (^) (NSString *errorMessage))failure {
    [self.manager POST:[NSString stringWithFormat:@"http://%@/api/%@/refreshToken",host,version] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            [UserDefault saveLoginToken:responseObject[@"newToken"]];
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestContactUpload:(NSDictionary *)param success:(void (^) (void))success failure:(void (^) (NSString *errorMessage))failure {
    AFHTTPSessionManager *m = self.manager;
    [m.requestSerializer setValue:[UserDefault loginToken] forHTTPHeaderField:@"token"];
    [m POST:[NSString stringWithFormat:@"http://%@/api/%@/contactsImport/",host,version] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            success();
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestCreateOrder:(NSDictionary *)param success:(void (^) (Order * order))success failure:(void (^) (NSString *errorMessage))failure {
    AFHTTPSessionManager *m = self.manager;
    [m.requestSerializer setValue:[UserDefault loginToken] forHTTPHeaderField:@"token"];
    [m POST:[NSString stringWithFormat:@"http://%@/api/%@/createOrder/",host,version] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            responseObject = responseObject[@"data"];
            Order *m = [[Order alloc] init];
            m.status = [responseObject[@"status"] integerValue];
            m.reportStatus = [responseObject[@"reportStauts"] integerValue];
            m.outTradeno = responseObject[@"outTradeno"];
            m.tel = responseObject[@"tel"];
            m.prodId = [responseObject[@"prodId"] integerValue];
            m.name = responseObject[@"name"];
            m.bankCard = responseObject[@"bankCard"];
            m.idCard = responseObject[@"idCard"];
            m.type = [responseObject[@"type"]integerValue];
            m.totalPrice = responseObject[@"totalPrice"];
            m.payPrice = responseObject[@"payPrice"];
            m.orderExpireStr = responseObject[@"orderExpireStr"];
            m.exceptionMsg = responseObject[@"exceptionMsg"];
            m.orderTimeStr = responseObject[@"orderTimeStr"];
            m.startTime = responseObject[@"startTime"];
            m.endTime = responseObject[@"endTime"];
            success(m);
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (void)requestLogOut:(NSDictionary *)param success:(void (^) (void))success failure:(void (^) (NSString *errorMessage))failure {
    [self.manager POST:[NSString stringWithFormat:@"http://%@/api/%@/logOut/",host,version] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            success();
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];

}

+ (void)requestPay:(NSDictionary *)param success:(void (^) (NSString *orderString))success failure:(void (^) (NSString *errorMessage))failure {
    AFHTTPSessionManager *m = self.manager;
    [m.requestSerializer setValue:[UserDefault loginToken] forHTTPHeaderField:@"token"];
    [m POST:[NSString stringWithFormat:@"http://%@/api/%@/alipayAppPay/",host,version] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0000"]) {
            success(responseObject[@"orderString"]);
        } else {
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(@"网络错误");
    }];
}

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

@end
