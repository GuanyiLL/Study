//
//  KQSelector.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQSelector.h"

CGFloat const kItemSizeWidth = 80;
CGFloat const kItemSizeHeight = 80;

@implementation KQSelector

+ (instancetype)selectorWithCompletion:(void(^)(NSInteger idx))completion {
    return [[self alloc] initWithCompletion:completion];
}

- (instancetype)initWithCompletion:(void(^)(NSInteger idx))completion {
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selector.frame = self.bounds;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kItemSizeWidth, kItemSizeHeight);
}

#pragma mark- Getter

- (UICollectionView *)selector {
    if (_selector) {
        return _selector;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    _selector = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _selector.backgroundColor = [UIColor whiteColor];
    _selector.delegate = self;
    _selector.dataSource = self;
    _selector.showsHorizontalScrollIndicator = NO;
    [self addSubview:_selector];
    return _selector;
}

@end
