//
//  KQFilterItem.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/18.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQFilterItem.h"
#import "KQFIlter.h"
#import "KQFilterCoordinator.h"

@implementation KQFilterItem 

- (void)layoutSubviews {
    self.imageView.frame = self.bounds;
}

- (void)kq_selected:(BOOL)isSelected {
    if (isSelected) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void)applyFilterAttributesWithIndexPath:(NSIndexPath *)indexPath {
    self.imageView.image = [KQFilterCoordinator filterType:indexPath.row inputImage:[UIImage imageNamed:@"filterDefault"]];
}



@end
