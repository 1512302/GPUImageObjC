//
//  PhysicalCameraType.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/18/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "PhysicalCameraLocation.h"

@implementation PhysicalCameraLocation

- (ImageOrientation)imageOrientation {
    switch (_type) {
        case PhysicalCameraLocationFrontFacing:
            return ImageOrientationLandscapeLeft;
            break;
        case PhysicalCameraLocationBackFacing:
        default:
            return ImageOrientationLandscapeRight;
            break;
    }
}

- (AVCaptureDevicePosition)captureDevicePosition {
    switch (_type) {
        case PhysicalCameraLocationFrontFacing:
            return AVCaptureDevicePositionFront;
            break;
        case PhysicalCameraLocationBackFacing:
        default:
            return AVCaptureDevicePositionBack;
            break;
    }
}

- (AVCaptureDevice *)device {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == [self captureDevicePosition]) {
            return device;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

@end
