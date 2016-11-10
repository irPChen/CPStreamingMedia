//
//  CPAudioEncoding.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/10.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CPAudioEncoding <NSObject>

@required

@property (strong, nonatomic) CPPushEngine *outputPiple;

- (void)encodeAudioSmapleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
