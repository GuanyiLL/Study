//
//  HomeTableViewCell.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/29.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Product.h"

@interface HomeTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.container.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.container.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.container.layer.shadowOpacity = 0.5;//不透明度
    self.container.layer.shadowRadius = 10.0;//半径
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)refreshCellWithData:(Product *)product {
    if (product.type == 0) {
        self.imgView.image = [UIImage imageNamed:@"icon_identity_realname"];
    } else if(product.type ==1) {
        self.imgView.image = [UIImage imageNamed:@"icon_identity_faceverify"];
    }
    self.titleLabel.text = product.name;
    self.detailTitleLabel.text = product.productDescription;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",product.price];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"原价¥%@", product.originalPrice];
    self.countLabel.text = [NSString stringWithFormat:@"已有%@人完成检测",product.count];
}

@end
