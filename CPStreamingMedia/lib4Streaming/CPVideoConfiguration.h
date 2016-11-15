//
//  CPVideoConfiguration.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/9.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPVideoConfiguration : NSObject

@property (strong, nonatomic) NSString *preset;

//帧率
@property (assign, nonatomic) int frameRate;

//关键帧间隔
@property (assign, nonatomic) int maxKeyFrameInterval;

//开启熵编码
@property (assign, nonatomic) BOOL openEntropyMode;

@end
