//
//  ViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "HomeViewController.h"
#import <SDCycleScrollView.h>
#import "HomeTableViewCell.h"
#import "HttpManager.h"
#import "KQBToastView.h"
#import "HomeBanner.h"
#import "Product.h"
#import "LoginManager.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray<Product *> *products;
@property (nonatomic) SDCycleScrollView *banner;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"信用查查";
    [self requestBanners];
    [self requestProducts];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.navigationController.navigationBar.frame),
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetMinY(self.tabBarController.tabBar.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)requestBanners {
    [HttpManager requestHomeBanner:nil success:^(NSArray<HomeBanner *> *banners) {
        NSArray<HomeBanner *> *newBanners = [banners sortedArrayUsingComparator:^NSComparisonResult(HomeBanner *obj1, HomeBanner *obj2) {
            return obj1.seq > obj2.seq;
        }];
        NSMutableArray *arr = [NSMutableArray array];
        for (HomeBanner *b in newBanners) {
            [arr addObject:b.url];
        }
        self.banner.imageURLStringsGroup = arr;
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
        self.banner = nil;
    }];
}

- (void)requestProducts {
    [HttpManager requestProducts:nil success:^(NSArray<Product *> *products) {
        self.products = products;
        [self.tableView reloadData];
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeTableViewCell reuseableIdentifier]];
    [cell refreshCellWithData:self.products[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([LoginManager hasLogined]) {
        
    } else {
        [LoginManager showLoginControlerWithParentController:self];
    }
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] init];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];
    _tableView.tableHeaderView = [self banner];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:[HomeTableViewCell reuseableIdentifier]];
    [self.view addSubview:_tableView];
    return _tableView;
}

- (SDCycleScrollView *)banner {
    if (_banner) {
        return _banner;
    }
    _banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.width / 3) delegate:nil placeholderImage:nil];
    return _banner;
}


@end
