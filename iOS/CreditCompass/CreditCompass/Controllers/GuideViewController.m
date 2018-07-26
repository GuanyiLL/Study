//
//  GuideViewController.m
//  CreditCompass
//
//  Created by ra1n on 2018/7/23.
//  Copyright © 2018 ra1n. All rights reserved.
//



#import "GuideViewController.h"

@interface GuideViewController ()

@property (nonatomic) UIScrollView *container;
@property (nonatomic, copy) GuideViewControllerCompletionBlock completion;

@end

@implementation GuideViewController

- (instancetype)initWithCompetion:(GuideViewControllerCompletionBlock)completion {
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _container = [[UIScrollView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _container.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, [UIScreen mainScreen].bounds.size.height);
    _container.pagingEnabled = YES;
    _container.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_container];
    
    NSArray *images = self.launchImages;
    for (NSInteger idx = 0; idx < images.count; idx++) {
        NSString *imageName = images[idx];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.container addSubview:imageView];
        
        CGRect rect = imageView.frame;
        rect.origin.x = idx * CGRectGetWidth(self.view.frame);
        imageView.frame = rect;
        
        if (idx == images.count - 1) {
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [imageView addSubview:button];
            button.frame = CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 120 / 2, CGRectGetMidY(imageView.frame) + 180, 120, 40);
            [button setTitle:@"立即检测" forState:UIControlStateNormal];
            button.layer.cornerRadius = 2.0;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:110 / 255.0 green:150 / 255.0 blue:248 / 255.0f alpha:1];
            [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)confirmAction:(id)sender {
    self.completion();
}

- (NSArray *)launchImages {
    return @[@"launchImage_P2",@"launchImage_P1",@"launchImage_P3"];
}

@end
