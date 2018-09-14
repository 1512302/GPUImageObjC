//
//  ViewController.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/12/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ViewController.h"
#import "RenderView.h"
#import "PictureInput.h"


@interface ViewController ()

@property (weak) IBOutlet RenderView *renderView;

@property (nonatomic, readwrite, strong) PictureInput *image;

//

@property (nonatomic, readwrite, strong) id<MTLDevice> device;

@property (nonatomic, readwrite, strong) id<MTLBuffer> vertexBuffer;

@property (nonatomic, readwrite, strong) id<MTLRenderPipelineState> pipelineState;

@property (nonatomic, readwrite, strong) id<MTLCommandQueue> commandQueue;

@property (nonatomic, readwrite) CVDisplayLinkRef displaylink;

@property (nonatomic, readwrite, strong) id<MTLTexture> texture;



@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSImage *inputImage = [NSImage imageNamed:@"Lambeau.jpg"];
    CGImageRef cgImage = [inputImage CGImageForProposedRect:nil context:nil hints:nil];
    
    _image = [[PictureInput alloc] initWithCGImage:cgImage];
    [_image additionPrecedence:_renderView];
    [_image processImage];
//    [self test];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - test - will delete

- (void)createTexture {
    MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:[MetalRenderingDevice shared].device];
    
    __weak __typeof(self) weakSelf = self;
    
    NSImage *inputImage = [NSImage imageNamed:@"Lambeau.jpg"];
    CGImageRef cgImage = [inputImage CGImageForProposedRect:nil context:nil hints:nil];
    [textureLoader newTextureWithCGImage:cgImage options:@{MTKTextureLoaderOptionSRGB:@(NO)} completionHandler:^(id<MTLTexture>  _Nullable texture, NSError * _Nullable error) {;
        weakSelf.texture = texture;
        [weakSelf render];
    }];
}

- (void)test {
    // 1. Get devide
    _device = MTLCreateSystemDefaultDevice();
    
    // 2. Create view
    _renderView.device = _device;
    
    // 3. Create data
    float vertexData[] = {-0.9, -0.9, 0.9, -0.9, -0.9, 0.9, 0.9, 0.9};
    
    //float dataSize = 9 * sizeof(float);
    _vertexBuffer = [_device newBufferWithBytes:vertexData length:sizeof(vertexData) options:MTLResourceOptionCPUCacheModeDefault];
    
    
    // 4. Create a Render Pipeline
    id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
    id<MTLFunction> fragmentProgram = [defaultLibrary newFunctionWithName:@"passthroughFragment"];
    id<MTLFunction> vertexProgram = [defaultLibrary newFunctionWithName:@"oneInputVertex"];
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineStateDescriptor.vertexFunction = vertexProgram;
    pipelineStateDescriptor.fragmentFunction = fragmentProgram;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = _renderView.colorPixelFormat;
    
    NSError *error = nil;
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
    NSLog(@"loctp2: %@", error);
    
    // 5. Create a Command Queue
    _commandQueue = [_device newCommandQueue];
    
    [self createTexture];
}

- (void)render {
    float textcord[] = {0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0};
    id<MTLBuffer> textcordBuffer = [_device newBufferWithBytes:textcord length:sizeof(textcord) options:MTLResourceOptionCPUCacheModeDefault];
    // 6. Create a Render Pass Descriptor
    MTLRenderPassDescriptor *renderPassDescriptor = _renderView.currentRenderPassDescriptor;
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0/255.0, 0.0/255.0, 1.0);
    
    // 7. Create a Command Buffer
    id<MTLCommandBuffer> commendBuffer =  [_commandQueue commandBuffer];
    
    // 8. Create a Render Command Encoder
    id<MTLRenderCommandEncoder> renderEncoder = [commendBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [renderEncoder setRenderPipelineState:_pipelineState];
    [renderEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [renderEncoder setVertexBuffer:textcordBuffer offset:0 atIndex:1];
    [renderEncoder setFragmentTexture:_texture atIndex:0];
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:4];
    [renderEncoder endEncoding];
    
    // 9. Commit your Command Buffer
    [commendBuffer presentDrawable:_renderView.currentDrawable];
    [commendBuffer commit];
}

@end
