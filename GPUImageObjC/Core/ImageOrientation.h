//
//  ImageOrientation.h
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ImageOrientationPortrait = 0,
    ImageOrientationLandscapeLeft = 1,
    ImageOrientationPortraitUpsideDown = 2,
    ImageOrientationLandscapeRight = 3
} ImageOrientation;

typedef enum : NSUInteger {
    RotationNone,
    RotationCounterclockwise,
    RotationClockwise,
    Rotation180,
    RotationFlipHorizontally,
    RotationFlipVertically,
    RotationClockwiseAndFlipVertically,
    RotationClockwiseAndFlipHorizontally
} Rotation;

Rotation rotation(ImageOrientation source, ImageOrientation dest);

BOOL flipsDimensions(Rotation rotation);
