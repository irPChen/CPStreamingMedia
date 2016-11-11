//
//  CPStreamingManager.m
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPStreamingManager.h"
#import "CPDefaultSource.h"
#import "CPH264Encoder.h"
#import "CPAACEncoder.h"
#import "CPRTMPPushEngine.h"

@interface CPStreamingManager ()

//使用其它数据源时需要修改类型
@property (strong, nonatomic) CPDefaultSource *audioSource;
@property (strong, nonatomic) CPDefaultSource *videoSource;

@property (strong, nonatomic) id<CPAudioEncoding> audioEncoder;

@property (strong, nonatomic) id<CPVideoEncoding> videoEncoder;

@property (strong, nonatomic) CPRTMPPushEngine *pushEngine;

@end

@implementation CPStreamingManager

- (instancetype)initWithVideoSize:(CGSize)videoSize{
    
    self = [super init];
    
    if (self) {
        
        //创建数据源
        CPDefaultSource *defaultSource = [[CPDefaultSource alloc] initWithVideoSize:videoSize];
        [defaultSource setDelegate:self];
        //注册音、视频数据源
        [self registAudioSource:defaultSource VideoSource:defaultSource];
        
        self.pushEngine = [[CPRTMPPushEngine alloc] initWithURL:@"rtmp://10.57.6.116/live/gha8l7"];

        self.audioEncoder = [[CPAACEncoder alloc] init];
        [self.audioEncoder setOutputPiple:self.pushEngine];
        
        self.videoEncoder = [[CPH264Encoder alloc] init];
        [self.videoEncoder setOutputPiple:self.pushEngine];
        
        [self start];
    }
    
    return self;
}

//注册音、视频数据源到Manager
- (void)registAudioSource:(id)audioSource VideoSource:(id)videoSource{
    
    if (audioSource) {
        self.audioSource = audioSource;
        NSLog(@"音频源注册成功");
    }else{
        NSLog(@"音频源注册失败");
    }
    
    if (videoSource) {
        self.videoSource = videoSource;
        self.previewLayer = self.videoSource.previewLayer;
        NSLog(@"视频源注册成功");
    }else{
        NSLog(@"视频源注册失败");
    }
}

#pragma mark -- CPSourceDelegate
- (void)pushSampleBuffer:(CMSampleBufferRef)sampleBuffer WithType:(CPSampleBufferType)type{
    
    switch (type) {
        case CPAudioSampleBuffer:{
            [self.audioEncoder encodeAudioSmapleBuffer:sampleBuffer];
        }
            break;
            
        case CPVideoSampleBuffer:{
            [self.videoEncoder encodeVideoBuffer:sampleBuffer];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 测试方法
- (void)start{
    [self.videoSource start];
}

@end
