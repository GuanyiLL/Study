//
//  LoginViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/26.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "LoginViewController.h"
#import "CheckBox.h"

@interface LoginViewController () <CheckBoxDelegate>

@property (nonatomic, copy) LoginViewControllerCompletionBlock completion;
@property (nonatomic) UITextField *userNameTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *verifyCodeButton;
@property (nonatomic) CheckBox *checkBox;
@property (nonatomic, copy) NSArray<UIView *> *separaters;
@property (nonatomic) UIView *closeButton;

@end

@implementation LoginViewController

#pragma mark- Lifecycle

- (instancetype)initWithLoginCompletion:(LoginViewControllerCompletionBlock)completion {
    self = [super init];
    if (self) {
        _completion = completion;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.titleLabel.frame = CGRectMake(20, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 20, CGRectGetWidth(self.view.frame), 30);
    self.userNameTextField.frame = CGRectMake(60, CGRectGetMaxY(self.titleLabel.frame) + 22, CGRectGetWidth(self.view.frame) - 60 - 20, 40);
    self.passwordTextField.frame = CGRectMake(CGRectGetMinX(self.userNameTextField.frame), CGRectGetMaxY(self.userNameTextField.frame) + 2, CGRectGetWidth(self.view.frame) - 60 - 20 - 80, 40);
    self.checkBox.frame = CGRectMake(20, CGRectGetMaxY(self.passwordTextField.frame) + 22, 80, 20);
    self.loginButton.frame = CGRectMake(20, CGRectGetMaxY(self.checkBox.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40);
    
    for (NSInteger idx = 0; idx < self.separaters.count; idx++) {
        UIView *separater = self.separaters[idx];
        separater.frame = CGRectMake(20, 20 + idx * 42 + CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.view.frame) - 40, 2);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Actions

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginAction:(id)sender {
    
}

#pragma mark- Method

- (void)loginButtonStatusCheck {
    self.loginButton.isDisable = !(self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0 && self.checkBox.isSelected);
}

#pragma mark- TextFieldDelegate

- (void)textDidChanged:(NSNotification *)no {
    [self loginButtonStatusCheck];
}

#pragma mark- CheckBoxDelegates

- (void)didTapCheckBox {
    [self loginButtonStatusCheck];
}

#pragma mark- Getter

- (UITextField *)userNameTextField {
    if (_userNameTextField) {
        return _userNameTextField;
    }
    _userNameTextField = [[UITextField alloc] init];
    _userNameTextField.placeholder = @"请输入手机号";
    _userNameTextField.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_userNameTextField];
    return _userNameTextField;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField) {
        return _passwordTextField;
    }
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.placeholder = @"请输入验证码";
    _passwordTextField.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_passwordTextField];
    return _passwordTextField;
}

- (CheckBox *)checkBox {
    if (_checkBox) {
        return _checkBox;
    }
    _checkBox = [[CheckBox alloc] initWithTitle:@"同意"];
    _checkBox.delegate = self;
    [self.view addSubview:_checkBox];
    return _checkBox;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"登陆 / 注册";
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_titleLabel];
    return _titleLabel;
}

- (UIButton *)loginButton {
    if (_loginButton) {
        return _loginButton;
    }
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    _loginButton.isDisable = YES;
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 4;
    [self.view addSubview:_loginButton];
    return _loginButton;
}

- (NSArray<UIView *> *)separaters {
    if (_separaters) {
        return _separaters;
    }
    NSMutableArray *container = [NSMutableArray array];
    for (NSInteger idx = 0; idx < 3; idx++) {
        UIView *separater = [[UIView alloc] init];
        separater.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
        [self.view addSubview:separater];
        [container addObject:separater];
    }
    _separaters = [container copy];
    return _separaters;
}

- (UIView *)closeButton {
    if (_closeButton) {
        return _closeButton;
    }
    _closeButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 10, 20, 20);
    [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"ic_title_close"] forState:UIControlStateNormal];
    [_closeButton addSubview:button];
    return _closeButton;
}

@end
