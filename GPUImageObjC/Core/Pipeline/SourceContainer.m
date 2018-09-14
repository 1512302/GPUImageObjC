//
//  SourceContainer.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "SourceContainer.h"
#import "ImageSourceProtocol.h"

@interface SourceContainer ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation SourceContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        _sources = [NSMutableDictionary new];
        NSString *address = [NSString stringWithFormat:@"%p", self];
        _serialQueue = dispatch_queue_create([address UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSInteger)appendWithSource:(id<ImageSource>)source maximumInputs:(NSUInteger)maxInputs {
    for (NSUInteger curIndex = 0; curIndex < maxInputs; ++curIndex) {
        NSNumber *key = @(curIndex);
        if (!_sources[key]) {
            _sources[key] = source;
            return curIndex;
        }
    }
    return -1;
}

- (NSInteger)insertWithSource:(id<ImageSource>)source atIndex:(NSUInteger)index maximumInputs:(NSUInteger)maxInputs {
    if (index < maxInputs) {
        NSNumber *key = @(index);
        _sources[key] = source;
    }
    return -1;
}

- (void)removeAtIndex:(NSUInteger)index {
    NSNumber *key = @(index);
    _sources[key] = nil;
}

@end
