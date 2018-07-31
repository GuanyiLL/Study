//
//  UploadContactViewController.m
//  CreditCompass
//
//  Created by Guanyi on 2018/7/30.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "UploadContactViewController.h"
#import <SDCycleScrollView.h>
#import "CheckBox.h"
#import "Product.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HttpManager.h"
#import <Contacts/Contacts.h>
#import "UserDefault.h"
#import "WaitingViewController.h"
#import "WebViewController.h"

@interface UploadContactViewController ()<CheckBoxDelegate>

@property (nonatomic) NSMutableArray *allContacts;

@end

@implementation UploadContactViewController

+ (instancetype)inspectWithProduct:(Product *)product {
    UploadContactViewController *upload = [[[self class] alloc] init];
    return upload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allContacts = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/img/slide2.png",[HttpManager h5Host]]]];
    self.checkBox.isSelected = YES;
    [self didTapCheckBox];
    [self.protocolButton setTitle:@"《通讯录数据解析协议》" forState:UIControlStateNormal];
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [self loadAllContactsWithStatus];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else if(authorizationStatus == CNAuthorizationStatusAuthorized) {
        [self loadAllContactsWithStatus];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.imageView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) / 3);
    self.checkBox.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 20, 50, 20);
    self.protocolButton.frame = CGRectMake(CGRectGetMaxX(self.checkBox.frame) + 5, CGRectGetMinY(self.checkBox.frame), 150, 20);
    self.inspectButton.frame = CGRectMake(20, CGRectGetMaxY(self.checkBox.frame) + 20, CGRectGetWidth(self.view.frame) - 40, 40);
}

- (void)loadAllContactsWithStatus {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus != CNAuthorizationStatusAuthorized) {
        NSLog(@"没有授权...");
    }
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *newNumber = @"";
            if ([phoneNumber.stringValue containsString:@"-"]) {
                newNumber = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
            } else {
                newNumber = [phoneNumber.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            [self.allContacts addObject:@{@"name":[NSString stringWithFormat:@"%@%@",familyName,givenName],
                                              @"tel":newNumber}];
        }
    }];
}

- (void)inspectAction:(id)sender {
    [HttpManager requestContactUpload:@{@"contacts":self.allContacts} success:^{
        [self createOrders];
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
}

- (void)createOrders {
    NSDictionary *param = @{
                            @"prodId":@(self.product.productID),
                            @"type":@(self.product.type),
                            @"payPrice":self.product.price,
                            @"totalPrice":self.product.originalPrice
                            };
    [HttpManager requestCreateOrder:param success:^(Order *order) {
        WaitingViewController *waiting = [[WaitingViewController alloc] init];
        waiting.order = order;
        [self.navigationController pushViewController:waiting animated:YES];
    } failure:^(NSString *errorMessage) {
        [KQBToastView show:errorMessage];
    }];
}

- (void)didTapCheckBox {
    self.inspectButton.isDisable = !self.checkBox.isSelected;
}

- (void)showProtocol:(id)sender {
    WebViewController *web = [[WebViewController alloc] init];
    web.url = [NSString stringWithFormat:@"%@/user-agreement.html",[HttpManager h5Host]];
    [self.navigationController pushViewController:web animated:YES];
}


@end
