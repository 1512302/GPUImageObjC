//
//  ImageSourceProtocol.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ImageSourceProtocol.h"
#import "ImageConsumerProtocol.h"
#import "TargetContainer.h"
#import "WeakImageConsumer.h"
#import "CommonFuntion.h"

@interface ImageSource ()

@end

@implementation ImageSource

@synthesize targets;

- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index {
    ABSTRACT_METHOD;
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
    return additionPrecedence(self, destination);
}

@end


void addTargetForImageSource(id<ImageConsumer> target, id<ImageSource> imageSource) {
    NSInteger index = [target addSource:imageSource];
    if (index < 0) {
        NSLog(@"Warning: tried to add target beyond target's input capacity");
    } else {
        [imageSource.targets appendWithTarget:target indexAtTarget:index];
        [imageSource transmitPreviousImageToTarget:target atIndex:index];
    }
}

void addTargetForImageSourceAtIndex(id<ImageConsumer> target, NSUInteger atTargetIndex, id<ImageSource> imageSource) {
    [target setSource:imageSource atIndex:atTargetIndex];
    [imageSource.targets appendWithTarget:target indexAtTarget:atTargetIndex];
    [imageSource transmitPreviousImageToTarget:target atIndex:atTargetIndex];
}

void removeAllTargetsForImageSource(id<ImageSource> imageSource) {
    for (WeakImageConsumer *imageConsumer in imageSource.targets.targets) {
        [imageConsumer.value removeSourceAtIndex:imageConsumer.indexAtTarget];
    }
    [imageSource.targets removeAll];
}

void updateTargetsWithTextureForImageSource(Texture *texture, id<ImageSource> imageSource) {
    for (WeakImageConsumer *imageConsumer in imageSource.targets.targets) {
        [imageConsumer.value newTextureAvailable:texture fromSourceIndex:imageConsumer.indexAtTarget];
    }
}

id<ImageConsumer> additionPrecedence(id<ImageSource> source, id<ImageConsumer> destination) {
    [source addTarget:destination];
    return destination;
}
