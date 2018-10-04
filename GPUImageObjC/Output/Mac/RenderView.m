//
//  RenderView.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "RenderView.h"
#import "MetalRenderingDevice.h"
#import "MetalRendering.h"



@interface RenderView ()

- (void)commonInit;

@end

@implementation RenderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - private

- (void)commonInit {
    _sources = [SourceContainer new];
    _maximumInputs = 1;
    self.framebufferOnly = NO;
    self.autoResizeDrawable = YES;
    self.device = [MetalRenderingDevice shared].device;
    _renderPipelineState = generateRenderPipelineState([MetalRenderingDevice shared], @"oneInputVertex", @"passthroughFragment", @"RenderView");
    self.enableSetNeedsDisplay = NO;
    [self setPaused:YES];
}

#pragma mark - implementation MTKView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frameRect device:(id<MTLDevice>)device {

    self = [super initWithFrame:frameRect device:device];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - protocol

- (void)newTextureAvailable:(Texture *)texture fromSourceIndex:(NSUInteger)index {
    self.drawableSize = CGSizeMake(texture.texture.width, texture.texture.height);
    _currentTexture = texture;
    [self draw];
}

- (NSInteger)addSource:(id<ImageSource>)source {
    return addSourceForImageConsumer(source, self);
}


- (void)removeSourceAtIndex:(NSUInteger)index {
    removeSourceAtIndexForImageConsumer(index, self);
}

- (void)setSource:(id<ImageSource>)source atIndex:(NSUInteger)index {
    setSourceForImageConsumer(source, index, self);
}

- (void)drawRect:(NSRect)dirtyRect {
    id<CAMetalDrawable> currentDrawable = self.currentDrawable;
    Texture *imageTexture = _currentTexture;
    if (currentDrawable && imageTexture) {
        id<MTLCommandBuffer> commandBuffer = [[MetalRenderingDevice shared].commandQueue commandBuffer];
        Texture *outputTexture = [[Texture alloc] initWithOrientation:ImageOrientationPortrait texture:currentDrawable.texture];
        
        renderQuadDefault(commandBuffer, _renderPipelineState, @{@(0): imageTexture}, outputTexture);
        
        if (commandBuffer) {
            [commandBuffer presentDrawable:currentDrawable];
            [commandBuffer commit];

        }
        
    }
}

@end
