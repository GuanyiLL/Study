//
//  UIImage+KQKQAddition.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/24.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "UIImage+KQAddition.h"

@implementation UIImage (KQAddition)
    
+ (UIImage *)imageFromView:(UIView *)view {
    CGSize orgSize = view.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, view.layer.contentsScale * [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    return image ;
}

+ (UIImage *)imageWithView:(UIView *)view scope:(CGRect)scope {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    
    CGRect rect = scope;
    rect.origin.x       *= scale;
    rect.origin.y       *= scale;
    rect.size.width     *= scale;
    rect.size.height    *= scale;
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGRect myImageRect = rect;
    CGImageRef imageRef = image.CGImage;
    imageRef = CGImageCreateWithImageInRect(imageRef,myImageRect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, imageRef);
    UIImage* finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return finalImage;
}

- (CGRect)getFrameInImageView:(UIImageView *)imageView {
    CGFloat hfactor = self.size.width / imageView.frame.size.width;
    CGFloat vfactor = self.size.height / imageView.frame.size.height;
    
    CGFloat factor = fmax(hfactor, vfactor);
    
    CGFloat newWidth = self.size.width / factor;
    CGFloat newHeight = self.size.height / factor;
    
    CGFloat leftOffset = (imageView.frame.size.width - newWidth) / 2;
    CGFloat topOffset = (imageView.frame.size.height - newHeight) / 2;
    
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}

@end
