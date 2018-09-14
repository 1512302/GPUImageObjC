//
//  MetalRendering.h
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture.h"
@import MetalKit;

@class ShaderUniformSettings;
@class MetalRenderingDevice;

void renderQuad(id<MTLCommandBuffer> commandBuffer,
                id<MTLRenderPipelineState> pipelineState,
                ShaderUniformSettings *uniformSettings,
                NSDictionary<NSNumber *, Texture *> *inputTextures,
                Boolean useNormalizedTextureCoordinates,
                float *imageVertices,
                int imageVerticesSize,
                Texture *outputTexture,
                ImageOrientation outputOrientation);

void renderQuadDefault(id<MTLCommandBuffer> commandBuffer,
                       id<MTLRenderPipelineState> pipelineState,
                       NSDictionary<NSNumber *, Texture *> *inputTextures,
                       Texture *outputTexture);

id<MTLRenderPipelineState> generateRenderPipelineState(MetalRenderingDevice *device, NSString *vertexFunctionName, NSString *fragmentFunctionName, NSString *operationName);

id<MTLTexture> getTexture(void);
