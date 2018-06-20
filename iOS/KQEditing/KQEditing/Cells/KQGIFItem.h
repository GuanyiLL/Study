//
//  KQGIFItem.h
//  KQEditing
//
//  Created by Guanyi on 2018/6/19.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQItem.h"

typedef void (^ItemDidTap) (NSInteger idx);

@interface KQGIFItem : KQItem

@property (nonatomic) NSInteger index;

@property (nonatomic,copy) ItemDidTap didSelectIndex;

- (void)kq_selected:(BOOL)selected;

@end
