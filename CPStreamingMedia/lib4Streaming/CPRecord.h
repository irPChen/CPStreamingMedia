//
//  CPRecord.h
//  Record
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CPEncodeH264.h"
#import "CPEncodeAAC.h"

@interface CPRecord : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

- (instancetype)initWithVideoSize:(CGSize)videoSize;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) CPEncodeH264 *encodeH264;
@property (strong, nonatomic) CPEncodeAAC *encodeAAC;

@end
