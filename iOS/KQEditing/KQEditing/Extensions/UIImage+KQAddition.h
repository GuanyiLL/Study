//
//  UIImage+KQKQAddition.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/24.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KQAddition)

+ (UIImage *)imageFromView:(UIView *)view;

+ (UIImage *)imageWithView:(UIView *)view scope:(CGRect)scope;

- (CGRect)getFrameInImageView:(UIImageView *)imageView;

@end
