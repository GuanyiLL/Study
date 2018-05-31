//
//  KQFIlter.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/21.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQFIlter.h"
#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@implementation KQFIlter

+ (Filter)blur:(float)radius imageSize:(CGSize)imageSize {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputImageKey:image,
                                     kCIInputRadiusKey:@(radius),
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CIMotionBlur" withInputParameters:parameters];
        CIImage *outputImage = filter.outputImage;
        return outputImage;
    };
}

+ (Filter)generate:(UIColor *)color {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputColorKey:[CIColor colorWithCGColor:color.CGColor],
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CIConstantColorGenerator" withInputParameters:parameters];
        return filter.outputImage;
    };
}

+ (Filter)photoEffectInstant {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputImageKey:image,
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant" withInputParameters:parameters];
        return filter.outputImage;
    };
}

+ (Filter)photoEffectProcess {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputImageKey:image,
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectProcess" withInputParameters:parameters];
        return filter.outputImage;
    };
}

+ (Filter)photoEffectTonal {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputImageKey:image,
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTonal" withInputParameters:parameters];
        return filter.outputImage;
    };
}

+ (Filter)photoEffectTransfer {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputImageKey:image,
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer" withInputParameters:parameters];
        return filter.outputImage;
    };
}

+ (Filter)sepiaTone {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputImageKey:image,
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" withInputParameters:parameters];
        return filter.outputImage;
    };
}

+ (Filter)compositeSourceOver:(CIImage *)overlay {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
                                     kCIInputBackgroundImageKey:image,
                                     kCIInputImageKey:overlay
                                     };
        CIFilter *filter = [CIFilter filterWithName:@"CISourceOverCompositing" withInputParameters:parameters];
        return filter.outputImage;
    };
}

@end
