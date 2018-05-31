//
//  KQFIlter.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/21.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CIImage;

typedef CIImage *(^Filter)(CIImage*);

@interface KQFIlter : NSObject

+ (Filter)blur:(float)radius imageSize:(CGSize)imageSize;
+ (Filter)generate:(UIColor *)color;
+ (Filter)photoEffectInstant;
+ (Filter)photoEffectProcess;
+ (Filter)photoEffectTonal;
+ (Filter)photoEffectTransfer;
+ (Filter)sepiaTone;
+ (Filter)compositeSourceOver:(CIImage *)overlay;
@end
