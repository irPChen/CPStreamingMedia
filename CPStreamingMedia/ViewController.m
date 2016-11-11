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
    
    self.streamingManager = [[CPStreamingManager alloc] initWithVideoSize:self.view.frame.size];
    [self.view.layer addSublayer:self.streamingManager.previewLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
