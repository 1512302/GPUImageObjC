//
//  TargetContainer.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "TargetContainer.h"
#import "WeakImageConsumer.h"

@implementation TargetContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        _targets = [NSMutableArray new];
        _dispatchQueue = dispatch_queue_create("com.sunsetlakesoftware.GPUImage.targetContainerQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)appendWithTarget:(id<ImageConsumer>)target indexAtTarget:(NSUInteger)index {
    __weak __typeof(self) weakSelf = self;
    dispatch_sync(_dispatchQueue, ^{
        WeakImageConsumer *imageConsumer = [[WeakImageConsumer alloc] initWithValue:target indexAtTarget:index];
        [weakSelf.targets addObject:imageConsumer];
    });
}

- (void)removeAll {
    dispatch_async(_dispatchQueue, ^{
        [self.targets removeAllObjects];
    });
}

@end
