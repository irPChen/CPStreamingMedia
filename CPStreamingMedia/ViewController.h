//
//  ViewController.h
//  CPStreamingMedia
//
//  Created by P.Chen on 2016/11/3.
//  Copyright © 2016年 P.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPRecord.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) CPRecord *record;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

