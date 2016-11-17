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
#import "CPSourceProtocol.h"

@interface CPDefaultSource : NSObject <CPSourceProtocol, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

- (instancetype)initWithVideoSize:(CGSize)videoSize;

@end
