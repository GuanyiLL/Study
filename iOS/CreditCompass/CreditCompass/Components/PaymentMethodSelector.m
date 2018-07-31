//
//  PaymentMethodSelector.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/31.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "PaymentMethodSelector.h"
#import "PaymentMethodSelectorCell.h"

@interface PaymentMethodSelector() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@end

@implementation PaymentMethodSelector

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.methods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentMethodSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:[PaymentMethodSelectorCell reuseableIdentifier]];
    [cell refreshCell:self.methods[indexPath.row]];
    cell.isSelected = indexPath.row == self.selectedIndex;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerNib:[UINib nibWithNibName:@"PaymentMethodSelectorCell" bundle:nil] forCellReuseIdentifier:[PaymentMethodSelectorCell reuseableIdentifier]];
    [self addSubview:_tableView];
    return _tableView;
}

@end
