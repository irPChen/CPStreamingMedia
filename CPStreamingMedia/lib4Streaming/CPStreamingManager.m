//
//  CPStreamingManager.m
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPStreamingManager.h"
#import "CPBaseSource.h"
#import "CPDefaultSource.h"
//#import "CPH264Encoder.h"
//#import "CPAACEncoder.h"
#import "CPPushEngine.h"
//#import "CPAudioEncoding.h"
//#import "CPVideoEncoding.h"

@interface CPStreamingManager ()

@property (strong, nonatomic) CPBaseSource *audioSource;

@property (strong, nonatomic) CPBaseSource *videoSource;

@property (strong, nonatomic) id<CPAudioEncoding> audioEncoder;

@property (strong, nonatomic) id<CPVideoEncoding> videoEncoder;

@end

@implementation CPStreamingManager

- (instancetype)initWithVideoSize:(CGSize)videoSize{
    
    self = [super init];
    
    if (self) {
        
        CPPushEngine *pushEngine = [[CPPushEngine alloc] initWithURL:@"rtmp://10.57.6.116/live/gha8l7"];
        
        self.audioEncoder = [[CPAACEncoder alloc] init];
        [self.audioEncoder setOutputPiple:pushEngine];
        //[self.audioEncoder registPush:pushEngine];

        //[self.audioEncoder setPushEngine:pushEngine];
        
        self.videoEncoder = [[CPH264Encoder alloc] init];
        //[self.videoEncoder registPush:pushEngine];
        //[self.videoEncoder set];
        [self.videoEncoder setOutputPiple:pushEngine];
        
        //数据源注册
        /*

        self.record = [[CPDefaultSource alloc] initWithVideoSize:videoSize];
        //[self.record setAudioEncoder:audioEncoder];
        //[self.record setVideoEncoder:videoEncoder];
        [self.record setDelegate:self];
        self.previewLayer = self.record.previewLayer;
        [self.record start];
         */

        
        
        //数据源注册
        CPDefaultSource *defaultSource = [[CPDefaultSource alloc] initWithVideoSize:videoSize];
        [defaultSource setDelegate:self];
        [self registAudioSource:nil VideoSource:defaultSource];
        [self.videoSource start];
    }
    
    return self;
}

- (void)registAudioSource:(CPBaseSource*)audioSource VideoSource:(CPBaseSource*)videoSource{
    
    if (audioSource) {
        self.audioSource = audioSource;
        NSLog(@"音频源注册成功");
    }
    
    if (videoSource) {
        self.videoSource = videoSource;
        self.previewLayer = self.videoSource.previewLayer;
        NSLog(@"视频源注册成功");
    }
    
    if (!audioSource || !videoSource) {
        if (videoSource && videoSource.sourceType == CPAudioAndVideo) {
            self.audioSource = videoSource;
            NSLog(@"音频源注册成功");
        }
        if (audioSource && audioSource.sourceType == CPAudioAndVideo) {
            self.videoSource = self.audioSource;
            self.previewLayer = self.videoSource.previewLayer;
            NSLog(@"视频源注册成功");
        }
    }
    
    if (!self.audioSource) {
        NSLog(@"音频源注册失败");
    }
    
    if (!self.videoSource) {
        NSLog(@"视频源注册失败");
    }
}


- (void)registerAudioEncoder{
}

- (void)registerVideoEncoder{
}

- (void)registerPushEngine{
}


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

@end
