//
//  KQFantasticCameraViewController.m
//  KQEditing
//
//  Created by Guanyi on 2018/5/28.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import "KQFantasticCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KQRecordButton.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import <CoreImage/CoreImage.h>
#import "KQGIFItem.h"

CGFloat const screenEdge = 20;
CGFloat const buttonWidth = 44;
CGFloat const flashButtonWidth = 40;
CGFloat const selectorItemHeight = 40;
CGFloat const recoredButtonWidth = 60;

@interface KQFantasticCameraViewController ()
<
AVCaptureMetadataOutputObjectsDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

/* UI */
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) KQRecordButton *recoredButton;
@property (nonatomic) UIButton *photoflashButton;

/* 摄像头、滤镜 */
@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) GPUImageVideoCamera *videoCamera;
@property (nonatomic) GPUImageNormalBlendFilter *blendFilter;
@property (nonatomic) GPUImageView *displayView;

/* 视频录制 */
@property (nonatomic) BOOL isRecording;
@property (nonatomic) NSURL *movieURL;
@property (nonatomic, copy) NSString *moviePath;
@property (nonatomic) GPUImageMovieWriter *movieWriter;
@property (nonatomic) CADisplayLink *link;
@property (nonatomic) NSUInteger videoSeconds;

/* gif贴纸相关 */
@property (nonatomic) UICollectionView *pasterSelector;
@property (nonatomic) NSMutableDictionary *faceViews;
@property (nonatomic) GPUImageUIElement *element;
@property (nonatomic) UIView *canvasView;
@property (nonatomic) NSMutableArray *imageArray;
@property (nonatomic) CADisplayLink *gifLink;
@property (nonatomic) CGFloat period;
@property (nonatomic) NSUInteger gifIndex;
@property (nonatomic) UIImage *currentGIFImage;
@property (nonatomic,copy) NSArray *GIFPasters;
@property (nonatomic) NSInteger pasterIndex;

@end

@implementation KQFantasticCameraViewController

#pragma mark- Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationController];
    [self initializeData];
    [self initializeTimer];
    [self initializeCamera];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat iphonexMargin = kDevice_Is_iPhoneX ? 34 : 0;
    self.photoflashButton.frame = CGRectMake(self.view.width - flashButtonWidth - screenEdge, CGRectGetMaxY(self.navigationController.navigationBar.frame) + screenEdge, flashButtonWidth, flashButtonWidth);
    self.recoredButton.frame = CGRectMake(self.view.width / 2 - recoredButtonWidth / 2,
                                          self.view.height - recoredButtonWidth - iphonexMargin,
                                          recoredButtonWidth,
                                          recoredButtonWidth);
    
    self.pasterSelector.frame = CGRectMake(0, self.recoredButton.top - selectorItemHeight * 2, self.view.width, selectorItemHeight);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.timeLabel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.videoCamera stopCameraCapture];
    [super viewDidDisappear:animated];
}

#pragma mark- Methods

- (void)initializeTimer {
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshTimeLabel)];
    if (@available(iOS 10.0, *)) {
        self.link.preferredFramesPerSecond = 1;
    } else {
        self.link.frameInterval = 60;
    }
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.link.paused = YES;
    
    self.gifLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshGIF)];
    if (@available(iOS 10.0, *)) {
        self.gifLink.preferredFramesPerSecond = 8;
    } else {
        self.gifLink.frameInterval = 7.5;
    }
    [self.gifLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.gifLink.paused = NO;
}

- (void)initializeCamera {
    self.canvasView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.element = [[GPUImageUIElement alloc] initWithView:self.canvasView];
    
    [self.videoCamera startCameraCapture];
    
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:beautifyFilter];
    self.blendFilter = [[GPUImageNormalBlendFilter alloc] init];
    [beautifyFilter addTarget:self.blendFilter];
    [self.element addTarget:self.blendFilter];
    [beautifyFilter addTarget:self.displayView];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    if ([self.videoCamera.captureSession canAddOutput:output]) {
        [self.videoCamera.captureSession addOutput:output];
    }
    
    NSArray* supportTypes = output.availableMetadataObjectTypes;
    if ([supportTypes containsObject:AVMetadataObjectTypeFace]) {
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    
    __weak typeof (self) weakSelf = self;
    [beautifyFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time){
        __strong typeof (self) strongSelf = weakSelf;
        dispatch_async([GPUImageContext sharedContextQueue], ^{
            [strongSelf.element updateWithTimestamp:time];
        });
    }];
    [self.view addSubview:self.canvasView];
}

