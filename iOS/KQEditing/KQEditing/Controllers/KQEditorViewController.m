//
//  KQFilterViewController.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/18.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQEditorViewController.h"
#import "KQFilterSelector.h"
#import "KQFilterCoordinator.h"
#import <CoreImage/CoreImage.h>
#import <Photos/Photos.h>
#import "KQPasterSelector.h"
#import "KQPaster.h"
#import "KQPasterCoordinator.h"

CGFloat const kSelectorHeight = 80;
CGFloat const kSegmentedHeight = 30;

@implementation KQEditorViewController {
    UIImageView *_imageView;
    KQPasterSelector *_pasterSelector;
    KQFilterSelector *_filterSelector;
    UISegmentedControl *_segmentedControl;
}

#pragma mark- Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(savePhoto:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat iphonexDiff = kDevice_Is_iPhoneX ? 34 : 0;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    self.imageView.frame = CGRectMake(0,
                                      self.navigationController.navigationBar.bottom,
                                      screenWidth,
                                      screenHeight - kSelectorHeight - self.navigationController.navigationBar.bottom - kSegmentedHeight - iphonexDiff);
    self.filterSelector.frame = CGRectMake(0,
                                         self.imageView.bottom,
                                         screenWidth,
                                         kSelectorHeight);
    self.pasterSelector.frame = self.filterSelector.frame;
    self.segmentedControl.frame = CGRectMake(0,
                                             self.filterSelector.bottom,
                                             screenWidth,
                                             kSegmentedHeight);
}

#pragma mark- Method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[KQPasterCoordinator sharedInstance] resetPasters];
}

- (void)savePhoto:(UIBarButtonItem *)sender {
    [[KQPasterCoordinator sharedInstance] resetPasters];
    UIImage *image = self.imageView.image;
    CGRect imageFrame = [image getFrameInImageView:self.imageView];
    UIImage *finalImage = [UIImage imageWithView:self.imageView scope:imageFrame];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:finalImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)typeChanged:(UISegmentedControl *)sender {
    [[KQPasterCoordinator sharedInstance] resetPasters];
    self.filterSelector.hidden = sender.selectedSegmentIndex;
    self.pasterSelector.hidden = !sender.selectedSegmentIndex;
}

#pragma mark- Getter

- (KQFilterSelector *)filterSelector {
    if (_filterSelector) {
        return _filterSelector;
    }
    _filterSelector = [KQFilterSelector selectorWithCompletion:^(NSInteger idx) {
        UIImage *resImage = [KQFilterCoordinator filterType:idx inputImage:self.editImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = resImage;
        });
    }];
    [self.view addSubview:_filterSelector];
    return _filterSelector;
}

- (KQPasterSelector *)pasterSelector {
    if (_pasterSelector) {
        return _pasterSelector;
    }
    _pasterSelector = [KQPasterSelector selectorWithCompletion:^(NSInteger idx) {
        [[KQPasterCoordinator sharedInstance] addPasterWithIndex:idx container:self.imageView];
    }];
    _pasterSelector.hidden = YES;
    [self.view addSubview:_pasterSelector];
    return _pasterSelector;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.image = self.editImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    return _imageView;
}

- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl) {
        return _segmentedControl;
    }
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"滤镜",@"贴纸"]];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self
                          action:@selector(typeChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    return _segmentedControl;
}
@end
