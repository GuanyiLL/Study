//
//  KQPasterCoordinator.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KQPaster.h"
@class UIImage, UIView;

@interface KQPasterCoordinator : NSObject <KQPasterDelegate>

@property (nonatomic, assign, readonly) NSInteger pasterCount;

+ (instancetype)sharedInstance;

- (void)addPasterWithIndex:(NSInteger )index container:(UIView *)container;
- (NSArray<UIImage *> *)pasters;
- (void)resetPasters;

@end
