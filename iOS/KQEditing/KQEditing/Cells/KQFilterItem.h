//
//  KQFilterItem.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/18.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQItem.h"

@interface KQFilterItem : KQItem

- (void)kq_selected:(BOOL)isSelected;

- (void)applyFilterAttributesWithIndexPath:(NSIndexPath *)indexPath;

@end
