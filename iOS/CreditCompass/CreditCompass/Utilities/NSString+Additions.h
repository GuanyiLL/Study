//
//  NSString+Additions.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)


/**
 去掉空格
 
 @return 无空格字符串
 */
- (NSString *)trim;

/**
 url编码
 
 @return 编码结果
 */
- (NSString *)kqc_urlEncodedString;

/**
 url解码
 
 @return 解码结果
 */
- (NSString *)kqc_urlDecodedString;

/**
 判断空字符串
 
 @param string 目标字符串
 @return YES:空 NO:不空
 */
+ (BOOL)kqc_isBlank:(NSString *)string;

/**
 计算字符串大小
 
 @param str 目标字符串
 @param font 指定字体
 @param lineBreakMode 换行方式
 @param size 最大高宽
 @return 字符串高宽
 */
+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxSize:(CGSize)size;

/**
 计算字符串大小
 
 @param str 目标字符串
 @param font 指定字体
 @param paragraphStyle 字符串格式
 @param size 最大高宽
 @return 字符串高宽
 */
+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font lineBreakStyle:(NSMutableParagraphStyle *)paragraphStyle maxSize:(CGSize)size;

/**
 计算字符串大小
 
 @param str 目标字符串
 @param font 指定字体
 @param maxWidth 最大宽度
 @return 字符串高宽
 */
+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/**
 计算字符串大小，换行格式为NSLineBreakByWordWrapping
 
 @param str 目标字符串
 @param font 指定字体
 @param maxSize 最大高宽
 @return 字符串高宽
 */
+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 计算字符串大小
 
 @param str 目标字符串
 @param font 指定字体
 @return 字符串高宽
 */
+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font;


@end
