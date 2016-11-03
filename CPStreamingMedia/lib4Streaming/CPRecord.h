//
//  CPRecord.h
//  Record
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CPH264Encoder.h"
#import "CPAACEncoder.h"
#import <UIKit/UIKit.h>

@interface CPRecord : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) CPH264Encoder *videoEncoder;

@property (strong, nonatomic) CPAACEncoder *audioEncoder;

- (void)start;

- (instancetype)initWithVideoSize:(CGSize)videoSize;

@end
