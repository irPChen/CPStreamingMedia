//
//  CPPush.h
//  Record
//
//  Created by P.Chen on 16/9/28.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface CPPush : NSObject

@property (assign, nonatomic) BOOL isFirstVideoPacket;

@property (assign, nonatomic) BOOL isFirstAudioPacket;

- (instancetype)initWithURL:(NSString*)URL;

- (void)pushAudioData:(NSData*)audioData sampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)pushVideoData:(NSData*)rawVideoData Buffer:(CMSampleBufferRef)sampleBuffer isKeyFrame:(BOOL)isKeyFrame;

@end

