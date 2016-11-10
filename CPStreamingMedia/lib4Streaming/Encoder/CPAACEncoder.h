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
#import "CPAudioEncoding.h"

@interface CPAACEncoder : NSObject <CPAudioEncoding>

@property (strong, nonatomic) CPPushEngine *pushEngine;

@end
