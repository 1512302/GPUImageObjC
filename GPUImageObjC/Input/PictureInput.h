//
//  PictureInput.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 8/30/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pipeline.h"
#import "Texture.h"
#import "MetalRenderingDevice.h"

@import MetalKit;
@interface PictureInput : ImageSource

@property (nonatomic, readwrite, strong) Texture *internalTexture;

@property (nonatomic, readwrite) Boolean hasProcessedImage;

@property (nonatomic, readwrite) CGImageRef internalImage;

- (instancetype)init;

- (instancetype)initWithCGImage:(CGImageRef)image;

- (void)processImage;

//- (instancetype)initWithCGImage:(CGImageRef)image smoothlyScaleOutput:(boolean_t)smoothlyScaleOutput orientation:(ImageOrientation)orientation;
//
//- (instancetype)initWithNSImage:(NSImage *)image smoothlyScaleOutput:(boolean_t)smoothlyScaleOutput orientation:(ImageOrientation)orientation;
//
//- (instancetype)initWithImageName:(NSString *)imageName smoothlyScaleOutput:(boolean_t)smoothlyScaleOutput orientation:(ImageOrientation)orientation;
//
//- (boolean_t)processImageWithSynchronously:(boolean_t)synchronously;
//
//- (boolean_t)processImage;
//
//- (void)transmitPreviousImageToTarget:(id)target atIndex:(uint32_t)index;

@end
