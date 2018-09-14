//
//  ImageSourceProtocol.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TargetContainer;
@protocol ImageConsumer;
@class Texture;


@protocol ImageSource

@property (nonatomic, strong) TargetContainer *targets;

- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index;

@required

- (void)addTarget:(id<ImageConsumer>)target;

- (void)addTarget:(id<ImageConsumer>)target atTargetIndex:(NSUInteger)index;

- (void)removeAllTargets;

- (void)updateTargetsWithTexture:(Texture *)texture;

- (id<ImageConsumer>) additionPrecedence:(id<ImageConsumer>)destination;

@end


// Default class conform to protocol
@interface ImageSource : NSObject <ImageSource>

@end


// Default function for ImageConsumer protocol

void addTargetForImageSource(id<ImageConsumer> target, id<ImageSource> imageSource);

void addTargetForImageSourceAtIndex(id<ImageConsumer> target, NSUInteger atTargetIndex, id<ImageSource> imageSource);

void removeAllTargetsForImageSource(id<ImageSource> imageSource);

void updateTargetsWithTextureForImageSource(Texture *texture, id<ImageSource> imageSource);

id<ImageConsumer> additionPrecedence(id<ImageSource> source, id<ImageConsumer> destination);
