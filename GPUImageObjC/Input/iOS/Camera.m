//
//  Camera.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "Camera.h"
#import "MetalRenderingDevice.h"
#import "Texture.h"

NSUInteger initialBenchmarkFramesToIgnore = 5;

@implementation Camera

@synthesize targets = _targets;

- (instancetype)init {
    self = [super init];
    if (self) {
        _runBenchmark = false;
        _logFPS = false;
        
        _targets = [TargetContainer new];
        
        _frameRenderingSemaphore = dispatch_semaphore_create(1);
        _cameraProcessingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _cameraFrameProcessingQueue = dispatch_queue_create("com.loctp2.GPUImage.cameraFrameProcessingQueue", DISPATCH_QUEUE_SERIAL);
        
        _location = [PhysicalCameraLocation new];
        _framesToIgnore = 5;
        _numberOfFramesCapture = 0;
        _totalFrameTimeDuringCapture = 0.0;
        _framesSinceLastCheck = 0;
        _lastCheckTime = CFAbsoluteTimeGetCurrent();
    }
    return self;
}

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset
                         cameraDevice:(AVCaptureDevice *)cameraDevice
                             location:(PhysicalCameraLocation *)location
                         captureAsYUV:(Boolean)captureAsYUV {
    self = [self init];
    if (self) {
        if (location) {
            _location.type = location.type;
        } else {
            _location.type = PhysicalCameraLocationBackFacing;
        }
        
        _captureSesstion = [AVCaptureSession new];
        [_captureSesstion beginConfiguration];
        
        if (cameraDevice) {
            _inputCamera = cameraDevice;
        } else {
            AVCaptureDevice *device = [_location device];
            if (device) {
                _inputCamera = device;
            } else {
                NSAssert(NO, @"No camera input");
            }
        }
        
        NSError *error = nil;
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:_inputCamera error:&error];
        NSAssert(!error, @"Error: %@", error);
        
        if ([_captureSesstion canAddInput:_videoInput]) {
            [_captureSesstion addInput:_videoInput];
        }
        
        _videoOutput = [AVCaptureVideoDataOutput new];
        _videoOutput.alwaysDiscardsLateVideoFrames = false;
        
        NSNumber *value = @(kCVPixelFormatType_32BGRA);
        NSString *key = [NSString stringWithFormat:@"%@", kCVPixelBufferPixelFormatTypeKey];
        _videoOutput.videoSettings = @{key: value};
        
        if ([_captureSesstion canAddOutput:_videoOutput]) {
            [_captureSesstion addOutput:_videoOutput];
        }
        
        _captureSesstion.sessionPreset = sessionPreset;
        [_captureSesstion commitConfiguration];
        
        CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, [MetalRenderingDevice shared].device, nil, &_videoTextureCache);
        
        [_videoOutput setSampleBufferDelegate:self queue:_cameraProcessingQueue];
    }
    return self;
}

- (void)dealloc {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(_cameraFrameProcessingQueue, ^{
        [weakSelf stopCapture];
        if (weakSelf.videoOutput) {
            [weakSelf.videoOutput setSampleBufferDelegate:nil queue:nil];
        }
    });
}

- (void)startCapture {
    _numberOfFramesCapture = 0;
    _totalFrameTimeDuringCapture = 0;
    
    if (!_captureSesstion.isRunning) {
        [_captureSesstion startRunning];
    }
}

- (void)stopCapture {
    if ([_captureSesstion isRunning]) {
        [_captureSesstion stopRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (dispatch_semaphore_wait(_frameRenderingSemaphore, DISPATCH_TIME_NOW) > 0) {
        return;
    }
    CFRetain(sampleBuffer);
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CVPixelBufferRef cameraFrame = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t bufferWidth = CVPixelBufferGetWidth(cameraFrame);
    size_t bufferHeight = CVPixelBufferGetHeight(cameraFrame);
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(_cameraFrameProcessingQueue, ^{
        [weakSelf.delegate didCaptureBuffer:sampleBuffer];
        
        CVMetalTextureRef textureRef = nil;
        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, weakSelf.videoTextureCache, cameraFrame, nil, MTLPixelFormatBGRA8Unorm, bufferWidth, bufferHeight, 0, &textureRef);
        CFRelease(sampleBuffer);
        
        if (textureRef) {
            id<MTLTexture>cameraTexture = CVMetalTextureGetTexture(textureRef);
            Texture *texture = [[Texture alloc] initWithOrientation:[weakSelf.location imageOrientation] texture:cameraTexture];
            [weakSelf updateTargetsWithTexture:texture];
            CVBufferRelease(textureRef);
        }
        
        if (weakSelf.runBenchmark) {
            weakSelf.numberOfFramesCapture++;
            if (weakSelf.numberOfFramesCapture > initialBenchmarkFramesToIgnore) {
                CFAbsoluteTime currentFrameTime = CFAbsoluteTimeGetCurrent() - startTime;
                weakSelf.totalFrameTimeDuringCapture += currentFrameTime;
                double time = 1000.0 * weakSelf.totalFrameTimeDuringCapture / (weakSelf.numberOfFramesCapture - initialBenchmarkFramesToIgnore);
                NSLog(@"Average frame time: %lf ms", time);
                NSLog(@"Current frame time: %lf ms", 1000 * currentFrameTime);
            }
        }
        
        if (weakSelf.logFPS) {
            if ((CFAbsoluteTimeGetCurrent() - weakSelf.lastCheckTime) > 1.0) {
                weakSelf.lastCheckTime = CFAbsoluteTimeGetCurrent();
                NSLog(@"FPS: %lu", (unsigned long)weakSelf.framesSinceLastCheck);
                weakSelf.framesSinceLastCheck = 0;
            }
            
            weakSelf.framesSinceLastCheck++;
        }
        
        
        //CVPixelBufferUnlockBaseAddress(cameraFrame, lockFlags);
        
        dispatch_semaphore_signal(weakSelf.frameRenderingSemaphore);
    });
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"loctp2: %@", sampleBuffer);
    //exit(0);

}

- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index {
    
}

@end
