//
//  KQPaster.h
//  KQEditing
//
//  Created by Guanyi on 2018/5/23.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KQPaster;

@protocol KQPasterDelegate<NSObject>
@required
- (void)removePaster:(KQPaster *)paster;
- (void)didTapPaster:(KQPaster *)paster;
@end

@interface KQPaster : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) NSUInteger pasterID;
@property (nonatomic, weak) id<KQPasterDelegate> delegate;
@end


