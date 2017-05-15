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
@property (assign, nonatomic) BOOL isRerod;

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
    
    UIButton *controlBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-180)/4, self.view.frame.size.height-120, 60, 60)];
    [controlBtn setImage:[UIImage imageNamed:@"Live_play.png"] forState:UIControlStateNormal];
    [controlBtn addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlBtn];
    
    UIButton *switchCameraBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-180)/4*2+60, self.view.frame.size.height-120, 60, 60)];
    [switchCameraBtn setImage:[UIImage imageNamed:@"Live_camera.png"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(toggleCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchCameraBtn];
    
    UIButton *switchTorchBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-180)/4*3+120, self.view.frame.size.height-120, 60, 60)];
    [switchTorchBtn setImage:[UIImage imageNamed:@"Live_torch.png"] forState:UIControlStateNormal];
    [switchTorchBtn addTarget:self action:@selector(switchTorchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchTorchBtn];
    
#warning 测试
    [self controlAction:controlBtn];
}

- (void)controlAction:(UIButton*)btn{
    _isRerod ? [self.streamingManager stop] : [self.streamingManager start];
    UIImage *image = _isRerod ? [UIImage imageNamed:@"Live_play.png"] : [UIImage imageNamed:@"Live_stop.png"];
    [btn setImage:image forState:UIControlStateNormal];
    _isRerod = !_isRerod;
}

- (void)toggleCameraAction{
    [self.streamingManager toggleCamera];
}

- (void)switchTorchAction{
    [self.streamingManager switchTorch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
