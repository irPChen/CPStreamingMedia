//
//  CPStreamingManager.m
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "CPStreamingManager.h"
#import "CPRecord.h"
#import "CPH264Encoder.h"
#import "CPAACEncoder.h"
#import "CPPushEngine.h"

@interface CPStreamingManager ()

@property (strong, nonatomic) CPRecord *record;

@end

@implementation CPStreamingManager

- (instancetype)initWithVideoSize:(CGSize)videoSize{
    
    self = [super init];
    
    if (self) {
        
        CPPushEngine *pushEngine = [[CPPushEngine alloc] initWithURL:@""];
        
        CPAACEncoder *audioEncoder = [[CPAACEncoder alloc] init];
        [audioEncoder setPushEngine:pushEngine];
        
        CPH264Encoder *videoEncoder = [[CPH264Encoder alloc] init];
        [videoEncoder setPushEngine:pushEngine];
        
        _record = [[CPRecord alloc] initWithVideoSize:videoSize];
        [_record setAudioEncoder:audioEncoder];
        [_record setVideoEncoder:videoEncoder];
        _previewLayer = _record.previewLayer;
        
        [_record start];
    }
    
    return self;
}

@end
