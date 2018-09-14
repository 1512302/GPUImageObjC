//
//  WeakImageConsumer.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "WeakImageConsumer.h"

@implementation WeakImageConsumer

- (instancetype)initWithValue:(id<ImageConsumer>)value indexAtTarget:(NSUInteger)index {
    self = [super init];
    if (self) {
        _indexAtTarget = index;
        _value = value;
    }
    return self;
}

@end
