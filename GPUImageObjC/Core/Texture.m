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
    int size;
    if (!normalized) {
        xLimit = self.texture.width;
        yLimit = self.texture.height;
    }
    
    switch (inputRotation) {
        case RotationCounterclockwise: {
            float temp[] = {0.0, yLimit, 0.0, 0.0, xLimit, yLimit, xLimit, 0.0};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
            
        }
        case RotationClockwise: {
            float temp[] = {xLimit, 0.0, xLimit, yLimit, 0.0, 0.0, 0.0, yLimit};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
            
        case Rotation180: {
            float temp[] = {xLimit, yLimit, 0.0, yLimit, xLimit, 0.0, 0.0, 0.0};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
            
        case RotationFlipHorizontally: {
            float temp[] = {xLimit, 0.0, 0.0, 0.0, xLimit, yLimit, 0.0, yLimit};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
            
        case RotationFlipVertically: {
            float temp[] = {0.0, yLimit, xLimit, yLimit, 0.0, 0.0, xLimit, 0.0};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
        
        case RotationClockwiseAndFlipVertically: {
            float temp[] = {0.0, 0.0, 0.0, yLimit, xLimit, 0.0, xLimit, yLimit};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
            
        case RotationClockwiseAndFlipHorizontally: {
            float temp[] = {xLimit, yLimit, xLimit, 0.0, 0.0, yLimit, 0.0, 0.0};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
            
        case RotationNone:
        default: {
            float temp[] = {0.0, 0.0, xLimit, 0.0, 0.0, yLimit, xLimit, yLimit};
            size = sizeof(temp) / sizeof(float);
            result = newFloatArray(temp, size);
        }
    }
    completion(result, size);
}

@end



