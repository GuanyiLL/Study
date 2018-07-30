//
//  WaitingViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/30.
//  Copyright © 2018 ra1n. All rights reserved.
//

#import "WaitingViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"

@interface WaitingViewController ()

@property (nonatomic) UILabel *countingLabel;
@property (nonatomic) UIButton *payButton;
@property (nonatomic) UILabel *phoneNumber;
@property (nonatomic) NSMutableArray *paymentMethods;

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"等待支付";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    
    UIView *countingView = [[UIView alloc] init];
    countingView.backgroundColor = [UIColor colorWithRed:231/255.0 green:241/255.0 blue:252/255.0 alpha:1];
    countingView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), screenWith, 30);
    [self.view addSubview:countingView];
    
    _countingLabel = [[UILabel alloc] init];
    _countingLabel.textAlignment = NSTextAlignmentCenter;
    _countingLabel.text = @"请在15分00秒内完成支付";
    _countingLabel.textColor = [UIColor colorWithRed:80/255.0f green:151/255.0f blue:244/255.0f alpha:1];
    _countingLabel.frame = countingView.bounds;
    _countingLabel.font = [UIFont systemFontOfSize:13];
    [countingView addSubview:_countingLabel];
    
    UIView *reportContainer = [[UIView alloc] init];
    reportContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:reportContainer];
    
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake(20, 10, 4, 30);
    verticalLine.backgroundColor = [UIColor colorWithRed:46/255.0f green:132/255.0f blue:255/255.0f alpha:1];
    [reportContainer addSubview:verticalLine];
    
    UILabel *reportTitleLabel = [[UILabel alloc] init];
    if (self.order.type == 0) {
        reportTitleLabel.text = @"黑名单风险报告";
    } else {
        reportTitleLabel.text = @"通讯录风险报告";
    }
    reportTitleLabel.frame = CGRectMake(CGRectGetMaxX(verticalLine.frame) + 10, 10, screenWith - CGRectGetMaxX(verticalLine.frame) - 10 - 20, 30);
    [reportContainer addSubview:reportTitleLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    line.frame = CGRectMake(CGRectGetMinX(verticalLine.frame), CGRectGetMaxY(verticalLine.frame) + 10, screenWith - 40, 2);
    [reportContainer addSubview:line];
    
    UILabel *reportNumber = [self createLabel:@"报告号:"];
    reportNumber.frame = CGRectMake(20, CGRectGetMaxY(line.frame) + 20, 100, 20);
    [reportContainer addSubview:reportNumber];
    
    UILabel *reportNumberValue = [self createLabel:self.order.outTradeno];
    reportNumberValue.frame = CGRectMake(100, CGRectGetMinY(reportNumber.frame), screenWith - 120, 20);
    [reportContainer addSubview:reportNumberValue];
    
    if (self.order.prodId == 0) {
        UILabel *name = [self createLabel:@"姓名:"];
        name.frame = CGRectMake(20, CGRectGetMaxY(reportNumber.frame) + 10, 100, 20);
        [reportContainer addSubview:name];
        
        UILabel *nameValue = [self createLabel:self.order.name];
        nameValue.frame = CGRectMake(100, CGRectGetMinY(name.frame), screenWith - 120, 20);
        [reportContainer addSubview:nameValue];
        
        UILabel *identify = [self createLabel:@"身份证:"];
        identify.frame = CGRectMake(20, CGRectGetMaxY(name.frame) + 10, 100, 20);
        [reportContainer addSubview:identify];
        
        UILabel *identifyValue = [self createLabel:self.order.idCard];
        identifyValue.frame =  CGRectMake(100, CGRectGetMinY(identifyValue.frame), screenWith - 120, 20);
        [reportContainer addSubview:identifyValue];
        
        _phoneNumber = [self createLabel: @"手机号:"];
        _phoneNumber.frame = CGRectMake(20, CGRectGetMaxY(identify.frame) + 10, 100, 20);
        [reportContainer addSubview:_phoneNumber];
        
        UILabel *phoneNumberValue = [self createLabel:self.order.tel];
        phoneNumberValue.frame = CGRectMake(100, CGRectGetMinY(_phoneNumber.frame), screenWith - 120, 20);
        [reportContainer addSubview:phoneNumberValue];
    }
    
    UILabel *reportTime = [self createLabel:@"检测时间:"];
    if (self.order.type == 0) {
        reportTime.frame = CGRectMake(20, CGRectGetMaxY(_phoneNumber.frame) + 10, 100, 20);
    } else {
        reportTime.frame = CGRectMake(20, CGRectGetMaxY(reportNumber.frame) + 10, 100, 20);
    }
    [reportContainer addSubview:reportTime];
    
    UILabel *reportTimeValue = [self createLabel:self.order.orderTimeStr];
    reportTimeValue.frame = CGRectMake(100, CGRectGetMinY(reportTime.frame), screenWith - 120, 20);
    [reportContainer addSubview:reportTimeValue];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    line.frame = CGRectMake(CGRectGetMinX(reportTime.frame), CGRectGetMaxY(reportTime.frame) + 20, screenWith - 40, 2);
    [reportContainer addSubview:line];
    
    UILabel *amount = [self createLabel:@"支付金额 "];
    amount.frame = CGRectMake(20, CGRectGetMaxY(line.frame) + 20, CGRectGetWidth(amount.frame), CGRectGetHeight(amount.frame));
    [reportContainer addSubview:amount];
    
    UILabel *amountValue = [[UILabel alloc] init];
    amountValue.frame = CGRectMake(0, CGRectGetMinY(reportNumber.frame), 200, 20);
    amountValue.text = [NSString stringWithFormat:@"¥%@", self.order.payPrice];
    amountValue.textColor = [UIColor colorWithRed:258/255.0 green:116/255.0 blue:106/255.0 alpha:1];
    amountValue.font = [UIFont systemFontOfSize:15];
    [amountValue sizeToFit];
    
    amountValue.frame = CGRectMake(screenWith - CGRectGetWidth(amountValue.frame) - 20, CGRectGetMaxY(line.frame) + 20, CGRectGetWidth(amountValue.frame), CGRectGetHeight(amountValue.frame));
    
    [reportContainer addSubview:amountValue];
    reportContainer.frame = CGRectMake(0, CGRectGetMaxY(countingView.frame) + 20, screenWith, CGRectGetMaxY(amountValue.frame) + 20);
    
    amount.frame = CGRectMake(CGRectGetMinX(amountValue.frame) - 10 - CGRectGetWidth(amount.frame), CGRectGetMaxY(line.frame) + 20 + (CGRectGetHeight(amountValue.frame) / 2 - CGRectGetHeight(amount.frame) / 2), CGRectGetWidth(amount.frame), CGRectGetHeight(amount.frame));
    
    
    
    UIView *paymentMethodContainer = [[UIView alloc] init];
    paymentMethodContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paymentMethodContainer];
    
    verticalLine = [[UIView alloc] init];
    verticalLine.frame = CGRectMake(20, 10, 4, 30);
    verticalLine.backgroundColor = [UIColor colorWithRed:46/255.0f green:132/255.0f blue:255/255.0f alpha:1];
    [paymentMethodContainer addSubview:verticalLine];
    
    UILabel *paymentMethodTitleLabel = [[UILabel alloc] init];
    paymentMethodTitleLabel.text = @"支付方式";
    paymentMethodTitleLabel.frame = CGRectMake(CGRectGetMaxX(verticalLine.frame) + 10, 10, screenWith - CGRectGetMaxX(verticalLine.frame) - 10 - 20, 30);
    [paymentMethodContainer addSubview:paymentMethodTitleLabel];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    line.frame = CGRectMake(CGRectGetMinX(verticalLine.frame), CGRectGetMaxY(verticalLine.frame) + 10, screenWith - 40, 2);
    [paymentMethodContainer addSubview:line];
    
    UIView *alipay = [[UIView alloc] init];
    alipay.frame = CGRectMake(0, CGRectGetMaxY(line.frame), 80, screenWith);
    [paymentMethodContainer addSubview:alipay];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(30, 20, 40, 40);
    imageView.image = [UIImage imageNamed:@"ic_zhifubao"];
    [alipay addSubview:imageView];
    
    UILabel *method = [[UILabel alloc] init];
    method.text = @"支付宝";
    method.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 20, CGRectGetMinY(imageView.frame), 100, 40);
    [alipay addSubview:method];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.frame = CGRectMake(screenWith - 60, CGRectGetMinY(imageView.frame) + 10, 20, 20);
    rightImageView.image = [UIImage imageNamed:@""];
    rightImageView.backgroundColor = [UIColor greenColor];
    [alipay addSubview:rightImageView];
    
    paymentMethodContainer.frame = CGRectMake(0, CGRectGetMaxY(reportContainer.frame) + 20, screenWith, 132);
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    _payButton.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 40 - CGRectGetHeight(self.tabBarController.tabBar.frame), screenWith, 40);
    _payButton.isDisable = YES;
    [_payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_payButton];
    
}

- (void)pay:(id)sender {
    

}

- (void)alipay:(NSString *)orderString {
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"alipayScheme" callback:^(NSDictionary *resultDic) {
        if (resultDic[@""]) {
            
        } else {
            
        }
    }];
}

- (UILabel *)createLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    return label;
}


@end
