//
//  WeakImageConsumer.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageConsumer;

@interface WeakImageConsumer : NSObject

@property (nonatomic, readonly, weak) id<ImageConsumer> value;

@property (nonatomic, readonly) NSUInteger indexAtTarget;

- (instancetype)initWithValue:(id<ImageConsumer>)value indexAtTarget:(NSUInteger)index;

@end
