//
//  CommonFuntion.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/6/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "CommonFuntion.h"

float *nsArray2FloatArray(NSArray *array) {
    if (!array) {
        return nil;
    }
    
    float *res = (float *)(malloc(array.count * sizeof(float)));
    for (int i = 0; i < array.count; ++i) {
        res[i] = [array[i] floatValue];
    }
    
    return res;
}


float *newFloatArray(float *source, int size) {
    
    float *dest = (float *)malloc(sizeof(float) * size);
    
    for (int i = 0; i < size; ++i) {
        dest[i] = source[i];
    }
    
    return dest;
}
