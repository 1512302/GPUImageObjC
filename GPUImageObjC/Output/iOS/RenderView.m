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

@property (nonatomic, readwrite) float xMax;

@property (nonatomic, readwrite) float yMax;

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
    _xMax = _yMax = 1.0;
    _sources = [SourceContainer new];
    _maximumInputs = 1;
    self.framebufferOnly = NO;
    self.autoResizeDrawable = YES;
    self.device = [MetalRenderingDevice shared].device;
    _renderPipelineState = generateRenderPipelineState([MetalRenderingDevice shared], @"oneInputVertex", @"passthroughFragment", @"RenderView");
    self.enableSetNeedsDisplay = NO;
    [self setPaused:YES];
    _scaleNeeded = true;
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
    return 0;
    return addSourceForImageConsumer(source, self);
}


- (void)removeSourceAtIndex:(NSUInteger)index {
    removeSourceAtIndexForImageConsumer(index, self);
}

- (void)setSource:(id<ImageSource>)source atIndex:(NSUInteger)index {
    setSourceForImageConsumer(source, index, self);
}

- (void)drawRect:(CGRect)dirtyRect {
    
    id<CAMetalDrawable> currentDrawable = self.currentDrawable;
    Texture *imageTexture = _currentTexture;
    
    if (currentDrawable && imageTexture) {
        id<MTLCommandBuffer> commandBuffer = [[MetalRenderingDevice shared].commandQueue commandBuffer];
        Texture *outputTexture = [[Texture alloc] initWithOrientation:ImageOrientationPortrait texture:currentDrawable.texture];
        
        //renderQuadDefault(&commandBuffer, _renderPipelineState, @{@(0): imageTexture}, outputTexture);
        
        if (_scaleNeeded) {
            [self scaleView];
            _scaleNeeded = false;
        }

        float imageVertex[] = {-_xMax, _yMax, _xMax, _yMax, -_xMax, -_yMax, _xMax, -_yMax};
        renderQuad(commandBuffer, _renderPipelineState, nil,  @{@(0): imageTexture}, true, imageVertex, sizeof(imageVertex), outputTexture, ImageOrientationPortrait);
    
        
        if (commandBuffer) {
            [commandBuffer presentDrawable:currentDrawable];
            [commandBuffer commit];
            [commandBuffer waitUntilCompleted];
        }
        
    }
}

- (void)scaleView {
    
    float imageHeight = (float)self.currentTexture.texture.height;
    float imageWidth = (float)self.currentTexture.texture.width;
    float viewHeight = self.layer.frame.size.height;
    float viewWidth = self.layer.frame.size.width;
    
    float xMax = imageWidth * viewHeight / (imageHeight * viewWidth);
    if (xMax < 1.0) {
        self.xMax = xMax;
        self.yMax = 1.0;
    } else {
        self.xMax = 1.0;
        self.yMax = self.xMax / xMax;
    }
}


@end
