//
//  FilterPipeline.h
//  GPUImageObjC
//
//  Created by CPU11367 on 9/27/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pipeline.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterPipeline : NSObject

@property (nonatomic, readwrite, strong) id<ImageSource> input;

@property (nonatomic, readwrite, strong) id<ImageConsumer> output;

- (instancetype)initWithConfiguration:(NSDictionary *)configuration input:(id<ImageSource>)input output:(id<ImageConsumer>)output;

- (instancetype)initWithConfigurationFile:(NSURL *)configuration input:(id<ImageSource>)input output:(id<ImageConsumer>)output;

@end

NS_ASSUME_NONNULL_END
