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

@interface ViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic) UIButton *editPhotoButton;
@property (nonatomic) UIButton *fantasticCameraButton;
@property (nonatomic) UIImageView *imageView;

@property (nonatomic) NSMutableArray *imgArray;
@property (nonatomic) UICollectionView *collection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collection reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.editPhotoButton.frame = CGRectMake(10, 100, 200, 100);
    self.fantasticCameraButton.frame = CGRectMake(self.editPhotoButton.x, self.editPhotoButton.bottom + 10, self.editPhotoButton.width, self.editPhotoButton.height);
    
    
    
    self.imageView.frame = CGRectMake(self.fantasticCameraButton.frame.origin.x, self.fantasticCameraButton.bottom + 20, 200, 200);
    self.collection.frame = CGRectMake(0, self.view.height - 80 - 34, self.view.width, 80);
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
    [_editPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editPhotoButton.backgroundColor = [UIColor redColor];
    [_editPhotoButton addTarget:self action:@selector(editPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editPhotoButton];
    return _editPhotoButton;
}

- (UIButton *)fantasticCameraButton {
    if (_fantasticCameraButton) {
        return _fantasticCameraButton;
    }
    _fantasticCameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_fantasticCameraButton setTitle:@"超级相机" forState:UIControlStateNormal];
    [_fantasticCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _fantasticCameraButton.backgroundColor = [UIColor blueColor];
    [_fantasticCameraButton addTarget:self action:@selector(showCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fantasticCameraButton];
    return _fantasticCameraButton;
}


#warning test gif split

- (NSMutableArray *)imgArray {
    if (_imgArray) {
        return _imgArray;
    }
    _imgArray = [NSMutableArray array];
    NSData * data = [self gifImageData];
    
    CGImageSourceRef sourec = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //2.将gif图片分解成帧
    
    size_t count = CGImageSourceGetCount(sourec);
    
    for (size_t i = 0; i < count; i++)
    {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourec, i, NULL);
        
        //3.将单帧图片转化为UIimage
        UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        [_imgArray addObject:image];
        
        //释放imageRef
        CGImageRelease(imageRef);
    }
    //释放sourec
    CFRelease(sourec);

    
    
    return _imgArray;
}

- (NSData *)gifImageData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[self gifImageData]]];
    [self.view addSubview:_imageView];
    return _imageView;
}

- (UICollectionView *)collection {
    if (_collection) {
        return _collection;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(80, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collection registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    _collection.dataSource = self;
    _collection.delegate = self;
    [self.view addSubview:_collection];
    return _collection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = self.imgArray[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc] init];
    [cell addSubview:imgView];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = image;
    imgView.frame = CGRectMake(0, 0, 80, 80);
    return cell;
}

@end
