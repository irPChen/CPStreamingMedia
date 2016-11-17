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
#import "CPRTMPPushEngine.h"

@interface ViewController ()

@property (strong, nonatomic) CPStreamingManager *streamingManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CPAudioConfiguration *audioConfiguration = [[CPAudioConfiguration alloc] init];
    
    CPVideoConfiguration *videoConfiguration = [[CPVideoConfiguration alloc] init];
    [videoConfiguration setPreset:AVCaptureSessionPreset1280x720];
    
//    self.streamingManager = [[CPStreamingManager alloc] initWithAudioConfiguration:audioConfiguration VideoConfiguration:videoConfiguration];
    self.streamingManager = [[CPStreamingManager alloc] initWithVideoSize:self.view.frame.size];
    [self.view.layer addSublayer:self.streamingManager.previewLayer];
    
    UIButton *switchCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, self.view.frame.size.height-120, 80, 80)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"Live_camera.png"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchCameraBtn];
}

- (void)switchCameraAction{
    [self.streamingManager switchCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
