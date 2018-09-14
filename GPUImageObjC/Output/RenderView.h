//
//  RenderView.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#import "Pipeline.h"


@interface RenderView : MTKView <ImageConsumer>

@property (nonatomic, readwrite, strong) SourceContainer *sources;

@property (nonatomic, readwrite) NSUInteger maximumInputs; //default 1

@property (nonatomic, readonly, strong) Texture *currentTexture; // nil

@property (nonatomic, readonly, strong) id<MTLRenderPipelineState> renderPipelineState; //nil

// Override MTKView
- (instancetype)initWithCoder:(NSCoder *)coder;

- (instancetype)initWithFrame:(CGRect)frameRect device:(id<MTLDevice>)device;

// Conform to ImageConsumer
- (void)newTextureAvailable:(Texture *)texture fromSourceIndex:(NSUInteger)index;



@end
