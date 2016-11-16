//
//  CPGPUImageCameraSource.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/15.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CPSourceDelegate.h"
#import "GPUImageVideoCamera.h"

@interface CPGPUImageCameraSource : NSObject <GPUImageVideoCameraDelegate>

//推数据到Manager
@property (assign, nonatomic) id<CPSourceDelegate> delegate;

//预览View
@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (instancetype)initWithVideoSize:(CGSize)videoSize;

- (void)start;

@end
