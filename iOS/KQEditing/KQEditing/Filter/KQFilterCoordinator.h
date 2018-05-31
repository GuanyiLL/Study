//
//  KQFilterCoordinator.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/21.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

typedef NS_ENUM(NSUInteger, KQFilterType) {
    KQFilterTypeNone = 0,
    KQFilterTypeEffectTransfer,
    KQFilterTypeEffectTonal,
    KQFilterTypeEffectProcess,
    KQFilterTypeEffectInstant,
    KQFilterTypeGaussianBlur,
    KQFilterTypeSepiaTone
};

extern NSInteger const kFiltersCount;

@interface KQFilterCoordinator : NSObject

+ (UIImage *)filterType:(KQFilterType)type inputImage:(UIImage *)inputImage;

@end
