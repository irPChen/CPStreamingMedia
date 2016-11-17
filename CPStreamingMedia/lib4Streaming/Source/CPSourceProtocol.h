//
//  CPSourceProtocol.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/17.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CPSourceProtocol <NSObject>

//推数据到Manager
@property (assign, nonatomic) id<CPSourceDelegate> delegate;

//预览View
@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

- (void)start;

@optional
- (void)toggleCamera;

- (void)switchTorch;

@end
