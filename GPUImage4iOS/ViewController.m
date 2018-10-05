//
//  ViewController.m
//  GPUImage4iOS
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ViewController.h"
#import "Filter.h"
#import "PictureInput.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet RenderView *renderView;

@property (nonatomic, readwrite, strong) FilterPipeline *pipeline;

@property (nonatomic, readwrite, strong) Camera *camera;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, readwrite, strong) PictureInput *lookupTable;

@property (nonatomic, readwrite, strong) LookupFilter *lookupFilter;

@property (nonatomic, readwrite, strong) ColorInversion *colorInversion;

@property (nonatomic, readwrite, strong) Luminance *luminance;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _filterName;
    
    _renderView.orientation = ImageOrientationPortrait;
    _camera = [[Camera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraDevice:nil location:nil captureAsYUV:NO];
    _camera.runBenchmark = YES;

    if ([_filterName isEqualToString:@"ColorInversion"]) {
        
        _colorInversion = [[ColorInversion alloc] init];
        [_camera addPrecedence:_colorInversion];
        [_colorInversion addPrecedence:_renderView];
        
    } else if ([_filterName isEqualToString:@"Luminance"]) {
        
        _luminance = [[Luminance alloc] init];
        [_camera addPrecedence:_luminance];
        [_luminance addPrecedence:_renderView];
        
    } else if ([_filterName isEqualToString:@"LookupFilter"]) {
        
        UIImage *inputImage = [UIImage imageNamed:@"lookup_amatorka"];
        CGImageRef cgImage = inputImage.CGImage;
        _lookupTable = [[PictureInput alloc] initWithCGImage:cgImage];
        
        _lookupFilter = [[LookupFilter alloc] init];
        _lookupFilter.lookupImage = _lookupTable;
        
        [_camera addPrecedence:_lookupFilter];
        [_lookupFilter addPrecedence:_renderView];
        
    } else if ([_filterName isEqualToString:@"Pipeline"]) {
        _pipeline = [[FilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]                                                        input:_camera output:_renderView];
    }
    
    [_camera startCapture];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
