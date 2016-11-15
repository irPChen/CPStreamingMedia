//
//  CPGPUImageCameraSource.m
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/15.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPGPUImageCameraSource.h"
#import "GPUImageView.h"
#import "GPUImageRawDataOutput.h"
//使用的滤镜
#import "GPUImageColorPackingFilter.h"

@interface CPGPUImageCameraSource ()

@property (strong, nonatomic) GPUImageFilter *filter;

@property (assign, nonatomic) CMTime lastSampleTime;

@property (assign, nonatomic) CMSampleTimingInfo timingInfoOut;

@end

@implementation CPGPUImageCameraSource

- (instancetype)initWithVideoSize:(CGSize)videoSize{
    
    self = [super initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    
    if (self) {
        
        self.outputImageOrientation = UIInterfaceOrientationPortrait;
        [self setDelegate:self];
        
        GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, videoSize.width, videoSize.height)];
        self.previewLayer = filteredVideoView.layer;
        
        self.filter =  [[GPUImageColorPackingFilter alloc] init];
        
        [self addTarget:self.filter];
        [self.filter addTarget:filteredVideoView];
        
        GPUImageRawDataOutput *rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:videoSize resultsInBGRAFormat:YES];
        [self.filter addTarget:rawDataOutput];
        
        __weak GPUImageRawDataOutput *weakOutput = rawDataOutput;
        __weak typeof(self) weakSelf = self;
        
        [rawDataOutput setNewFrameAvailableBlock:^{
            
            __strong GPUImageRawDataOutput *strongOutput = weakOutput;
            [strongOutput lockFramebufferForReading];
            
            GLubyte *outputBytes = [strongOutput rawBytesForImage];
            NSInteger bytesPerRow = [strongOutput bytesPerRowInOutput];
            CVPixelBufferRef pixelBuffer = NULL;
            CVPixelBufferCreateWithBytes(kCFAllocatorDefault, videoSize.width, videoSize.height, kCVPixelFormatType_32BGRA, outputBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
            
            CFRetain(pixelBuffer);
            CMSampleBufferRef newSampleBuffer = NULL;
            CMTime frameTime = CMTimeMake(1, 30);
            CMTime currentTime = CMTimeAdd(_lastSampleTime, frameTime);
            CMSampleTimingInfo timing = {frameTime, currentTime, kCMTimeInvalid};
            
            OSStatus result = 0;
            CMVideoFormatDescriptionRef videoInfo = NULL;
            result = CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixelBuffer, &videoInfo);
            CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, true, NULL, NULL, videoInfo, &_timingInfoOut, &newSampleBuffer);
            CFRelease(pixelBuffer);

            _lastSampleTime = currentTime;
            
            [self.sourceDelegate pushSampleBuffer:newSampleBuffer WithType:CPVideoSampleBuffer];
            
            [strongOutput unlockFramebufferAfterReading];
            CFRelease(pixelBuffer);
        }];
    }
    
    return self;
}

- (void)start{
    [self startCameraCapture];
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    CMSampleBufferGetSampleTimingInfo(sampleBuffer, 0, &_timingInfoOut);
}

@end
