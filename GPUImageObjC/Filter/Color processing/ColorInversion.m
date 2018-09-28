//
//  ColorInversion.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/27/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ColorInversion.h"

@implementation ColorInversion

- (instancetype)init {
    self = [super initWithVertexFuntionName:nil fragmentFunctionName:@"colorInversionFragment" numberOfInputs:1 operationName:@"ColorInversion"];
    if (self) {
        self.uniformSetting = [[ShaderUniformSettings alloc] initWithLength:0];
    }
    return self;
}

@end
