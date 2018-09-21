//
//  Texture.m
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights temperved.
//

#import "Texture.h"
#import "MetalRenderingDevice.h"
#import "CommonFuntion.h"

#define kNumOfArray 8

const float yLimit = 1.0;

const float xLimit = 1.0;

const float temp1[] = {0.0, yLimit, 0.0, 0.0, xLimit, yLimit, xLimit, 0.0};

const float temp2[] = {xLimit, 0.0, xLimit, yLimit, 0.0, 0.0, 0.0, yLimit};

const float temp3[] = {xLimit, yLimit, 0.0, yLimit, xLimit, 0.0, 0.0, 0.0};

const float temp4[] = {xLimit, 0.0, 0.0, 0.0, xLimit, yLimit, 0.0, yLimit};

const float temp5[] = {0.0, yLimit, xLimit, yLimit, 0.0, 0.0, xLimit, 0.0};

const float temp6[] = {0.0, 0.0, 0.0, yLimit, xLimit, 0.0, xLimit, yLimit};

const float temp7[] = {xLimit, yLimit, xLimit, 0.0, 0.0, yLimit, 0.0, 0.0};

const float temp8[] = {0.0, 0.0, xLimit, 0.0, 0.0, yLimit, xLimit, yLimit};


@implementation Texture

- (void)commonInit {
    _timingStyle = TextureTimingStillImage;
}

- (instancetype)initWithOrientation:(ImageOrientation)orientation texture:(id<MTLTexture>)texture {
    self = [super init];
    if (self) {
        [self commonInit];
        _orientation = orientation;
        _texture = texture;
    }
    return self;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device orientation:(ImageOrientation)orientation width:(int32_t)width height:(int32_t)height {
    self = [super init];
    if (self) {
        [self commonInit];
        MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm width:width height:height mipmapped:false];
        
        textureDescriptor.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead | MTLTextureUsageShaderWrite;
        
        _orientation = orientation;
        _texture = [[MetalRenderingDevice shared].device newTextureWithDescriptor:textureDescriptor];
    }
    return self;
}




- (void)textureCoodinatesForOutputOrientation:(ImageOrientation)outputOrientation normalized:(boolean_t)normalized completion:(void(^)(float *vertexs, int size))completion {
    Rotation inputRotation = rotation(self.orientation, outputOrientation);
    
    float xLimit = 1.0;
    float yLimit = 1.0;
    
    float *result;
    int size = 8;
    if (!normalized) {
        xLimit = self.texture.width;
        yLimit = self.texture.height;
    }
    
    switch (inputRotation) {
        case RotationCounterclockwise: {
            result = (float *)temp1;
            break;
        }
        case RotationClockwise: {
            result = (float *)temp2;
            break;
        }
        case Rotation180: {
            result = (float *)temp3;
            break;
        }
            
        case RotationFlipHorizontally: {
            result = (float *)temp4;
            break;
        }
            
        case RotationFlipVertically: {
            result = (float *)temp5;
            break;
        }
        
        case RotationClockwiseAndFlipVertically: {
            result = (float *)temp6;
            break;
        }
            
        case RotationClockwiseAndFlipHorizontally: {
            result = (float *)temp7;
            break;
        }
            
        case RotationNone:
        default: {
            result = (float *)temp8;
            break;
        }
    }
    if (completion) {
        completion(result, size);
    }
}

@end



