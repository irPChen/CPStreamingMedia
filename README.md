# [CPStreamingMedia](https://ChenPengOnBitbucket@bitbucket.org/ChenPengOnBitbucket/cpstreamingmedia.git)

## Features
* iOS音频、视频录制
* iOS音频、视频硬件编码
* libRTMP推流
* 视频录制人脸位置识别

##Todo
* 数据源、编码器和推流组件模块化
* 添加GPUImage和本地视频文件两种数据源
* 推送数据本地Buffer

##Usage
1. ***#import "CPStreamingManager.h"***
2. ***Init***
CPStreamingManager *streamingManager = [[CPStreamingManager alloc] initWithVideoSize:self.view.frame.size];
3. ***Add PreviewLayer***
[self.view.layer addSublayer:self.streamingManager.previewLayer];

##Extension
###Extension Source
***Callback Manager***
```Objective-C
[self.delegate pushSampleBuffer:sampleBuffer WithType:CPAudioSampleBuffer];
[self.delegate pushSampleBuffer:sampleBuffer WithType:CPVideoSampleBuffer];
```
###Extension Encoder

## Authors
CPStreamingMedia was created by [陈鹏](https://github.com/ChenPengOnGitHub) .
