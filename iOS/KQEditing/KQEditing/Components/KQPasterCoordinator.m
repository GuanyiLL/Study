//
//  KQPasterCoordinator.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQPasterCoordinator.h"
#import "KQPaster.h"
#import <UIKit/UIKit.h>

CGFloat const kPasterWidth = 100;
CGFloat const kPasterHeight = 130;
NSInteger const kPasterCount = 20;

@implementation KQPasterCoordinator {
    NSUInteger _pasterID;
    KQPaster *_editingPaster;
    KQPaster *_lastPaster;
}

# pragma mark- Lifecycle

+ (instancetype)sharedInstance {
    static KQPasterCoordinator *coordinator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coordinator = [[self alloc] init];
    });
    return coordinator;
}

#pragma mark- Method

- (void)addPasterWithIndex:(NSInteger )index container:(UIView *)container {
    KQPaster *paster = [[KQPaster alloc] init];
    paster.frame = CGRectMake(container.width / 2 - kPasterWidth / 2,
                              container.height / 2 - kPasterHeight / 2,
                              kPasterWidth,
                              kPasterHeight);
    paster.image = self.pasters[index];
    paster.editing = YES;
    paster.delegate = self;
    paster.pasterID = _pasterID++;
    [container addSubview:paster];
    [self didTapPaster:paster];
}

- (void)resetPasters {
    _editingPaster.editing = NO;
    _lastPaster = nil;
    _editingPaster = nil;
}

#pragma mark- KQPasterDelegate

- (void)removePaster:(KQPaster *)paster {
    _lastPaster = nil;
}

- (void)didTapPaster:(KQPaster *)paster {
    _editingPaster.editing = NO;
    _lastPaster = _editingPaster;
    paster.editing = YES;
    _editingPaster = paster;
}

#pragma mark- Getter

- (NSArray<UIImage *> *)pasters {
    NSMutableArray *pasters = [NSMutableArray array];
    for (NSInteger i = 0; i < kPasterCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sticker_%zd",i+1]];
        [pasters addObject:image];
    }
    return [pasters copy];
}

@end
