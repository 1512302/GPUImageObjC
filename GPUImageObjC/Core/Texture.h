//
//  Texture.h
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timestamp.h"
#import "ImageOrientation.h"
#import <Metal/Metal.h>

typedef enum : NSUInteger {
    TextureTimingStillImage = 0,
    TextureTimingVideoFrame = 1,
} TextureTimingStyle;

BOOL isTransient(TextureTimingStyle style);

Timestamp *timestamp(TextureTimingStyle style);

@interface Texture : NSObject

@property (nonatomic, readwrite) TextureTimingStyle timingStyle;

@property (nonatomic, readwrite) ImageOrientation orientation;

@property (nonatomic, readwrite, strong) id<MTLTexture> texture;

- (instancetype)initWithOrientation:(ImageOrientation)orientation texture:(id<MTLTexture>)texture;

- (instancetype)initWithDevice:(id<MTLDevice>)device orientation:(ImageOrientation)orientation width:(int32_t)width height:(int32_t)height;

@end

@interface Texture()

- (void)textureCoodinatesForOutputOrientation:(ImageOrientation)outputOrientation normalized:(boolean_t)normalized completion:(void(^)(float *vertexs, int size))completion;

- (float *)textureCoodinatesForOutputOrientation:(ImageOrientation)outputOrientation;

@end
