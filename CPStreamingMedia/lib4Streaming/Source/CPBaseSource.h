//
//  CPBaseSource.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/10.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPStreamingManager.h"

typedef NS_ENUM(NSInteger, CPSourceType) {
    CPAudioOnly = 0,
    CPVideoOnly = 1,
    CPAudioAndVideo = 2
};

@interface CPBaseSource : NSObject

@property (assign, nonatomic) CPStreamingManager *delegate;

@property (assign, nonatomic) CPSourceType sourceType;

@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (void)start;

@end
