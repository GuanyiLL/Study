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

@interface KQFantasticCameraViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *changeCamera;
@property (nonatomic) KQRecordButton *recoredButton;

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) GPUImageVideoCamera *videoCamera;

@property (nonatomic) GPUImageAddBlendFilter *blendFilter;
@property (nonatomic) GPUImageView *displayView;
@property (nonatomic) GPUImageMovieWriter *movieWriter;
@property (nonatomic) NSURL *movieURL;
@property (nonatomic, copy) NSString *moviePath;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic) NSMutableDictionary *faceViews;

@property (nonatomic) GPUImageUIElement *element;
@property (nonatomic) UIView *canvasView;

@end

@implementation KQFantasticCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.faceViews = [NSMutableDictionary dictionary];
    
    self.element = [[GPUImageUIElement alloc] initWithView:self.canvasView];
    self.canvasView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.videoCamera startCameraCapture];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"aaaa";
    [self.canvasView addSubview:label];
    
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:beautifyFilter];
    self.blendFilter = [[GPUImageAddBlendFilter alloc] init];
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
        [strongSelf.element update];
        });
    }];
    [self.view addSubview:self.canvasView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backButton.frame = CGRectMake(20, 40, 40, 40);
    self.changeCamera.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 60, self.backButton.top, 40, 40);
    self.recoredButton.frame = CGRectMake(self.view.width / 2 - 60 / 2, self.view.height - 60 - 34 , 60, 60);
}


- (void)viewDidDisappear:(BOOL)animated {
    [self.videoCamera stopCameraCapture];
    [super viewDidDisappear:animated];
}

#pragma mark- Actions

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeCamera:(id)sender {
    [self.videoCamera rotateCamera];
}

- (void)recordAction:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        if ([sender isKindOfClass:[KQRecordButton class]]) {
            ((KQRecordButton *)sender).isRecording = !self.isRecording;
        }
        
        if (self.isRecording) {
            self.isRecording = NO;
            [self.movieWriter finishRecording];
            [self.blendFilter removeTarget:self.movieWriter];
            self.videoCamera.audioEncodingTarget = nil;
            UISaveVideoAtPathToSavedPhotosAlbum(self.moviePath, nil, nil, nil);
            return;
        }
        
        self.isRecording = YES;
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

#pragma mark- Method

-(NSString *)getVideoPathCache {
    NSString *videoCache = [NSTemporaryDirectory() stringByAppendingString:@"videos"];
    BOOL isDir =NO;
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
        CGRect previewBox = self.view.bounds;
        
        CGFloat temp = faceRect.size.width * self.view.height;
        faceRect.size.width = faceRect.size.height * self.view.width;
        faceRect.size.height = temp;
        temp = faceRect.origin.x * self.view.height;
        faceRect.origin.x = faceRect.origin.y * self.view.width;
        faceRect.origin.y = temp;
        
        faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
        
        NSDictionary *dic = self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]];
        
        UIView *faceView = dic[@"face"];
        UIImageView *imageView = dic[@"imageView"];
        if (faceView == nil) {
            faceView = [[UIView alloc] init];
            faceView.layer.borderColor = [UIColor redColor].CGColor;
            faceView.layer.borderWidth = 1;
            faceView.backgroundColor = [UIColor clearColor];
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            imageView.image = [UIImage imageNamed:@"test.gif"];
            self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]] = @{@"face":faceView, @"imageView":imageView};
        }
        [self.view addSubview:faceView];
        [self.canvasView addSubview:imageView];
        faceView.frame = faceRect;
        imageView.frame = CGRectMake(faceView.frame.origin.x + faceView.width / 2 - 40, faceView.top - 100, 80, 80);
    }
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
    self.view = _displayView;
    return _displayView;
}

- (UIButton *)backButton {
    if (_backButton) {
        return _backButton;
    }
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_backButton setTitle:@"X" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    return _backButton;
}

- (UIButton *)changeCamera {
    if (_changeCamera) {
        return _changeCamera;
     }
    _changeCamera = [UIButton buttonWithType:UIButtonTypeSystem];
    [_changeCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeCamera setTitle:@"T" forState:UIControlStateNormal];
    [_changeCamera addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    _changeCamera.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:_changeCamera];
    return _changeCamera;
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

@end
