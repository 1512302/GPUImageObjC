//
//  ImageOrientation.m
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import "ImageOrientation.h"


BOOL flipsDimensions(Rotation rotation) {
    switch (rotation) {
        case RotationNone:
        case Rotation180:
        case RotationFlipVertically:
        case RotationFlipHorizontally:
            return false;
            break;
        case RotationCounterclockwise:
        case RotationClockwise:
        case RotationClockwiseAndFlipVertically:
        case RotationClockwiseAndFlipHorizontally:
        default:
            return true;
            break;
    }
}


Rotation rotation(ImageOrientation source, ImageOrientation dest) {
    switch ((4 + dest - source) % 4) {
        case 0:
            return RotationNone;
        case 1:
            return RotationCounterclockwise;
        case 2:
            return Rotation180;
        case 3:
        default:
            return RotationClockwise;
    }
}
