//
//  PageControl.h
//  PageControl
//
//  Created by Guanyi on 2018/6/14.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIControl

@property(nonatomic) NSInteger numberOfPages;          // default is 0
@property(nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property(nonatomic) UIColor *pageIndicatorTintColor;
@property(nonatomic) UIColor *pageIndicatorBorderColor;

@property(nonatomic) UIColor *currentPageIndicatorTintColor;

@end
