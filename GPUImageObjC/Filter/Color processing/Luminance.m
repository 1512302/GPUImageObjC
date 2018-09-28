//
//  Luminance.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/27/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "Luminance.h"

@implementation Luminance

- (instancetype)init {
    self = [super initWithVertexFuntionName:nil fragmentFunctionName:@"luminanceFragment" numberOfInputs:1 operationName:@"Luminance"];
    if (self) {
        self.uniformSetting = [[ShaderUniformSettings alloc] initWithLength:0];
    }
    return self;
}

@end
