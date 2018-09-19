//
//  ShaderUniformSettings.h
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MetalKit;

@interface ShaderUniformSettings : NSObject

@property (nonatomic) Boolean colorUniformsUseAlpha;

@property (nonatomic) dispatch_queue_t shaderUniformSettingsQueue;

@property (nonatomic, readonly) float *uniformValue;

@property (nonatomic, readwrite) NSUInteger length;

- (instancetype)initWithLength:(NSUInteger)length;

- (void)setValue:(float)value atIndex:(NSUInteger)index;

- (void)setValues:(float *)values withLength:(NSUInteger)length atIndex:(NSUInteger)index;

- (void)restoreShaderSettingWithRenderEncoder:(id<MTLRenderCommandEncoder>) renderEncoder;

//- (float)floatAtIndex:(NSUInteger)index;
//
//- (void)setFloat:(float)value atIndex:(NSUInteger)index;
//
//- (Color *)colorAtIndex:(NSUInteger)index;
//
//- (void)setColor:(Color *)color atIndex:(NSUInteger)index;
//
//- (Position *)positionAtIndex:(NSUInteger)index;
//
//- (void)setPosition:(Position *)position atIndex:(NSUInteger)index;
//
//- (Matrix3x3 *)matrix3x3AtIndex:(NSUInteger)index;
//
//- (void)setMatrix3x3:(Matrix3x3 *)matrix atIndex:(NSUInteger)index;
//
//- (Matrix4x4 *)maxtrix4x4AtIndex:(NSUInteger)index;
//
//- (void)setMatrix4x4:(Matrix4x4 *)matrix atIndex:(NSUInteger)index;
//
//- (NSUInteger)alignPackingForUniformSize:(NSUInteger)uniformSize lastOffset:(NSUInteger)lastOffset;
//
//- (void)appendUniform:(id<UniformConvertible>)value;
//
//- (void)appendUniformWithColor:(Color *)value;



@end


