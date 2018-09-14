//
//  SourceContainer.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageSource;

@interface SourceContainer : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<ImageSource>> *sources;

- (instancetype)init;

- (NSInteger)appendWithSource:(id<ImageSource>)source maximumInputs:(NSUInteger)maxInputs;

- (NSInteger)insertWithSource:(id<ImageSource>)source atIndex:(NSUInteger)index maximumInputs:(NSUInteger)maxInputs;

- (void)removeAtIndex:(NSUInteger)index;

@end
