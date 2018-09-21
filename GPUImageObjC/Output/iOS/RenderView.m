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
#import "CommonFuntion.h"

@interface RenderView ()

@property (atomic, readwrite) float *imageVertex;

@property (nonatomic, readwrite) int imageVertexSize;

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
    _imageVertex = nil;
    _imageVertexSize = 0;
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

- (void)dealloc {
    if (_imageVertex) {
        free(_imageVertex);
    }
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

- (void)drawRect:(CGRect)dirtyRect {
    
    id<CAMetalDrawable> currentDrawable = self.currentDrawable;
    Texture *imageTexture = _currentTexture;
    
    if (currentDrawable && imageTexture) {
        id<MTLCommandBuffer> commandBuffer = [[MetalRenderingDevice shared].commandQueue commandBuffer];
        Texture *outputTexture = [[Texture alloc] initWithOrientation:ImageOrientationPortrait texture:currentDrawable.texture];
        
        //renderQuadDefault(commandBuffer, _renderPipelineState, @{@(0): imageTexture}, outputTexture);
        [self scaleView];
        renderQuad(commandBuffer, _renderPipelineState, nil,  @{@(0): imageTexture}, true, _imageVertex, _imageVertexSize, outputTexture, ImageOrientationPortrait);
    
        
        if (commandBuffer) {
            [commandBuffer presentDrawable:currentDrawable];
            [commandBuffer commit];
        }
        
    }
}

- (void)scaleView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        float imageHeight = (float)self.currentTexture.texture.height;
        float imageWidth = (float)self.currentTexture.texture.width;
        float viewHeight = self.layer.frame.size.height;
        float viewWidth = self.layer.frame.size.width;
        if ((imageHeight > imageWidth) != (viewHeight > viewWidth)) {
            float temp = imageWidth;
            imageWidth = imageHeight;
            imageHeight = temp;
        }
        
        float xMax = imageWidth * viewHeight / (imageHeight * viewWidth);
        if (xMax < 1.0) {
            self.xMax = xMax;
            self.yMax = 1.0;
        } else {
            self.xMax = 1.0;
            self.yMax = self.xMax / xMax;
        }
        
        [self recalcuVertex];
    });
    
}

//- (void)setOrientation:(ImageOrientation)orientation {
//    _orientation = orientation;
//    [self recalcuVertex];
//}

- (void)recalcuVertex {
    float temp[] = {-_xMax, -_yMax, _xMax, -_yMax, -_xMax, _yMax, _xMax, _yMax};
    _imageVertexSize = sizeof(temp);
    _imageVertex = newFloatArray(temp, _imageVertexSize / sizeof(float));
}

@end
