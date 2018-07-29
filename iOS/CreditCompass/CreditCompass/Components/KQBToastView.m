//
//  KQBToastView.m
//  KQBusiness
//
//  Created by xy on 2016/10/24.
//  Copyright © 2016年 xy. All rights reserved.
//

#import "KQBToastView.h"

@implementation KQBToastView

+ (void)show:(NSString *)tip{
    [KQBToastView show:tip time:2.0f];
}

+ (void)show:(NSString *)tip time:(CGFloat)time{
    if (time < 0) {
        time = 2.0f;
    }
    
    UIWindow *window = [self progressViewParentWindow];
    [KQBToastView showTip:tip onView:window withTime:time];
//    if ([NSStringFromClass([KQ_TopWindow class]) isEqualToString:@"UIRemoteKeyboardWindow"]) {
//        [KQBToastView show:tip onView:KQ_TopWindow withTime:time];
//    }
}
+ (void)showTip:(NSString *)tip onView:(UIView *)parentView withTime:(CGFloat)time{
    UIFont *font = [UIFont systemFontOfSize:17.0f];
    float textSizeWith = 150.0f;
    CGSize textSize = [NSString kqc_calcStrSize:tip font:font lineBreakMode:NSLineBreakByWordWrapping maxSize:CGSizeMake(textSizeWith, MAXFLOAT)];
    
    textSize.width = textSizeWith;
    if (textSize.height < 40.0f) {
        textSize.height = 40.0f;
    }
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, textSize.width + 12, textSize.height + 12)];
    [tipLabel setText:tip];
    [tipLabel setNumberOfLines:0];
    [tipLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setBackgroundColor:[UIColor clearColor]];
    [tipLabel setTextColor:[UIColor whiteColor]];
    
    UIButton *contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tipLabel.frame.size.width+20, tipLabel.frame.size.height)];
    contentView.layer.cornerRadius = 5.0f;
    contentView.layer.borderWidth = 1.0f;
    contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                  green:0.2f
                                                   blue:0.2f
                                                  alpha:0.75f];
    [contentView addSubview:tipLabel];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    contentView.alpha = 0.0f;
    [parentView addSubview:contentView];
    contentView.center = parentView.center;
    
    time -= 0.2f;
    [UIView animateWithDuration:0.5f
                     animations:^{ contentView.alpha = 1; }
                     completion:^(BOOL finished){
                         [NSTimer scheduledTimerWithTimeInterval:time
                                                          target:self
                                                        selector:@selector(hideTip:)
                                                        userInfo:contentView
                                                         repeats:NO];
                     }];
}

+ (void)hideTip:(NSTimer *)timer{
    UIImageView *flashTipView = (UIImageView *)[timer userInfo];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         flashTipView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [flashTipView removeFromSuperview];
                     }];
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

+ (UIWindow *)progressViewParentWindow{
    __block UIWindow *window = nil;
    [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"UIRemoteKeyboardWindow"]) {
            return;
        }
        window = obj;
        *stop = YES;
    }];
    if (!window) {
        window = TOP_WINDOW;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

@end
