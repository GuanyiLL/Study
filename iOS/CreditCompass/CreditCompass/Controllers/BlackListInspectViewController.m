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

@interface BlackListInspectViewController ()

@property (nonatomic) UnderlineTextField *userNameTextField;
@property (nonatomic) UnderlineTextField *identifyTextField;
@property (nonatomic) UnderlineTextField *phoneNumberTextField;

@end

@implementation BlackListInspectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userNameTextField = [[UnderlineTextField alloc] init];
    _userNameTextField.placeholder = @"请输入您的真实姓名";
    _userNameTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"bank_phone"]];
    _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_userNameTextField];
    
    _identifyTextField = [[UnderlineTextField alloc] init];
    _identifyTextField.placeholder = @"请输入有效的身份证号";
    _identifyTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"bank_phone"]];
    _identifyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_identifyTextField];
    
    _phoneNumberTextField = [[UnderlineTextField alloc] init];
    _phoneNumberTextField.placeholder = @"请输入您的手机号";
    _phoneNumberTextField.leftView = [self textFieldLeftView:[UIImage imageNamed:@"bank_phone"]];
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneNumberTextField];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/img/slide3.png",[HttpManager h5Host]]]];
    self.checkBox.isSelected = YES;
    [self didTapCheckBox];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) / 3);
    
    _userNameTextField.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 10, CGRectGetWidth(self.view.frame) - 40, 30);
    
    _identifyTextField.frame = CGRectMake(20, CGRectGetMaxY(_userNameTextField.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 30);
    
    _phoneNumberTextField.frame = CGRectMake(20, CGRectGetMaxY(_identifyTextField.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 30);
    
    self.checkBox.frame = CGRectMake(20, CGRectGetMaxY(_phoneNumberTextField.frame) + 30, 80, 20);
    self.inspectButton.frame = CGRectMake(20, CGRectGetMaxY(self.checkBox.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40);
}

- (void)didTapCheckBox {
    self.inspectButton.isDisable = !self.checkBox.isSelected;
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
