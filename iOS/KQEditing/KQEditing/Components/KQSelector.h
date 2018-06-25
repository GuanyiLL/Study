//
//  KQSelector.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KQSelectorCompletion)(NSInteger idx);

@interface KQSelector : UIView

<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic) UICollectionView *selector;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy)  KQSelectorCompletion completion;

+ (instancetype)selectorWithCompletion:(KQSelectorCompletion)completion;
- (instancetype)initWithCompletion:(void(^)(NSInteger idx))completion;

- (NSInteger)itemCount;

@end
