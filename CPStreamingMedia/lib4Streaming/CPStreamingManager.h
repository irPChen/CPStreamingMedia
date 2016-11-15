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
#import "CPSourceDelegate.h"
#import "CPVideoConfiguration.h"
#import "CPAudioConfiguration.h"

@interface CPStreamingManager : NSObject <CPSourceDelegate>

@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (instancetype)initWithVideoSize:(CGSize)videoSize;

- (instancetype)initWithAudioConfiguration:(CPAudioConfiguration*)audioConfiguration VideoConfiguration:(CPVideoConfiguration*)videoConfiguration;

@end

