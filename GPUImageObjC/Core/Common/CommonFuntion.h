//
//  CommonFuntion.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/6/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#define ABSTRACT_METHOD NSAssert(NO, @"Do something at subclass");

#import <Foundation/Foundation.h>

float *nsArray2FloatArray(NSArray *array);

float *newFloatArray(float *source, int size);


