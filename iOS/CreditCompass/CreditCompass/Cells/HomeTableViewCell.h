//
//  HomeTableViewCell.h
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product;

@interface HomeTableViewCell : UITableViewCell

- (void)refreshCellWithData:(Product *)product;

@end
