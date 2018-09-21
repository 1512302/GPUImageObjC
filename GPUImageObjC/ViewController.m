//
//  ViewController.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/12/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ViewController.h"
#import "RenderView.h"
#import "PictureInput.h"
#import "SaturationAdjustment.h"

@interface ViewController ()

@property (weak) IBOutlet RenderView *renderView;

@property (nonatomic, readwrite, strong) PictureInput *image;

@property (nonatomic, readwrite, strong) SaturationAdjustment *filter;

@property (weak) IBOutlet NSSlider *slider;


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSImage *inputImage = [NSImage imageNamed:@"Lambeau.jpg"];
    CGImageRef cgImage = [inputImage CGImageForProposedRect:nil context:nil hints:nil];
    
    _filter = [[SaturationAdjustment alloc] init];
    _filter.saturation = 1.0;
    
    _image = [[PictureInput alloc] initWithCGImage:cgImage];
    [_image additionPrecedence:_filter];
    [_filter additionPrecedence:_renderView];
    [_image processImage];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)sliderAction:(id)sender {
    _filter.saturation = _slider.floatValue * 2.0 / _slider.maxValue;
    [_image processImage];
}

@end
