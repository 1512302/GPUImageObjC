//
//  ViewController.m
//  GPUImage4iOS
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ViewController.h"
#import "Filter.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet RenderView *renderView;

@property (nonatomic, readwrite, strong) FilterPipeline *pipeline;

@property (nonatomic, readwrite, strong) Camera *camera;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _renderView.orientation = ImageOrientationPortrait;	
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(orientationChanged:)
//     name:UIDeviceOrientationDidChangeNotification
//     object:[UIDevice currentDevice]];
//
    _camera = [[Camera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraDevice:nil location:nil captureAsYUV:NO];
    _camera.runBenchmark = YES;
    
    
    _pipeline = [[FilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]                                                        input:_camera output:_renderView];
    
    [_camera startCapture];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
