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

@interface HttpManager()

@end

static NSString * const host = @"cps.huocc.cn";
static NSString * version = @"v1";

@implementation HttpManager

+ (NSString *)baseURL {
    return [NSString stringWithFormat:@"http://%@/napi/%@/",host,version];
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

+ (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

@end