- (void)initializeData {
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.faceViews = [NSMutableDictionary dictionary];
    self.imageArray = [NSMutableArray array];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imgPath =[NSString stringWithFormat:@"%@/hanfumei-800/icon.png", resourcePath];
    self.GIFPasters = @[[UIImage imageNamed:@"border_normal"],[UIImage imageWithContentsOfFile:imgPath]];
}

- (void)loadGIFS {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *configJSON =[NSString stringWithFormat:@"%@/hanfumei-800/config.json", resourcePath];
    NSData *data = [NSData dataWithContentsOfFile:configJSON];
    NSDictionary *gifConfig = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSInteger i = 0; i < [gifConfig[@"c"] integerValue]; i++) {
        [self.imageArray addObject:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/hanfumei-800/hanfumei%zd.png",resourcePath,i]]];
    }
}

- (void)configNavigationController {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:1 alpha:1]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"record_lensflip_normal"] style:UIBarButtonItemStyleDone target:self action:@selector(changeCamera:)];
    self.navigationItem.titleView = self.timeLabel;
}

-(NSString *)getVideoPathCache {
    NSString *videoCache = [NSTemporaryDirectory() stringByAppendingString:@"videos"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:videoCache isDirectory:&isDir];
    if (!existed) {
        [fileManager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return videoCache;
}

-(NSString *)getVideoNameWithType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYMMDD HHmmss"];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:now];
    NSString *timeStr = [formatter stringFromDate:nowDate];
    NSString *fileName = [NSString stringWithFormat:@"video_%@.%@",timeStr,fileType];
    return fileName;
}

- (void)refreshTimeLabel {
    NSInteger hours = self.videoSeconds / 3600;
    NSInteger minutes = self.videoSeconds / 60 % 60;
    NSInteger seconds = self.videoSeconds % 60;
    
    NSString *time = [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hours,minutes,seconds];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeLabel.text = time;
    });
    self.videoSeconds++;
}

- (void)refreshGIF {
    if (self.imageArray.count == 0) return;
    NSInteger idx = self.gifIndex % self.imageArray.count;
    self.currentGIFImage = self.imageArray[idx];
    self.gifIndex++;
}

#pragma mark- Actions

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeCamera:(id)sender {
    if (self.videoCamera.inputCamera.torchMode == AVCaptureTorchModeOn) {
        [self.videoCamera.inputCamera lockForConfiguration:nil];
        [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
        [self.videoCamera.inputCamera unlockForConfiguration];
        [self.photoflashButton setImage:[UIImage imageNamed:@"flashing_off"] forState:UIControlStateNormal];
    }
    self.photoflashButton.enabled = [self.videoCamera isBackFacingCameraPresent];
    [self.videoCamera rotateCamera];
}

- (void)recordAction:(id)sender {

    dispatch_async(self.sessionQueue, ^{
        if ([sender isKindOfClass:[KQRecordButton class]]) {
            ((KQRecordButton *)sender).isRecording = !self.isRecording;
        }
        
        if (self.isRecording) {
            self.isRecording = NO;
            self.link.paused = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = @"";
            });
            [self.movieWriter finishRecording];
            self.videoSeconds = 0;
            [self.blendFilter removeTarget:self.movieWriter];
            self.videoCamera.audioEncodingTarget = nil;
            UISaveVideoAtPathToSavedPhotosAlbum(self.moviePath, nil, nil, nil);
            return;
        }
        
        self.isRecording = YES;
        self.link.paused = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeLabel.text = @"00:00:00";
        });
        NSString *defultPath = [self getVideoPathCache];
        self.moviePath = [defultPath stringByAppendingPathComponent:[self getVideoNameWithType:@"mp4"]];
        self.movieURL = [NSURL fileURLWithPath:self.moviePath];
        unlink([self.moviePath UTF8String]);
        
        self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:self.movieURL size:CGSizeMake(720, 1280)];
        self.movieWriter.encodingLiveVideo = YES;
        [self.blendFilter addTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = self.movieWriter;
        [self.movieWriter startRecording];
    });
}

