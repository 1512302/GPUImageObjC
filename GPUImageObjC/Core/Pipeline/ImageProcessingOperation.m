//
//  ImageProcessingOperation.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ImageProcessingOperation.h"
#import "CommonFuntion.h"

@interface ImageProcessingOperation ()

@end


@implementation ImageProcessingOperation

@synthesize maximumInputs;

@synthesize sources;

@synthesize targets;

#pragma mark - ImageConsumer
- (void)newTextureAvailable:(Texture *)texture fromSourceIndex:(NSUInteger)index {
    ABSTRACT_METHOD;
}

- (NSInteger)addSource:(id<ImageSource>)source {
    return addSourceForImageConsumer(source, self);
}


- (void)removeSourceAtIndex:(NSUInteger)index {
    removeSourceAtIndexForImageConsumer(index, self);
}

- (void)setSource:(id<ImageSource>)source atIndex:(NSUInteger)index {
    setSourceForImageConsumer(source, index, self);
}

#pragma mark - ImageSource
- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index {
    //Do something in subclass
}

- (void)addTarget:(id<ImageConsumer>)target {
    addTargetForImageSource(target, self);
}

- (void)addTarget:(id<ImageConsumer>)target atTargetIndex:(NSUInteger)index {
    addTargetForImageSourceAtIndex(target, index, self);
}

- (void)removeAllTargets {
    removeAllTargetsForImageSource(self);
}

- (void)updateTargetsWithTexture:(Texture *)texture {
    updateTargetsWithTextureForImageSource(texture, self);
}

- (id<ImageConsumer>)additionPrecedence:(id<ImageConsumer>)destination {
    additionPrecedence(self, destination);
    return destination;
}


@end
