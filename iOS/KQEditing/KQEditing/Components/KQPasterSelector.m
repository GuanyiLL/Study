//
//  KQPasterSelector.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQPasterSelector.h"
#import "KQItem.h"
#import "KQPasterCoordinator.h"

@implementation KQPasterSelector

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KQItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[KQItem reuseIdentifier] forIndexPath:indexPath];
    item.imageView.image = [KQPasterCoordinator sharedInstance].pasters[indexPath.row];
    return item;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [KQPasterCoordinator sharedInstance].pasters.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Select paster :[%zd]",indexPath.row);
    self.completion(indexPath.row);
}

#pragma mark- Getter

- (UICollectionView *)selector {
    UICollectionView *selector = [super selector];
    [selector registerClass:[KQItem class] forCellWithReuseIdentifier:[KQItem reuseIdentifier]];
    return selector;
}

@end
