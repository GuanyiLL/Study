//
//  AccountViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "AccountViewController.h"
#import "SettingTableViewCell.h"
#import "UserDefault.h"
#import "HttpManager.h"
#import "WebViewController.h"

@interface AccountViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSArray *> *dataSource;


@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.tableView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

- (void)logoutAction:(id)sender {
    [HttpManager requestLogOut:nil success:^{
        [UserDefault removeToken];
        self.tabBarController.selectedIndex = 0;
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        WebViewController *web = [[WebViewController alloc] init];
        web.url = [NSString stringWithFormat:@"%@/user-agreement.html",[HttpManager h5Host]];
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1, 1)];
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    return _tableView;
}

- (UIImageView *)tableHeaderView {
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140)];
    header.image = [UIImage imageNamed:@"bg_setting_banner"];
    header.userInteractionEnabled = YES;
    UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(header.frame) / 2 - 60/2, 20, 60, 60)];
    avatar.layer.cornerRadius = 30;
    avatar.image = [UIImage imageNamed:@"icon_login_logo"];
    [header addSubview:avatar];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(avatar.frame) + 10, CGRectGetWidth(header.frame), 20)];
    [header addSubview:phoneLabel];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.text = [UserDefault phoneNumber];
    phoneLabel.textColor = [UIColor whiteColor];
    
    UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logOutButton setTitle:@"退出" forState:UIControlStateNormal];
    [logOutButton setImage:[UIImage imageNamed:@"icon_logout"] forState:UIControlStateNormal];
    [logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logOutButton.frame = CGRectMake(CGRectGetWidth(header.frame) - 60 - 20, 20, 60, 20);
    [logOutButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    [logOutButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 42)];
    [logOutButton setTintColor:[UIColor whiteColor]];
    [logOutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:logOutButton];
    
    return header;
}

- (NSArray<NSArray *> *)dataSource {
    return @[@[@"用户服务协议"],
             @[@"意见反馈",@"关于我们"]];
}
@end
