//
//  ViewController.m
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import "ViewController.h"
#import "CPRecord.h"
#import "CPEncodeH264.h"
#import "CPEncodeAAC.h"

@interface ViewController ()

@property (strong, nonatomic) CPRecord *record;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.record = [[CPRecord alloc] initWithVideoSize:CGSizeMake(self.view.frame.size.width, 350)];
    CPEncodeH264 *encodeH264 = [[CPEncodeH264 alloc] init];
    [self.record setEncodeH264:encodeH264];
    CPEncodeAAC *encodeAAC = [[CPEncodeAAC alloc] init];
    [self.record setEncodeAAC:encodeAAC];
    [self.view.layer addSublayer:self.record.previewLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
