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
#import "CPSourceProtocol.h"

@interface CPGPUImageCameraSource : NSObject <CPSourceProtocol, GPUImageVideoCameraDelegate>

- (instancetype)initWithVideoSize:(CGSize)videoSize;

@end
