//
//  CPRecord.m
//  Record
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPRecord.h"

@interface CPRecord ()

@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureVideoDataOutput *videoDataOutput;

@property (strong, nonatomic) AVCaptureAudioDataOutput *audioDataOutput;

@property (strong, nonatomic) AVCaptureConnection *videoCaptureConnection;

@property (strong, nonatomic) AVCaptureConnection *audioCaptureConnection;

@end


@implementation CPRecord

- (instancetype)initWithVideoSize:(CGSize)videoSize{
    
    self = [super init];
    
    if (self) {
        
        //1、初始化录制session
        self.captureSession = [[AVCaptureSession alloc] init];
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];//设置会话的sessionPreset属性, 这个属性影响视频的分辨率
        }
        
        //2、获取输入设备
        AVCaptureDevice *videoCaptureDevice;
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *camera in cameras) {
            if ([camera position] == AVCaptureDevicePositionBack) {//选择摄像头
                videoCaptureDevice = camera;
            }
        }
        
        NSArray *audioDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
        AVCaptureDevice *audioCaptureDevice = [audioDevices firstObject];
        
        //3、根据输入设备获取输入对象
        AVCaptureDeviceInput *videoCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoCaptureDevice error:nil];
        AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:nil];
        
        //4、初始化输出设备
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        dispatch_queue_t videoQueue = dispatch_queue_create("com.cp.video", NULL);
        [self.videoDataOutput setSampleBufferDelegate:self queue:videoQueue];
        NSDictionary *videoSettings = @{(__bridge id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
        self.videoDataOutput.videoSettings = videoSettings;
        
        self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
        dispatch_queue_t audioQueue = dispatch_queue_create("com.cp.audio", NULL);
        [self.audioDataOutput setSampleBufferDelegate:self queue:audioQueue];
        
        //5、将输入、输出设备添加到会话中
        if ([self.captureSession canAddInput:videoCaptureDeviceInput]) {
            [self.captureSession addInput:videoCaptureDeviceInput];
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
        
        //6、添加视频预览
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.previewLayer setFrame:CGRectMake(0, 0, videoSize.width, videoSize.height)];
        //        [[[self view] layer] addSublayer:previewLayer];

        self.videoCaptureConnection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        self.audioCaptureConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
        
        //7、启动会话
        [self.captureSession startRunning];
    }
    
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    if (connection == self.audioCaptureConnection) {
        //数据推给音频编码器
        //[self.encodeAAC encodeAudioSmapleBuffer:sampleBuffer];
    }else if (self.videoDataOutput == captureOutput){
        //数据推给视频编码器
        [self.encodeH264 encodeVideoBuffer:sampleBuffer];
    }
}

//录制回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    NSLog(@"didDropSampleBuffer:%@",sampleBuffer);
}

@end
