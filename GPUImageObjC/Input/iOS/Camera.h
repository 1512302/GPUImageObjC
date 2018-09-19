//
//  Camera.h
//  GPUImageObjC
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicalCameraLocation.h"
#import "Pipeline.h"

@import Metal;
@import AVFoundation;

@protocol CameraDelegate

- (void)didCaptureBuffer:(CMSampleBufferRef)sampleBuffer;

@end



@interface Camera : ImageSource <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, readwrite, strong) PhysicalCameraLocation *location;

@property (nonatomic, readwrite) Boolean runBenchmark;

@property (nonatomic, readwrite) Boolean logFPS;

@property (nonatomic, readwrite, strong) id<CameraDelegate> delegate;

@property (nonatomic, readwrite, strong) AVCaptureSession *captureSesstion;

@property (nonatomic, readwrite, strong) AVCaptureDevice *inputCamera;

@property (nonatomic, readwrite, strong) AVCaptureDeviceInput *videoInput;

@property (nonatomic, readwrite, strong) AVCaptureVideoDataOutput *videoOutput;

@property (nonatomic, readwrite) CVMetalTextureCacheRef videoTextureCache;

@property (nonatomic, readwrite, strong) dispatch_semaphore_t frameRenderingSemaphore;

@property (nonatomic, readwrite, strong) dispatch_queue_t cameraProcessingQueue;

@property (nonatomic, readwrite, strong) dispatch_queue_t cameraFrameProcessingQueue;

@property (nonatomic, readwrite) NSUInteger framesToIgnore;

@property (nonatomic, readwrite) NSUInteger numberOfFramesCapture;

@property (nonatomic, readwrite) double totalFrameTimeDuringCapture;

@property (nonatomic, readwrite) NSUInteger framesSinceLastCheck;

@property (nonatomic, readwrite) CFAbsoluteTime lastCheckTime;

- (instancetype)init;

- (instancetype)initWithSessionPreset:(AVCaptureSessionPreset)sessionPreset
                         cameraDevice:(AVCaptureDevice *)cameraDevice
                             location:(PhysicalCameraLocation *)location
                         captureAsYUV:(Boolean)captureAsYUV;

- (void)startCapture;

- (void)stopCapture;

// Delegate
- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

// Overide
- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index;

@end
