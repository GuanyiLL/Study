//
//  KQBToastView.h
//  KQBusiness
//
//  Created by xy on 2016/10/24.
//  Copyright © 2016年 xy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KQBToastView : NSObject

/**
 显示toast
 
 @param tip 待toast的消息
 */
+ (void)show:(NSString *)tip;

/**
 显示toast
 
 @param tip  待toast的消息
 @param time toast展示时间
 */
+ (void)show:(NSString *)tip time:(CGFloat)time;


@end
