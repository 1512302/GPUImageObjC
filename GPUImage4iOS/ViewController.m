//
//  ViewController.m
//  GPUImage4iOS
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet RenderView *renderView;

@property (nonatomic, readwrite, strong) Camera *camera;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _camera = [[Camera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraDevice:nil location:nil captureAsYUV:false];
    _camera.runBenchmark = true;
    [_camera additionPrecedence:_renderView];
    [_camera startCapture];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
