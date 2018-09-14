//
//  ImageConsumerProtocol.h
//  GPUImage4Mac
//
//  Created by CPU11367 on 9/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageSource;
@class SourceContainer;
@class Texture;

@protocol ImageConsumer

@property (nonatomic) NSUInteger maximumInputs;

@property (nonatomic, strong) SourceContainer *sources;

- (void)newTextureAvailable:(Texture *)texture fromSourceIndex:(NSUInteger)index;

@required

/**
 If not modify this method, must call function:
 addSourceForImageConsumer(source, self);
 
 */
- (NSInteger)addSource:(id<ImageSource>)source;

/**
 If not modify this method, must call function:
 setSourceForImageConsumer(source, index, self);
 
 */
- (void)setSource:(id<ImageSource>)source atIndex:(NSUInteger)index;

/**
 If not modify this method, must call function:
 setSourceForImageConsumer(source, index, self);
 
 */
- (void)removeSourceAtIndex:(NSUInteger)index;

@end

// Default class conform to protocol

@interface ImageConsumer : NSObject <ImageConsumer>

@end


// Default function for ImageConsumer protocol

NSInteger addSourceForImageConsumer(id<ImageSource> source, id<ImageConsumer> imageConsumer);

void setSourceForImageConsumer(id<ImageSource> source, NSUInteger index, id<ImageConsumer> imageConsumer);

void removeSourceAtIndexForImageConsumer(NSUInteger index, id<ImageConsumer> imageConsumer);
