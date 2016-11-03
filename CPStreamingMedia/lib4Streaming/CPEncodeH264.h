//
//  CPEncodeH264.h
//  Record
//
//  Created by 陈鹏 on 16/9/27.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "CPPush.h"

@interface CPEncodeH264 : NSObject

- (void)encodeVideoBuffer:(CMSampleBufferRef)sampleBuffer;

@end
