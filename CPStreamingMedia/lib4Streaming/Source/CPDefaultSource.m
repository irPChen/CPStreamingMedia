//
//  CPDefaultSource.m
//  DefaultSource
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPDefaultSource.h"

@interface CPDefaultSource ()

@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureDevice *videoCaptureDevice;

@property (strong, nonatomic) AVCaptureDeviceInput *videoCaptureDeviceInput;

@property (strong, nonatomic) AVCaptureVideoDataOutput *videoDataOutput;

@property (strong, nonatomic) AVCaptureAudioDataOutput *audioDataOutput;

@property (strong, nonatomic) AVCaptureConnection *videoCaptureConnection;

@property (strong, nonatomic) AVCaptureConnection *audioCaptureConnection;

@property (strong, nonatomic) AVCaptureMetadataOutput *metadataOutput;

@property (strong, nonatomic) CALayer *faceLayer;

@end


@implementation CPDefaultSource

@synthesize delegate = _delegate;
@synthesize previewLayer = _previewLayer;

- (instancetype)initWithVideoSize:(CGSize)videoSize{
    
    self = [super init];
    
    if (self) {
        
        //1、初始化录制session
        self.captureSession = [[AVCaptureSession alloc] init];
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];//设置会话的sessionPreset属性, 这个属性影响视频的分辨率
        }
        
        //2、获取输入设备
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *camera in cameras) {
            if ([camera position] == AVCaptureDevicePositionFront) {//选择摄像头
                self.videoCaptureDevice = camera;
            }
        }
        
        NSArray *audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
        AVCaptureDevice *audioCaptureDevice = [audioDevices firstObject];
        
        //3、根据输入设备获取输入对象
        self.videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.videoCaptureDevice error:nil];
        AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:nil];
        
        //4、初始化输出设备
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        dispatch_queue_t videoQueue = dispatch_queue_create("com.cp.video", NULL);
        [self.videoDataOutput setSampleBufferDelegate:self queue:videoQueue];
        NSDictionary *videoSettings = @{(__bridge id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
        self.videoDataOutput.videoSettings = videoSettings;
        //丢弃延时帧
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        
        self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        dispatch_queue_t audioQueue = dispatch_queue_create("com.cp.audio", NULL);
        [self.audioDataOutput setSampleBufferDelegate:self queue:audioQueue];
        
        //添加人脸识别输出
        self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        dispatch_queue_t metadataQueue = dispatch_queue_create("com.cp.metadata", NULL);
        [self.metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
        
        [self.captureSession beginConfiguration];
        
        //5、将输入、输出设备添加到会话中
        if ([self.captureSession canAddInput:self.videoCaptureDeviceInput]) {
            [self.captureSession addInput:self.videoCaptureDeviceInput];
        }
        if ([self.captureSession canAddInput:audioCaptureDeviceInput]) {
            [self.captureSession addInput:audioCaptureDeviceInput];
        }
        if ([self.captureSession canAddOutput:self.videoDataOutput]) {
            [self.captureSession addOutput:self.videoDataOutput];
        }
        if ([self.captureSession canAddOutput:self.audioDataOutput]) {
            [self.captureSession addOutput:self.audioDataOutput];
        }
        if ([self.captureSession canAddOutput:self.metadataOutput]) {
            [self.captureSession addOutput:self.metadataOutput];
            [self.metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
        }
        
        //6、添加视频预览
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_previewLayer setFrame:CGRectMake(0, 0, videoSize.width, videoSize.height)];
        
        self.videoCaptureConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        self.audioCaptureConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
        
        [self.captureSession commitConfiguration];
    }
    
    return self;
}

- (void)start{
    //启动会话
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if (connection == self.audioCaptureConnection) {
        //数据推给音频编码器
        [_delegate pushSampleBuffer:sampleBuffer WithType:CPAudioSampleBuffer];
    }else if (self.videoDataOutput == captureOutput){
        //数据推给视频编码器
        [_delegate pushSampleBuffer:sampleBuffer WithType:CPVideoSampleBuffer];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CALayer *faceObject = [metadataObjects firstObject];
            
            if (self.faceLayer == nil) {
                self.faceLayer = [[CALayer alloc] init];
                [self.faceLayer setBorderColor:[UIColor redColor].CGColor];
                [self.faceLayer setBorderWidth:1];
                [self.previewLayer addSublayer:self.faceLayer];
            }
            
            CGRect faceBounds = faceObject.bounds;
            CGSize viewSize = self.previewLayer.bounds.size;
            
            [self.faceLayer setBounds:CGRectMake(0, 0, faceBounds.size.width * viewSize.height, faceBounds.size.height * viewSize.width)];
            self.faceLayer.position = CGPointMake(viewSize.width * (faceBounds.origin.y + faceBounds.size.height / 2), viewSize.height * (faceBounds.origin.x + faceBounds.size.width / 2));
        });
    }
}

//录制回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    //    NSLog(@"didDropSampleBuffer:%@",sampleBuffer);
}

- (void)switchCamera{
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] != [self.videoCaptureDevice position]) {
            self.videoCaptureDevice = camera;
            break;
        }
    }
    AVCaptureDeviceInput *videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.videoCaptureDevice error:nil];
    
    [self.captureSession beginConfiguration];
    
    [self.videoCaptureDevice lockForConfiguration:nil];
    [self.captureSession removeInput:self.videoCaptureDeviceInput];
    [self.videoCaptureDevice unlockForConfiguration];
    
    if ([self.captureSession canAddInput:videoCaptureDeviceInput]) {
        [self.captureSession addInput:videoCaptureDeviceInput];
        self.videoCaptureDeviceInput = videoCaptureDeviceInput;
    }
    
    [self.captureSession commitConfiguration];
}

@end
