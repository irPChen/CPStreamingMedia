# [CPStreamingMedia](https://ChenPengOnBitbucket@bitbucket.org/ChenPengOnBitbucket/cpstreamingmedia.git)

## Features
* Audio and video recording on iOS device.
* Audio and video hardware coding.
* Push compressed data to Server by RTMP protocol.
* Face Recognition.
* Video recordin by GPUImageCamera.
* Supporting real-time effect filter.

##Todo
* Read source from file.
* Add Push Buffer.

##Usage
```Objective-C
//Import
#import "CPStreamingManager.h"

//Init
CPStreamingManager *streamingManager = [[CPStreamingManager alloc] initWithVideoSize:self.view.frame.size];

//Add PreviewLayer
[self.view.layer addSublayer:self.streamingManager.previewLayer];
```

##Extension
####Extension Source
```Objective-C
//Necessary Property
@property (assign, nonatomic) id<CPSourceDelegate> delegate;
@property (assign, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

//Callback Manager
[self.delegate pushSampleBuffer:sampleBuffer WithType:CPAudioSampleBuffer];
[self.delegate pushSampleBuffer:sampleBuffer WithType:CPVideoSampleBuffer];
```
####Extension Encoder
AudioEncoder must conforms to the CPAudioEncoding protocol  implement the method.
VideoEncoder must conforms to the CPVideoEncoding protocol  implement the method.
The method is used to accept raw data.
```Objective-C
- (void)encodeAudioSmapleBuffer:(CMSampleBufferRef)sampleBuffer;
```
####Extension Protocol
Developer can extend network layer protocol by themselves, like http and so on.

## Authors
CPStreamingMedia was created by [陈鹏](https://github.com/ChenPengOnGitHub) .
