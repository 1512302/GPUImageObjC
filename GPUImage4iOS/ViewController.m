//
//  ViewController.m
//  GPUImage4iOS
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ViewController.h"
#import "MetalRenderingDevice.h"
#import "SaturationAdjustment.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet RenderView *renderView;

@property (nonatomic, readwrite, strong) SaturationAdjustment *filter;

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
    
    _filter = [SaturationAdjustment new];
    _filter.saturation = 1.0;
    
    [_camera additionPrecedence:_filter];
    [_filter additionPrecedence:_renderView];
    //[_camera additionPrecedence:_renderView];
    
    [_camera startCapture];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSliderAction:(id)sender {
    _filter.saturation = _slider.value * 2.0 / _slider.maximumValue;
}

- (void)orientationChanged:(NSNotification *)note {
    
}

@end
