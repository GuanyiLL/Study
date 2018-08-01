//
//  BlackListInspectViewController.m
//  CreditCompass
//
//  Created by Guanyi on 2018/7/30.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "BlackListInspectViewController.h"
#import "CheckBox.h"
#import "UnderlineTextField.h"
#import "HttpManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Product.h"
#import "WaitingViewController.h"
#import "WebViewController.h"

@interface BlackListInspectViewController ()

@property (nonatomic) UnderlineTextField *userNameTextField;
@property (nonatomic) UnderlineTextField *identifyTextField;
@property (nonatomic) UnderlineTextField *phoneNumberTextField;
@property (nonatomic) UnderlineTextField *bankCardTextField;

@end

@implementation BlackListInspectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _userNameTextField = [[UnderlineTextField alloc] init];
    _userNameTextField.placeholder = @"请输入您的真实姓名";
    _userNameTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"account"]];
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_userNameTextField];
    _userNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    _identifyTextField = [[UnderlineTextField alloc] init];
    _identifyTextField.placeholder = @"请输入有效的身份证号";
    _identifyTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"bank_bill"]];
    _identifyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_identifyTextField];
    _identifyTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    _phoneNumberTextField = [[UnderlineTextField alloc] init];
    _phoneNumberTextField.placeholder = @"请输入您的手机号";
    _phoneNumberTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"bank_phone"]];
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneNumberTextField];
    _phoneNumberTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    _bankCardTextField = [[UnderlineTextField alloc] init];
    _bankCardTextField.placeholder = @"请输入您的银行卡号";
    _bankCardTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"bank_bill"]];
    _bankCardTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_bankCardTextField];
    _bankCardTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/img/slide3.png",[HttpManager h5Host]]]];
    self.checkBox.isSelected = YES;
    [self didTapCheckBox];
    
    [self.protocolButton setTitle:@"《黑名单数据解析协议》" forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) / 3);
    
    _userNameTextField.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 30);
    
    _identifyTextField.frame = CGRectMake(20, CGRectGetMaxY(_userNameTextField.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 30);
    
    _phoneNumberTextField.frame = CGRectMake(20, CGRectGetMaxY(_identifyTextField.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 30);
    
    _bankCardTextField.frame = CGRectMake(20, CGRectGetMaxY(_phoneNumberTextField.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 30);
    
    self.checkBox.frame = CGRectMake(20, CGRectGetMaxY(_bankCardTextField.frame) + 30, 50, 20);
    self.protocolButton.frame = CGRectMake(CGRectGetMaxX(self.checkBox.frame) + 5, CGRectGetMinY(self.checkBox.frame), 150, 20);
    self.inspectButton.frame = CGRectMake(20, CGRectGetMaxY(self.checkBox.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didTapCheckBox {
    [self buttonStatusCheck];
}

- (void)buttonStatusCheck {

    self.inspectButton.isDisable = _userNameTextField.text.length == 0 || _identifyTextField.text.length == 0 || _phoneNumberTextField.text.length == 0 || _bankCardTextField.text.length == 0 || !self.checkBox.isSelected;
}

- (void)showProtocol:(id)sender {
    WebViewController *web = [[WebViewController alloc] init];
    web.url = [NSString stringWithFormat:@"%@/user-agreement.html",[HttpManager h5Host]];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- TextFieldDelegate

- (void)textDidChanged:(NSNotification *)no {
    [self buttonStatusCheck];
}

- (void)inspectAction:(id)sender {
    NSDictionary *param = @{
                            @"prodId":@(self.product.productID),
                            @"type":@(self.product.type),
                            @"payPrice":self.product.price,
                            @"tel":self.phoneNumberTextField.text,
                            @"totalPrice":self.product.originalPrice,
                            @"name":self.userNameTextField,
                            @"idCard":self.identifyTextField.text,
                            @"bankCard":self.bankCardTextField.text
                            };
    [HttpManager requestCreateOrder:param success:^(Order *order) {
        WaitingViewController *waiting = [[WaitingViewController alloc] init];
        waiting.order = order;
        [self.navigationController pushViewController:waiting animated:YES];
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
}

- (UIView *)textFieldLeftView:(UIImage *)image {
    UIView *container = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [container addSubview:imageView];
    container.frame = CGRectMake(5, 5, 20, 20);
    imageView.frame = container.bounds;
    return container;
}

@end
