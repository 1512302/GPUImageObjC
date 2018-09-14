//
//  ImageConsumerProtocol.m
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "ImageConsumerProtocol.h"
#import "ImageSourceProtocol.h"
#import "SourceContainer.h"
#import "CommonFuntion.h"

@interface ImageConsumer ()

@end

@implementation ImageConsumer

@synthesize maximumInputs;

@synthesize sources;

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

@end

NSInteger addSourceForImageConsumer(id<ImageSource> source, id<ImageConsumer> imageConsumer) {
    return [imageConsumer.sources appendWithSource:source maximumInputs:imageConsumer.maximumInputs];
}

void setSourceForImageConsumer(id<ImageSource> source, NSUInteger index, id<ImageConsumer> imageConsumer) {
    [imageConsumer.sources insertWithSource:source atIndex:index maximumInputs:imageConsumer.maximumInputs];
}

void removeSourceAtIndexForImageConsumer(NSUInteger index, id<ImageConsumer> imageConsumer) {
    [imageConsumer.sources removeAtIndex:index];
}
