//
//  TargetContainer.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeakImageConsumer;
@protocol ImageConsumer;

@interface TargetContainer : NSObject

@property (nonatomic, readonly, strong) NSMutableArray<WeakImageConsumer *> *targets;

@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

- (instancetype)init;

- (void)appendWithTarget:(id<ImageConsumer>)target indexAtTarget:(NSUInteger)index;

- (void)removeAll;

@end