- (void)photoflashAction:(id)sender {
    if (self.videoCamera.inputCamera.position == AVCaptureDevicePositionBack) {
        if (self.videoCamera.inputCamera.torchMode == AVCaptureTorchModeOn) {
            [self.videoCamera.inputCamera lockForConfiguration:nil];
            [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            [self.videoCamera.inputCamera unlockForConfiguration];
            [self.photoflashButton setImage:[UIImage imageNamed:@"flashing_off"] forState:UIControlStateNormal];
        }else if (self.videoCamera.inputCamera.torchMode == AVCaptureTorchModeOff) {
            [self.videoCamera.inputCamera lockForConfiguration:nil];
            [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self.videoCamera.inputCamera unlockForConfiguration];
            [self.photoflashButton setImage:[UIImage imageNamed:@"flashing_on"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark- Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    for (NSString *faceID in self.faceViews) {
        NSDictionary *d = self.faceViews[faceID];
        UIView *f = d[@"face"];
        [f removeFromSuperview];
        UIImageView *l = d[@"imageView"];
        [l removeFromSuperview];
    }
    
    for (AVMetadataFaceObject *face in metadataObjects) {
        CGRect faceRect = face.bounds;
        CGFloat temp = faceRect.size.width * self.view.height;
        faceRect.size.width = faceRect.size.height * self.view.width;
        faceRect.size.height = temp;
        temp = faceRect.origin.x * self.view.height;
        faceRect.origin.x = faceRect.origin.y * self.view.width;
        faceRect.origin.y = temp;
        
        NSDictionary *dic = self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]];
        
        UIView *faceView = dic[@"face"];
        UIImageView *imageView = dic[@"imageView"];
        
        if (faceView == nil) {
            faceView = [[UIView alloc] init];
            faceView.layer.borderColor = [UIColor yellowColor].CGColor;
            faceView.layer.borderWidth = 1;
            faceView.backgroundColor = [UIColor clearColor];
            faceView.userInteractionEnabled = NO;
            imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]] = @{@"face":faceView, @"imageView":imageView};
        }
    
        CGSize imgSize = imageView.image.size;
        CGFloat widthScale = faceRect.size.width / 170;
        
        imgSize.width = widthScale * imgSize.width;
        imgSize.height = widthScale * imgSize.height;
        
        [self.view addSubview:faceView];
        if (self.imageArray.count > 0) {
            [self.canvasView addSubview:imageView];
        }
        imageView.image = self.currentGIFImage;
        faceView.frame = faceRect;
        imageView.frame = CGRectMake(faceView.frame.origin.x + faceView.width / 2 - imgSize.width / 2 - 3,
                                     faceView.top - 150,
                                     imgSize.width,
                                     imgSize.height);
        
    }
}

#pragma mark- DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KQGIFItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KQGIFItem.reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = self.GIFPasters[indexPath.row];
    cell.index = indexPath.row;
    [cell kq_selected:indexPath.row == self.pasterIndex];
    cell.imageView.image = self.GIFPasters[indexPath.row];
    cell.didSelectIndex = ^(NSInteger idx) {
        if (idx == self.pasterIndex) return;
        KQGIFItem *lastItem = (KQGIFItem *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pasterIndex inSection:0]];
        [lastItem kq_selected:NO];
        self.pasterIndex = idx;
        if (idx == 0) {
            [self.imageArray removeAllObjects];
        } else {
            [self loadGIFS];
        }
    };
    return cell;
}

#pragma mark- Getter

- (GPUImageVideoCamera *)videoCamera {
    if (_videoCamera) {
        return _videoCamera;
    }
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [_videoCamera addAudioInputsAndOutputs];
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    return _videoCamera;
}

- (GPUImageView *)displayView {
    if (_displayView) {
        return _displayView;
    }
    _displayView = [[GPUImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _displayView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview: _displayView];
    self.view.clipsToBounds = YES;
    return _displayView;
}

- (KQRecordButton *)recoredButton {
    if (_recoredButton) {
        return _recoredButton;
    }
    _recoredButton = [[KQRecordButton alloc] init];
    [_recoredButton addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recoredButton];
    return _recoredButton;
}

- (UIButton *)photoflashButton {
    if (_photoflashButton) {
        return _photoflashButton;
    }
    _photoflashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_photoflashButton setImage:[UIImage imageNamed:@"flashing_off"] forState:UIControlStateNormal];
    [_photoflashButton addTarget:self action:@selector(photoflashAction:) forControlEvents:UIControlEventTouchUpInside];
    _photoflashButton.tintColor = [UIColor whiteColor];
    [self.view addSubview:_photoflashButton];
    return _photoflashButton;
}

- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           self.view.width,
                                                           buttonWidth)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    return _timeLabel;
}

- (UICollectionView *)pasterSelector {
    if (_pasterSelector) {
        return _pasterSelector;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(self.view.width / 2 - 20, 0);
    layout.footerReferenceSize = CGSizeMake(self.view.width / 2 - 20, 0);
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(40, 40);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _pasterSelector = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _pasterSelector.delegate = self;
    _pasterSelector.dataSource = self;
    _pasterSelector.backgroundColor = [UIColor clearColor];
    _pasterSelector.showsHorizontalScrollIndicator = NO;
    _pasterSelector.showsHorizontalScrollIndicator = NO;
    [_pasterSelector registerClass:[KQGIFItem class] forCellWithReuseIdentifier:KQGIFItem.reuseIdentifier];
    [self.view addSubview:_pasterSelector];
    return _pasterSelector;
}

@end
