//
//  LookupFilter.m
//  GPUImageObjC
//
//  Created by CPU11367 on 10/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "LookupFilter.h"

@implementation LookupFilter

- (instancetype)init {
    self = [super initWithVertexFuntionName:nil fragmentFunctionName:@"lookupFragment" numberOfInputs:2 operationName:@"LookupFilter"];
    if (self) {
        [self setSizeOfAttribute:1];
        self.intensity = 1.0;
    }
    return self;
}

- (void)setIntensity:(float)intensity {
    _intensity = intensity;
    [self setUniformValue:_intensity atIndex:0];
}

- (void)setLookupImage:(PictureInput *)lookupImage {
    _lookupImage = lookupImage;
    [lookupImage addTarget:self atTargetIndex:1];
    [lookupImage processImage];
}

@end
