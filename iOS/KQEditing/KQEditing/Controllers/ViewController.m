//
//  ViewController.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/18.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "ViewController.h"
#import "KQEditorViewController.h"
#import "KQFantasticCameraViewController.h"
#import "KQSelector.h"

CGFloat const kButtonHeight = 100;
CGFloat const kButtonWidth = 200;
CGFloat const kButtonCornerRadius = 5;
CGFloat const kTopMergin = 50;

@interface ViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic) UIButton *editPhotoButton;
@property (nonatomic) UIButton *fantasticCameraButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0 alpha:1]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.editPhotoButton.frame = CGRectMake(self.view.width / 2 - kButtonWidth / 2, CGRectGetMaxY(self.navigationController.navigationBar.frame) + kTopMergin, kButtonWidth, kButtonHeight);
    self.fantasticCameraButton.frame = CGRectMake(self.editPhotoButton.x, self.editPhotoButton.bottom + kTopMergin, self.editPhotoButton.width, self.editPhotoButton.height);
}

#pragma mark- Action

- (void)editPhotoAction:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentPhotoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPhotoPicker:UIImagePickerControllerSourceTypeCamera];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentPhotoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)showCameraAction:(UIButton *)sender {
    KQFantasticCameraViewController *camera = [[KQFantasticCameraViewController alloc] init];
    [self.navigationController pushViewController:camera animated:YES];
}

#pragma mark- Fucntions

- (void)presentPhotoPicker:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)showFilterViewController:(UIImage *)image {
    KQEditorViewController *filterController = [[KQEditorViewController alloc] init];
    filterController.editImage = image;
    [self.navigationController pushViewController:filterController animated:YES];
}

#pragma mark- Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self showFilterViewController:image];
    }];
}

#pragma mark- Getter

- (UIButton *)editPhotoButton {
    if (_editPhotoButton) {
        return _editPhotoButton;
    }
    _editPhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_editPhotoButton setTitle:@"图片编辑" forState:UIControlStateNormal];
    [_editPhotoButton addTarget:self action:@selector(editPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _editPhotoButton.layer.cornerRadius = kButtonCornerRadius;
    _editPhotoButton.layer.borderWidth = 1;
    _editPhotoButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_editPhotoButton];
    return _editPhotoButton;
}

- (UIButton *)fantasticCameraButton {
    if (_fantasticCameraButton) {
        return _fantasticCameraButton;
    }
    _fantasticCameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_fantasticCameraButton setTitle:@"超级相机" forState:UIControlStateNormal];
    [_fantasticCameraButton addTarget:self action:@selector(showCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fantasticCameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _fantasticCameraButton.layer.cornerRadius = kButtonCornerRadius;
    _fantasticCameraButton.layer.borderWidth = 1;
    _fantasticCameraButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_fantasticCameraButton];
    return _fantasticCameraButton;
}

@end
