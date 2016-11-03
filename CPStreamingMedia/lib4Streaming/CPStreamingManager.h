//
//  CPStreamingManager.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>

@interface CPStreamingManager : NSObject

@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (instancetype)initWithVideoSize:(CGSize)videoSize;

@end
