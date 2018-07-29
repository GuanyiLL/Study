//
//  NSString+Additions.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)


- (NSString *)trim{
    if ([NSString kqc_isBlank:self]){
        return @"";
    }
    
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)kqc_urlEncodedString{
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge  NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}

- (NSString*)kqc_urlDecodedString{
    CFStringRef decodedCFString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef) self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
    // We need to replace "+" with " " because the CF method above doesn't do it
    NSString *decodedString = [[NSString alloc] initWithString:(__bridge NSString*) decodedCFString];
    return (!decodedString) ? @"" : [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

+ (BOOL)kqc_isBlank:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string caseInsensitiveCompare:@"null"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    return [NSString kqc_calcStrSize:str font:font maxSize:CGSizeMake(maxWidth, MAXFLOAT)];
}

+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize{
    if ([NSString kqc_isBlank:str]) {
        return CGSizeZero;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)) {
        paragraphStyle.lineSpacing = 5;
    }
    
    return [NSString kqc_calcStrSize:str font:font lineBreakStyle:paragraphStyle maxSize:(CGSize){maxSize.width, maxSize.height}];
}

+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode maxSize:(CGSize)size
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    return [NSString kqc_calcStrSize:str font:font lineBreakStyle:paragraphStyle maxSize:size];
}

#pragma mark - 计算str的大小，最终设置，font和lineBreakStyle都可以为nil
+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font lineBreakStyle:(NSMutableParagraphStyle*)paragraphStyle maxSize:(CGSize)size
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    if (font) {
        [attrDict setObject:font forKey:NSFontAttributeName];
    }
    if (paragraphStyle) {
        [attrDict setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:str
                                                                         attributes:attrDict];
    CGRect rect = [attributedText boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               context:nil];
    return rect.size;
}

+ (CGSize)kqc_calcStrSize:(NSString *)str font:(UIFont *)font
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    if (font) {
        [attrDict setObject:font forKey:NSFontAttributeName];
    }
    return [str sizeWithAttributes:attrDict];
}

@end
