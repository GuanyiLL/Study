//
//  LoginViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/26.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "LoginViewController.h"
#import "CheckBox.h"
#import "HttpManager.h"
#import "UserDefault.h"
#import "WebViewController.h"

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
@property (nonatomic) UIView *verticalLine;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic) UIButton * userServiceButton;

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
    self.count = 60;
    [self loginButtonStatusCheck];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.titleLabel.frame = CGRectMake(20, CGRectGetMaxY(self.navigationController.navigationBar.frame) + 20, CGRectGetWidth(self.view.frame), 30);
    self.userNameTextField.frame = CGRectMake(60, CGRectGetMaxY(self.titleLabel.frame) + 22, CGRectGetWidth(self.view.frame) - 60 - 20, 40);
    self.passwordTextField.frame = CGRectMake(CGRectGetMinX(self.userNameTextField.frame), CGRectGetMaxY(self.userNameTextField.frame) + 2, CGRectGetWidth(self.view.frame) - 60 - 20 - 100, 40);
    
    self.checkBox.frame = CGRectMake(20, CGRectGetMaxY(self.passwordTextField.frame) + 22, 80, 20);
    self.userServiceButton.frame = CGRectMake(CGRectGetMaxX(self.checkBox.frame) + 5, CGRectGetMinY(self.checkBox.frame), 50, 20);
    
    self.loginButton.frame = CGRectMake(20, CGRectGetMaxY(self.checkBox.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40);
    
    self.verifyCodeButton.frame = CGRectMake(CGRectGetMaxX(self.passwordTextField.frame) +20, CGRectGetMinY(self.passwordTextField.frame), 80, 40);
    
    self.verticalLine.frame = CGRectMake(CGRectGetMinX(self.verifyCodeButton.frame) - 10, CGRectGetMinY(self.passwordTextField.frame) + 4, 2, 32);
    
    for (NSInteger idx = 0; idx < self.separaters.count; idx++) {
        UIView *separater = self.separaters[idx];
        separater.frame = CGRectMake(20, 20 + idx * 42 + CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.view.frame) - 40, 2);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark- Actions

- (void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginAction:(id)sender {
    [HttpManager requestLoginWithParameter:@{@"tel":self.userNameTextField.text,@"checkCode":self.passwordTextField.text} success:^(NSString *token) {
        [UserDefault saveLoginToken:token];
        [UserDefault savePhoneNumber:self.userNameTextField.text];
        [self close:nil];
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
}

- (void)requestVerifyCode:(id)sender {
    [HttpManager requestVerifyCodeWithParameter:@{@"tel":self.userNameTextField.text} success:^(void) {
        [KQBToastView show:@"短信验证码已发送！"];
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
    [self.timer fire];
    [self.verifyCodeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)refreshTime:(id)sender {
    if (self.count < 0) {
        [self.timer invalidate];
        [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verifyCodeButton setTitleColor:[UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1] forState:UIControlStateNormal];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.verifyCodeButton setTitle:[NSString stringWithFormat:@"%zds",self.count--] forState:UIControlStateNormal];
    });
}

#pragma mark- Method

- (void)loginButtonStatusCheck {
    self.loginButton.isDisable = !(self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0 && self.checkBox.isSelected);
    self.verifyCodeButton.userInteractionEnabled = self.userNameTextField.text.length > 0;
}

- (void)showUserServiceController:(id)sender {
    WebViewController *web = [[WebViewController alloc] init];
    web.url = [NSString stringWithFormat:@"%@/user-agreement.html",[HttpManager h5Host]];
    [self.navigationController pushViewController:web animated:YES];
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

- (UIButton *)verifyCodeButton {
    if (_verifyCodeButton) {
        return _verifyCodeButton;
    }
    _verifyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyCodeButton setTitleColor:[UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1] forState:UIControlStateNormal];
    [_verifyCodeButton addTarget:self action:@selector(requestVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    _verifyCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_verifyCodeButton];
    return _verifyCodeButton;
}

- (UIView *)verticalLine {
    if (_verticalLine) {
        return _verticalLine;
    }
    _verticalLine = [[UIView alloc] init];
    _verticalLine.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    [self.view addSubview:_verticalLine];
    return _verticalLine;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshTime:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UIButton *)userServiceButton {
    if (_userServiceButton) {
        return _userServiceButton;
    }
    _userServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userServiceButton setTitleColor:[UIColor colorWithRed:124/255.0 green:170/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [_userServiceButton setTitle:@"《用户服务协议》" forState:UIControlStateNormal];
    _userServiceButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_userServiceButton addTarget:self action:@selector(showUserServiceController:) forControlEvents:UIControlEventTouchUpInside];
    return _userServiceButton;
}

@end
