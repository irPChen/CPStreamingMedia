//
//  CPVideoEncoding.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/10.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPPushEngine.h"

@protocol CPVideoEncoding <NSObject>

@required

@property (strong, nonatomic) CPPushEngine *outputPiple;

- (void)encodeVideoBuffer:(CMSampleBufferRef)sampleBuffer;

@end
