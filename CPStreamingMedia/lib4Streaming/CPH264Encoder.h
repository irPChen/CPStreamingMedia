//
//  CPH264Encoder.h
//  Record
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "CPPushEngine.h"

@interface CPH264Encoder : NSObject

@property (strong, nonatomic) CPPushEngine *pushEngine;

- (void)encodeVideoBuffer:(CMSampleBufferRef)sampleBuffer;

@end
