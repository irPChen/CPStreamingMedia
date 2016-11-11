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

#warning 修改输出管道类型
@property (strong, nonatomic) CPRTMPPushEngine *outputPiple;

- (void)encodeAudioSmapleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
