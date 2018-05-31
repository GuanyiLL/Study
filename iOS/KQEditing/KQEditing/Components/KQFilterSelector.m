//
//  KQFilterSelector.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/18.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQFilterSelector.h"
#import "KQFilterItem.h"
#import "KQFilterCoordinator.h"

@implementation KQFilterSelector

#pragma mark- DataSource & Delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KQFilterItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[KQFilterItem reuseIdentifier] forIndexPath:indexPath];
    [item applyFilterAttributesWithIndexPath:indexPath];
    return item;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kFiltersCount;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KQFilterItem *cell = (KQFilterItem *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
    [cell kq_selected:NO];
    cell = (KQFilterItem *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell kq_selected:YES];
    self.selectedIndex = indexPath.row;
    self.completion(indexPath.row);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(KQFilterItem *)cell kq_selected:indexPath.row == self.selectedIndex];
}

- (UICollectionView *)selector {
    UICollectionView *selector = [super selector];
    [selector registerClass:[KQFilterItem class] forCellWithReuseIdentifier:[KQFilterItem reuseIdentifier]];
    return selector;
}

@end
