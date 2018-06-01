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

@interface KQFantasticCameraViewController () <GPUImageVideoCameraDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *changeCamera;
@property (nonatomic) KQRecordButton *recoredButton;

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) GPUImageVideoCamera *videoCamera;

@property (nonatomic) GPUImageBeautifyFilter *beautyFilter;
@property (nonatomic , strong) GPUImageAddBlendFilter *blendFilter;
@property (nonatomic) GPUImageFilterGroup *filter;

@property (nonatomic) GPUImageView *displayView;
@property (nonatomic) GPUImageMovieWriter *movieWriter;
@property (nonatomic) NSURL *movieURL;
@property (nonatomic,copy) NSString *moviePath;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic) CIDetector *faceDetector;
@property (nonatomic, assign) BOOL faceThinking;

@property (nonatomic) NSMutableDictionary *faceViews;
@property (nonatomic) UIImageView *paster;

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
    
    self.canvasView = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.text = @"GGGGG";
    [self.canvasView addSubview:label];
    
    self.element = [[GPUImageUIElement alloc] initWithView:self.canvasView];
    
    
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:beautifyFilter];
    self.blendFilter = [[GPUImageAddBlendFilter alloc] init];
    [beautifyFilter addTarget:self.blendFilter];
    [self.element addTarget:self.blendFilter];
    [beautifyFilter addTarget:self.displayView];
    
    [self.videoCamera startCameraCapture];
    
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
            UIView *f = strongSelf.faceViews.allValues.firstObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                label.frame = CGRectMake(f.frame.origin.x, f.top - 20, 40, 20);
            });
            [strongSelf.element updateWithTimestamp:time];
        });
    }];
    
    [self.view addSubview:self.canvasView];
    
//
//    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
//    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
}

- (void)refresh {
  
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
            [self.beautyFilter removeTarget:self.movieWriter];
            self.videoCamera.audioEncodingTarget = nil;
            [self.movieWriter finishRecording];
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
        [self.beautyFilter addTarget:self.movieWriter];
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

- (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    self.faceThinking = TRUE;
    NSLog(@"Faces thinking");
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *convertedImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    
    if (attachments)
        CFRelease(attachments);
    NSDictionary *imageOptions = nil;
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    int exifOrientation;
    
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
     
     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
    
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT            = 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT            = 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };
    BOOL isUsingFrontFacingCamera = FALSE;
    AVCaptureDevicePosition currentCameraPosition = [self.videoCamera cameraPosition];
    
    if (currentCameraPosition != AVCaptureDevicePositionBack)
    {
        isUsingFrontFacingCamera = TRUE;
    }
    
    switch (curDeviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    
    imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
    
    NSLog(@"Face Detector %@", [self.faceDetector description]);
    NSLog(@"converted Image %@", [convertedImage description]);
    NSArray *features = [self.faceDetector featuresInImage:convertedImage options:imageOptions];
    
    
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
    
    
    [self GPUVCWillOutputFeatures:features forClap:clap andOrientation:curDeviceOrientation];
    self.faceThinking = FALSE;
}

- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Did receive array");
        
        CGRect previewBox = self.view.frame;
        
        for (CIFaceFeature *faceFeature in featureArray) {
            
            // find the correct position for the square layer within the previewLayer
            // the feature box originates in the bottom left of the video frame.
            // (Bottom right if mirroring is turned on)
            NSLog(@"%@", NSStringFromCGRect([faceFeature bounds]));
            
            //Update face bounds for iOS Coordinate System
            CGRect faceRect = [faceFeature bounds];
            
            // flip preview width and height
            CGFloat temp = faceRect.size.width;
            faceRect.size.width = faceRect.size.height;
            faceRect.size.height = temp;
            temp = faceRect.origin.x;
            faceRect.origin.x = faceRect.origin.y;
            faceRect.origin.y = temp;
            // scale coordinates so they fit in the preview box, which may be scaled
            CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
            CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
            faceRect.size.width *= widthScaleBy;
            faceRect.size.height *= heightScaleBy;
            faceRect.origin.x *= widthScaleBy;
            faceRect.origin.y *= heightScaleBy;
            
            faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
            
            // create a UIView using the bounds of the face
//            UIView *faceView = [[UIView alloc] initWithFrame:faceRect];
//
//            // add a border around the newly created UIView
//            faceView.layer.borderWidth = 1;
//            faceView.layer.borderColor = [[UIColor redColor] CGColor];
//
//            // add the new view to create a box around the face
//            [self.view addSubview:faceView];
            
        }
    });
    
}

#pragma mark- Delegate

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//    if (!self.faceThinking) {
//        CFAllocatorRef allocator = CFAllocatorGetDefault();
//        CMSampleBufferRef sbufCopyOut;
//        CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
//        [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:)
//                               withObject:CFBridgingRelease(sbufCopyOut)];
//    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    for (NSString *faceID in self.faceViews) {
        UIView *v = self.faceViews[faceID];
        [v removeFromSuperview];
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
        
        UIView * faceView = self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]];
        if (faceView == nil) {
            faceView = [[UIView alloc] init];
            self.faceViews[[NSString stringWithFormat:@"%zd",face.faceID]] = faceView;
            faceView.layer.borderColor = [UIColor redColor].CGColor;
            faceView.layer.borderWidth = 1;
            faceView.backgroundColor = [UIColor clearColor];
        }
        [self.view addSubview:faceView];
        faceView.frame = faceRect;
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
    _videoCamera.delegate = self;
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
