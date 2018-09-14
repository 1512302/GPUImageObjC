//
//  SaturationAdjustment.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/14/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "SaturationAdjustment.h"

@implementation SaturationAdjustment

- (instancetype)init {
    self = [super initWithVertexFuntionName:nil fragmentFunctionName:@"saturationFragment" numberOfInputs:1 operationName:@"SaturationAdjustment"];
    if (self) {
        _saturation = 1.0;
    }
    return self;
}

@end
