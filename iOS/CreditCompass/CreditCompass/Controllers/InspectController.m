//
//  InspectController.m
//  CreditCompass
//
//  Created by Guanyi on 2018/7/30.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "InspectController.h"
#import "UploadContactViewController.h"
#import "BlackListInspectViewController.h"
#import "CheckBox.h"

@interface InspectController () <CheckBoxDelegate>



@end

@implementation InspectController

+ (instancetype)inspectWithType:(InspectControllerType)type product:(Product *)product {
    switch (type) {
        case InspectControllerTypeContact:
        {
             UploadContactViewController *contact = [[UploadContactViewController alloc] init];
            contact.product = product;
            return contact;
        }
        case InspectControllerTypeBlacklist:
        {
           BlackListInspectViewController *black = [[BlackListInspectViewController alloc] init];
            black.product = product;
            return black;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)inspectAction:(id)sender {
    // overwrite for subclass
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    [self.view addSubview:_imageView];
    return _imageView;
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

- (UIButton *)inspectButton {
    if (_inspectButton) {
        return _inspectButton;
    }
    _inspectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_inspectButton setTitle:@"立即检测" forState:UIControlStateNormal];
    _inspectButton.isDisable = YES;
    [_inspectButton addTarget:self action:@selector(inspectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_inspectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _inspectButton.layer.cornerRadius = 4;
    [self.view addSubview:_inspectButton];
    return _inspectButton;
}

@end
