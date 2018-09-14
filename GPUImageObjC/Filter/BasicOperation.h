//
//  BasicOperation.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 8/31/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pipeline.h"
#import "ShaderUniformSettings.h"
#import "MetalRendering.h"
#import "MetalRenderingDevice.h"

NSString *defaultVertexFunctionNameForInputs(NSUInteger inputCount);

@interface BasicOperation : ImageProcessingOperation

@property (nonatomic, readonly, strong) SourceContainer *source;

@property (nonatomic, readwrite) Boolean activatePassthroughOnNextFrame;

@property (nonatomic, readwrite, strong) ShaderUniformSettings *uniformSetting;

@property (nonatomic, readwrite) Boolean useMetalPerformanceShaders;

@property (nonatomic, readwrite, strong) id<MTLRenderPipelineState> renderPipelineState;

@property (nonatomic, readwrite, strong) NSString *operationName;

@property (nonatomic, readwrite, strong) NSMutableDictionary<NSNumber *, Texture *> *inputTextures;

@property (nonatomic, readonly, strong) dispatch_semaphore_t textureInputSemaphore;

@property (nonatomic, readwrite) Boolean useNormalizedTextureCoordinates;

@property (nonatomic, readwrite, strong) void(^metalPerformanceShaderPathway)(id<MTLCommandBuffer> commandBuffer, NSMutableDictionary<NSNumber *, Texture *> *inputTextures, Texture *texture);

- (instancetype)init;

- (instancetype)initWithVertexFuntionName:(nullable NSString *)vertexFunctionName
                     fragmentFunctionName:(NSString *)fragmentFunctionName
                           numberOfInputs:(NSUInteger)numberOfInputs
                            operationName:(NSString *)operationName;


// Will be implementation for superclass
- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index;

- (void)newTextureAvailable:(Texture *)texture fromSourceIndex:(NSUInteger)index;



@end
