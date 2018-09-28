//
//  MetalRendering.m
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import "MetalRendering.h"
#import "MetalRenderingDevice.h"
#import "ShaderUniformSettings.h"
#import "CommonFuntion.h"

float standardImageVertices[] = {-1.0, 1.0, 1.0, 1.0, -1.0, -1.0, 1.0, -1.0};

//float standardImageVertices[] = {-1.0, 1.0, -1.0, -1.0, 1.0, 1.0, 1.0, -1.0};

void renderQuad(id<MTLCommandBuffer> commandBuffer,
                id<MTLRenderPipelineState> pipelineState,
                ShaderUniformSettings *uniformSettings,
                NSDictionary<NSNumber *, Texture *> *inputTextures,
                Boolean useNormalizedTextureCoordinates,
                float *imageVertices,
                int imageVerticesSize,
                Texture *outputTexture,
                ImageOrientation outputOrientation) {
    
    if (!imageVertices) {
        imageVertices = standardImageVertices;
        imageVerticesSize = sizeof(standardImageVertices);
    } else {
        NSLog(@"Customize");
    }
    id<MTLBuffer> vertexBuffer = [[MetalRenderingDevice shared].device newBufferWithBytes:imageVertices length:imageVerticesSize options:MTLResourceOptionCPUCacheModeDefault];
    vertexBuffer.label = @"Vertices";
    
    // Clear view
    MTLRenderPassDescriptor *renderPass = [MTLRenderPassDescriptor new];
    renderPass.colorAttachments[0].texture = outputTexture.texture;
    renderPass.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);
    renderPass.colorAttachments[0].storeAction = MTLStoreActionStore;
    renderPass.colorAttachments[0].loadAction = MTLLoadActionClear;
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPass];
    
    [renderEncoder setFrontFacingWinding:MTLWindingCounterClockwise];
    [renderEncoder setRenderPipelineState:pipelineState];
    [renderEncoder setVertexBuffer:vertexBuffer offset:0 atIndex:0];
    [renderEncoder setFragmentTexture:inputTextures.allValues[0].texture atIndex:0];
    
    for (NSUInteger textureIndex = 0; textureIndex < inputTextures.count; ++textureIndex) {
        NSNumber *key = @(textureIndex);
        Texture *currentTexture = inputTextures[key];
        if (!currentTexture) {
            continue;
        }
        [currentTexture textureCoodinatesForOutputOrientation:outputOrientation normalized:useNormalizedTextureCoordinates completion:^(float *vertexs, int size) {
            if (vertexs) {
                id<MTLBuffer> textureBuffer = [[MetalRenderingDevice shared].device newBufferWithBytes:vertexs length:sizeof(float) * size options:MTLResourceOptionCPUCacheModeDefault];
                textureBuffer.label = @"Texture Coordinates";
                
                [renderEncoder setVertexBuffer:textureBuffer offset:0 atIndex: 1 + textureIndex];
                [renderEncoder setFragmentTexture:currentTexture.texture atIndex:textureIndex];
                
            }
        }];
    }
    
    if (uniformSettings) {
        [uniformSettings restoreShaderSettingWithRenderEncoder:renderEncoder];
    }
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [renderEncoder endEncoding];
}


void renderQuadDefault(id<MTLCommandBuffer> commandBuffer,
                       id<MTLRenderPipelineState> pipelineState,
                       NSDictionary<NSNumber *, Texture *> *inputTextures,
                       Texture *outputTexture) {
    renderQuad(commandBuffer, pipelineState, nil, inputTextures, true, nil, 0, outputTexture, ImageOrientationPortrait);
}

id<MTLRenderPipelineState> generateRenderPipelineState(MetalRenderingDevice *device, NSString *vertexFunctionName, NSString *fragmentFunctionName, NSString *operationName) {
    // usafe
    id<MTLFunction> vertexFunction = [device.shaderLibrary newFunctionWithName:vertexFunctionName];
    id<MTLFunction> fragmentFunction = [device.shaderLibrary newFunctionWithName:fragmentFunctionName];
    MTLRenderPipelineDescriptor *descriptor = [MTLRenderPipelineDescriptor new];
    descriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    descriptor.rasterSampleCount = 1;
    descriptor.vertexFunction = vertexFunction;
    descriptor.fragmentFunction = fragmentFunction;
    return [device.device newRenderPipelineStateWithDescriptor:descriptor error:nil];
}
