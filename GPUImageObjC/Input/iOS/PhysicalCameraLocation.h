//
//  PhysicalCameraType.h
//  GPUImageObjC
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageOrientation.h"
@import AVFoundation;

typedef enum : NSUInteger {
    PhysicalCameraLocationBackFacing,
    PhysicalCameraLocationFrontFacing,
} PhysicalCameraLocationType;

@interface PhysicalCameraLocation : NSObject

@property (nonatomic, readwrite) PhysicalCameraLocationType type;

- (ImageOrientation)imageOrientation;

- (AVCaptureDevicePosition)captureDevicePosition;

- (AVCaptureDevice *)device;

@end


