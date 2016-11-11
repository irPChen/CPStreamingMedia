//
//  CPDefaultSource.h
//  DefaultSource
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CPSourceDelegate.h"

@interface CPDefaultSource : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

//推数据到Manager
@property (assign, nonatomic) id<CPSourceDelegate> delegate;

//预览View
@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (instancetype)initWithVideoSize:(CGSize)videoSize;

- (void)start;

@end
