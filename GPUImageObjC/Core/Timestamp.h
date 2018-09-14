//
//  Timestamp.h
//  GPUImage_iOS
//
//  Created by CPU11367 on 8/27/18.
//  Copyright © 2018 Red Queen Coder, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimestampFlags : NSObject

@property (nonatomic, assign) uint32_t rawValue;

//- (instancetype)initWithValue:(uint32_t)rawValue;
//
//+ (TimestampFlags *)valid;
//
//+ (TimestampFlags *)hasBeenRounded;
//
//+ (TimestampFlags *)positiveInfinity;
//
//+ (TimestampFlags *)negativeInfinity;
//
//+ (TimestampFlags *)indefinite;

@end

@interface Timestamp : NSObject

@property (nonatomic, assign) int64_t value;

@property (nonatomic, assign) int32_t timescale;

@property (nonatomic, strong) TimestampFlags *flags;

@property (nonatomic, assign) int64_t epoch;

//- (instancetype)initWithValue:(int64_t)value timesacle:(int32_t)timescale flags:(TimestampFlags *)flags epoch:(int64_t)epoch;
//
//- (double_t)seconds;
//
//- (boolean_t)isEqual:(Timestamp *)other;
//
//- (boolean_t)isLess:(Timestamp *)other;

@end
