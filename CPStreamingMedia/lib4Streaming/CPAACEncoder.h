//
//  CPAACEncoder.h
//  Record
//
//  Created by P.Chen on 2016/10/10.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CPPushEngine.h"

@interface CPAACEncoder : NSObject

@property (strong, nonatomic) CPPushEngine *pushEngine;

- (void)encodeAudioSmapleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
