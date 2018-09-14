//
//  MetalRenderingDevice.h
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MetalKit;

@interface MetalRenderingDevice : NSObject

@property (nonatomic, strong) id<MTLDevice> device;

@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

@property (nonatomic, strong) id<MTLLibrary> shaderLibrary;

@property (nonatomic) Boolean metalPerformanceShadersAreSupported;

@property (nonatomic) id<MTLRenderPipelineState> passthroughRenderState;

+ (MetalRenderingDevice *)shared;

- (instancetype)init;

@end
