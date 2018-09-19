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
        _colorUniformsUseAlpha = false;
        _uniformValue = nil;
        _length = 0;
        _shaderUniformSettingsQueue = dispatch_queue_create("com.sunsetlakesoftware.GPUImage.shaderUniformSettings", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}	    

- (instancetype)initWithLength:(NSUInteger)length {
    self = [self init];
    if (self) {
        _length = length;
        _uniformValue = calloc(length, sizeof(float));
    }
    return self;
}

- (void)dealloc {
    if (_uniformValue) {
        free(_uniformValue);
    }
}

- (BOOL)validateIndex:(NSUInteger)index {
    if (index >= _length) {
        NSLog(@"loctp2: ShaderUniformSetting setValue:atIndex index >= length: %ld >= %ld", index, _length);
        return NO;
    }
    return YES;
}

- (void)setValue:(float)value atIndex:(NSUInteger)index {
    if ([self validateIndex:index]) {
        _uniformValue[index] = value;
    }
}

- (void)setValues:(float *)values withLength:(NSUInteger)length atIndex:(NSUInteger)index {
    for (int i = 0; i < length; ++i) {
        [self setValue:values[i] atIndex:index];
        ++index;
    }
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
    if (_length == 0) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(_shaderUniformSettingsQueue, ^{
        id<MTLBuffer> uniformBuffer = [[MetalRenderingDevice shared].device newBufferWithBytes:weakSelf.uniformValue length:weakSelf.length * sizeof(float)  options:MTLResourceOptionCPUCacheModeDefault];
        [renderEncoder setFragmentBuffer:uniformBuffer offset:0 atIndex:1];
    });
}

@end
