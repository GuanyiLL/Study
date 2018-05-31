//
//  KQFilterCoordinator.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/21.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQFilterCoordinator.h"
#import "KQFIlter.h"

NSInteger const kFiltersCount = 7;

@implementation KQFilterCoordinator

+ (UIImage *)filterType:(KQFilterType)type inputImage:(UIImage *)inputImage {
    inputImage = [self fixOrientation:inputImage];
    CIImage *input = [CIImage imageWithCGImage:inputImage.CGImage];
    CIImage *output = nil;
    switch (type) {
        case KQFilterTypeNone:
            output = input;
            break;
        case KQFilterTypeEffectTransfer:
            output = [KQFIlter photoEffectTransfer](input);
            break;
        case KQFilterTypeEffectTonal:
            output = [KQFIlter photoEffectTonal](input);
            break;
        case KQFilterTypeEffectProcess:
            output = [KQFIlter photoEffectProcess](input);
            break;
        case KQFilterTypeEffectInstant:
            output = [KQFIlter photoEffectInstant](input);
            break;
        case KQFilterTypeGaussianBlur:
            output = [KQFIlter blur:20 imageSize:inputImage.size](input);
            break;
        case KQFilterTypeSepiaTone:
            output = [KQFIlter sepiaTone](input);
            break;
    }
    CGRect rect             = [output extent];
    rect.origin.x          += (rect.size.width  - inputImage.size.width ) / 2;
    rect.origin.y          += (rect.size.height - inputImage.size.height) / 2;
    rect.size               = inputImage.size;
    
    CIContext *context      = [CIContext contextWithOptions:nil];
    CGImageRef cgimg        = [context createCGImage:output fromRect:rect];
    UIImage *resImage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return resImage;
}


/**
 修复图片转向问题，CIFilter编辑图片后，使图片EXIF信息丢失

 @param aImage 传入图片
 @return 修正转向问题后的图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
