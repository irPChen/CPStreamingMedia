//
//  CPDefaultSource.h
//  DefaultSource
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CPH264Encoder.h"
#import "CPAACEncoder.h"
#import "CPBaseSource.h"
#import <UIKit/UIKit.h>

@interface CPDefaultSource : CPBaseSource <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) CPAACEncoder *audioEncoder;

- (void)start;

- (instancetype)initWithVideoSize:(CGSize)videoSize;

@end
