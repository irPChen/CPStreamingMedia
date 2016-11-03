//
//  CPEncodeAAC.h
//  Record
//
//  Created by P.Chen on 2016/10/10.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CPPush.h"

@interface CPEncodeAAC : NSObject

@property (strong, nonatomic) CPPush *push;

- (void)encodeAudioSmapleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
