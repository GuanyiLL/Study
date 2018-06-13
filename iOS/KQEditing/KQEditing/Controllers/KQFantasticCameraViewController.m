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
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) KQRecordButton *recoredButton;

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) GPUImageVideoCamera *videoCamera;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic) NSURL *movieURL;
@property (nonatomic, copy) NSString *moviePath;

@property (nonatomic) GPUImageNormalBlendFilter *blendFilter;
@property (nonatomic) GPUImageView *displayView;
@property (nonatomic) GPUImageMovieWriter *movieWriter;

@property (nonatomic) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger videoSeconds;

@property (nonatomic) NSMutableDictionary *faceViews;
@property (nonatomic) GPUImageUIElement *element;
@property (nonatomic) UIView *canvasView;
@property (nonatomic) NSMutableArray *imageArray;

@property (nonatomic) CADisplayLink *gifLink;
@property (nonatomic) CGFloat period;
@property (nonatomic, assign) NSUInteger gifIndex;
@property (nonatomic) UIImage *currentGIFImage;

@end

@implementation KQFantasticCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0 alpha:1]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeCamera];

    self.navigationItem.titleView = self.timeLabel;
    
    
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    self.faceViews = [NSMutableDictionary dictionary];
    
    self.imageArray = [NSMutableArray array];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *configJSON =[NSString stringWithFormat:@"%@/hanfumei-800/config.json", resourcePath];
    NSData *data = [NSData dataWithContentsOfFile:configJSON];
    NSDictionary *gifConfig = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    for (NSInteger i = 0; i < [gifConfig[@"c"] integerValue]; i++) {
        [self.imageArray addObject:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/hanfumei-800/hanfumei%zd.png",resourcePath,i]]];
    }
    
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat iphonexMargin = kDevice_Is_iPhoneX ? 34 : 0;
    self.recoredButton.frame = CGRectMake(self.view.width / 2 - 60 / 2,
                                          self.view.height - 60 - iphonexMargin,
                                          60,
                                          60);
    self.timeLabel.frame = CGRectMake(0,
                                      0,
                                      self.view.width,
                                      44 + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]));
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
    NSInteger idx = self.gifIndex % self.imageArray.count;
    self.currentGIFImage = self.imageArray[idx];
    self.gifIndex++;
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
            self.link.paused = YES;
            self.timeLabel.text = @"";
            [self.movieWriter finishRecording];
            self.videoSeconds = 0;
            [self.blendFilter removeTarget:self.movieWriter];
            self.videoCamera.audioEncodingTarget = nil;
            UISaveVideoAtPathToSavedPhotosAlbum(self.moviePath, nil, nil, nil);
            return;
        }
        
        self.isRecording = YES;
        self.link.paused = NO;
        self.timeLabel.text = @"00:00:00";
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
            imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]] = @{@"face":faceView, @"imageView":imageView};
            self.gifIndex = 0;
            imageView.image = self.imageArray[0];
        }
    
        CGSize imgSize = imageView.image.size;
        /*photo w:700 h:756 */
        /* face w:200 h:180 y:340*/
        
        CGFloat widthScale = faceRect.size.width / 160;
        
        imgSize.width = widthScale * imgSize.width;
        imgSize.height = widthScale * imgSize.height;
        
        [self.view addSubview:faceView];
        [self.canvasView addSubview:imageView];
        imageView.image = self.currentGIFImage;
        faceView.frame = faceRect;
        imageView.frame = CGRectMake(faceView.frame.origin.x + faceView.width / 2 - imgSize.width / 2 - 3,
                                     faceView.top - 150
                                     ,
                                     imgSize.width,
                                     imgSize.height);
        
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
    [self.view addSubview: _displayView];
    return _displayView;
}

- (UIButton *)backButton {
    if (_backButton) {
        return _backButton;
    }
    _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _backButton.frame = CGRectMake(0, 0, 44, 44);
    [_backButton setTitle:@"X" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    return _backButton;
}

- (UIButton *)changeCamera {
    if (_changeCamera) {
        return _changeCamera;
     }
    _changeCamera = [UIButton buttonWithType:UIButtonTypeSystem];
    _changeCamera.frame = CGRectMake(0, 0, 44, 44);
    [_changeCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeCamera setTitle:@"T" forState:UIControlStateNormal];
    [_changeCamera addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    _changeCamera.titleLabel.font = [UIFont boldSystemFontOfSize:30];
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

- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    return _timeLabel;
}

@end
