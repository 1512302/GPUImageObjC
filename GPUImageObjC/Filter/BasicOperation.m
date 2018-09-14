//
//  BasicOperation.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 8/31/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "BasicOperation.h"


@implementation BasicOperation

@synthesize targets = _targets;

- (instancetype)init {
    self = [super init];
    if (self) {
        _targets = [TargetContainer new];
        _source = [SourceContainer new];
        
        _uniformSetting = [ShaderUniformSettings new];
        
        _activatePassthroughOnNextFrame = false;
        _useMetalPerformanceShaders = false;
        
        _inputTextures = [NSMutableDictionary new];
        _textureInputSemaphore = dispatch_semaphore_create(1);
        _useNormalizedTextureCoordinates = true;
    }
    return self;
}

- (instancetype)initWithVertexFuntionName:(nullable NSString *)vertexFunctionName
                     fragmentFunctionName:(NSString *)fragmentFunctionName
                           numberOfInputs:(NSUInteger)numberOfInputs
                            operationName:(NSString *)operationName {
    self = [self init];
    if (self) {
        self.maximumInputs = numberOfInputs;
        self.operationName = operationName;
        NSString *concreteVertexFunctionName = vertexFunctionName ? vertexFunctionName : defaultVertexFunctionNameForInputs(numberOfInputs);
        
        _renderPipelineState = generateRenderPipelineState([MetalRenderingDevice shared], concreteVertexFunctionName, fragmentFunctionName, operationName);
    }
    return self;
}


// Will be implementation for superclass
- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index {
    
}

- (void)newTextureAvailable:(Texture *)texture fromSourceIndex:(NSUInteger)index {
    dispatch_semaphore_wait(_textureInputSemaphore, DISPATCH_TIME_FOREVER);
    
    _inputTextures[@(index)] = texture;
    if (_inputTextures.count >= self.maximumInputs) {
        
        // Calcu frame texture
        int32_t outputWidth = 0, outputHeight = 0;
        Texture *firstInputTexture = _inputTextures[@(0)];
        if (firstInputTexture) {
            Rotation rotationNeeded = rotation(firstInputTexture.orientation, ImageOrientationPortrait);
            if (flipsDimensions(rotationNeeded)) {
                outputWidth = (int32_t)firstInputTexture.texture.height;
                outputHeight = (int32_t)firstInputTexture.texture.width;
            } else {
                outputWidth = (int32_t)firstInputTexture.texture.width;
                outputHeight = (int32_t)firstInputTexture.texture.height;
            }
        }
            
        id<MTLCommandBuffer> commandBuffer = [[MetalRenderingDevice shared].commandQueue commandBuffer];
        if (!commandBuffer) {
            dispatch_semaphore_signal(_textureInputSemaphore);
            return;
        }
        
        Texture *outputTexture = [[Texture alloc] initWithDevice:[MetalRenderingDevice shared].device orientation:ImageOrientationPortrait width:outputWidth height:outputHeight];
        
        if (_metalPerformanceShaderPathway &&
            _useMetalPerformanceShaders) {
            NSMutableDictionary<NSNumber *, Texture *> *rotatedInputTextures = [NSMutableDictionary new];
            
            if (rotation(firstInputTexture.orientation, ImageOrientationPortrait) != RotationNone) {
                Texture *rotationOutputTexture = [[Texture alloc] initWithDevice:[MetalRenderingDevice shared].device orientation:ImageOrientationPortrait width:outputWidth height:outputHeight];
                
                id<MTLCommandBuffer> rotationCommandBuffer = [[MetalRenderingDevice shared].commandQueue commandBuffer];
                
                if (!rotationCommandBuffer) {
                    dispatch_semaphore_signal(_textureInputSemaphore);
                    return;
                }
                
                renderQuad(rotationCommandBuffer, [MetalRenderingDevice shared].passthroughRenderState, _uniformSetting, _inputTextures, _useNormalizedTextureCoordinates, nil, 0, rotationOutputTexture, ImageOrientationPortrait);
                
                [rotationCommandBuffer commit];
                rotatedInputTextures = _inputTextures;
                rotatedInputTextures[@(0)] = rotationOutputTexture;
            } else {
                rotatedInputTextures = _inputTextures;
            }
            _metalPerformanceShaderPathway(commandBuffer, rotatedInputTextures, outputTexture);
        } else {
            renderQuad(commandBuffer, _renderPipelineState, _uniformSetting, _inputTextures, _useNormalizedTextureCoordinates, nil, 0, outputTexture, ImageOrientationPortrait);
        }
        [commandBuffer commit];
        
        [self updateTargetsWithTexture:outputTexture];
    }
    
    
    dispatch_semaphore_signal(_textureInputSemaphore);
}

@end

NSString *defaultVertexFunctionNameForInputs(NSUInteger inputCount) {
    switch (inputCount) {
        case 2:
            return @"twoInputVertex";
        case 1:
        default:
            return @"oneInputVertex";
    }
}
