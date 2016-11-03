//
//  ViewController.m
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "ViewController.h"
#import "CPStreamingManager.h"
#import "CPH264Encoder.h"
#import "CPAACEncoder.h"
#import "CPPushEngine.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CPStreamingManager *streamingManager = [[CPStreamingManager alloc] initWithVideoSize:self.view.frame.size];
    [self.view.layer addSublayer:streamingManager.previewLayer];
    
    CPPushEngine *pushEngine = [[CPPushEngine alloc] initWithURL:@""];
    
    CPAACEncoder *audioEncoder = [[CPAACEncoder alloc] init];
    [audioEncoder setPushEngine:pushEngine];
    
    CPH264Encoder *videoEncoder = [[CPH264Encoder alloc] init];
    [videoEncoder setPushEngine:pushEngine];
    
    
    _record = [[CPRecord alloc] initWithVideoSize:self.view.frame.size];
    [_record setAudioEncoder:audioEncoder];
    [_record setVideoEncoder:videoEncoder];
    _previewLayer = _record.previewLayer;
    
    [self.view.layer addSublayer:_previewLayer];
    
    [_record start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
