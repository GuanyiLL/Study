//
//  KQGIFItem.m
//  KQEditing
//
//  Created by Guanyi on 2018/6/19.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQGIFItem.h"

@implementation KQGIFItem {
    BOOL _isSelected;
}

- (void)layoutSubviews {
    self.imageView.frame = self.bounds;
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
}

- (void)didTap:(UIGestureRecognizer *)gesture {
    [self kq_selected:YES];
    if (self.didSelectIndex) {
        self.didSelectIndex(self.index);
    }
}

- (void)kq_selected:(BOOL)selected {
    _isSelected = selected;
    self.imageView.layer.borderColor = selected ? [UIColor redColor].CGColor : [UIColor whiteColor].CGColor;
}

- (UIImageView *)imageView {
    UIImageView *a = super.imageView;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [a addGestureRecognizer:gesture];
    a.layer.borderWidth = 2;
    a.clipsToBounds = YES;
    a.userInteractionEnabled = YES;
    return a;
}

@end
