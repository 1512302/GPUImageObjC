//
//  ShaderUniformSettings.m
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import "ShaderUniformSettings.h"
#import "MetalRenderingDevice.h"
#import "CommonFuntion.h"

@implementation ShaderUniformSettings

- (instancetype)init {
    self = [super init];
    if (self) {
        _uniformValues = [NSMutableArray new];
        _uniformValueOffsets = [NSMutableArray new];
        _colorUniformsUseAlpha = false;
        _shaderUniformSettingsQueue = dispatch_queue_create("com.sunsetlakesoftware.GPUImage.shaderUniformSettings", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSUInteger)internalIndexForIndex:(NSUInteger)index {
    if (index == 0) {
        return 0;
    } else {
        return [_uniformValueOffsets[index - 1] intValue];
    }
}

- (id)objectAtIndex:(NSUInteger)index {
    NSUInteger internalIndex = [self internalIndexForIndex:index];
    return _uniformValues[internalIndex];
}

- (void)setObject:(id)object atIndex:(NSUInteger)index {
    
}


//- (void)setFloat:(float)value atIndex:(NSUInteger)index {
//    
//}
//
//- (Color *)colorAtIndex:(NSUInteger)index {
//    
//}
//
//- (void)setColor:(Color *)color atIndex:(NSUInteger)index {
//    
//}
//
//- (Position *)positionAtIndex:(NSUInteger)index {
//    
//}
//
//- (void)setPosition:(Position *)position atIndex:(NSUInteger)index {
//    
//}
//
//- (Matrix3x3 *)matrix3x3AtIndex:(NSUInteger)index {
//    
//}
//
//- (void)setMatrix3x3:(Matrix3x3 *)matrix atIndex:(NSUInteger)index {
//    
//}
//
//- (Matrix4x4 *)maxtrix4x4AtIndex:(NSUInteger)index {
//    
//}
//
//- (void)setMatrix4x4:(Matrix4x4 *)matrix atIndex:(NSUInteger)index {
//    
//}
//
//- (NSUInteger)alignPackingForUniformSize:(NSUInteger)uniformSize lastOffset:(NSUInteger)lastOffset {
//    
//}
//
//- (void)appendUniform:(id<UniformConvertible>)value {
//    
//}
//
//- (void)appendUniformWithColor:(Color *)value {
//    
//}
//
- (void)restoreShaderSettingWithRenderEncoder:(id<MTLRenderCommandEncoder>) renderEncoder {
    if (_uniformValues.count <= 0) {
        return;
    }
//    NSAssert(_uniformValues.count > 0, @"_uniformValues.count <= 0");
    
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(_shaderUniformSettingsQueue, ^{
        float *uniformValuesDraw = nsArray2FloatArray(weakSelf.uniformValues);
        id<MTLBuffer> uniformBuffer = [[MetalRenderingDevice shared].device newBufferWithBytes:uniformValuesDraw length:weakSelf.uniformValues.count * sizeof(float)  options:MTLResourceOptionCPUCacheModeDefault];
        [renderEncoder setFragmentBuffer:uniformBuffer offset:0 atIndex:1];
        free(uniformValuesDraw);
    });
}

@end
