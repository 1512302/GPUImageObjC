//
//  MetalRenderingDevice.m
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import "MetalRenderingDevice.h"
#import "MetalRendering.h"

@implementation MetalRenderingDevice

+ (MetalRenderingDevice *)shared {
    static MetalRenderingDevice *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MetalRenderingDevice new];
    });
    return instance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _device = MTLCreateSystemDefaultDevice();
        _commandQueue = [_device newCommandQueue];
        _metalPerformanceShadersAreSupported = true;
        
        _shaderLibrary = [_device newDefaultLibrary];
        
        _passthroughRenderState = generateRenderPipelineState(self, @"oneInputVertex", @"passthroughFragment", @"Passsthrough");
    }
    return self;
}

//- (id<MTLRenderPipelineState>)passthroughRenderState {
//    __weak __typeof(self) weakSelf = self;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        weakSelf.passthroughRenderState = generateRenderPipelineState(self, @"oneInputVertex", @"passthroughFragment", @"Passsthrough");
//    });
//    return _passthroughRenderState;
//}

@end
