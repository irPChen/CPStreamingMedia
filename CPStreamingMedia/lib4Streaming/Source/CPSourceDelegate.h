//
//  CPSourceDelegate.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/11.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CPSampleBufferType) {
    CPVideoSampleBuffer = 0,
    CPAudioSampleBuffer = 1,
};

@protocol CPSourceDelegate <NSObject>

@required
- (void)pushSampleBuffer:(CMSampleBufferRef)sampleBuffer WithType:(CPSampleBufferType)type;

@end
