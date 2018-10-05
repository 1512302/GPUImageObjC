//
//  PictureInput.m
//  GPUImage4iOS
//
//  Created by CPU11367 on 10/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInput.h"

@implementation PictureInput

@synthesize targets = _targets;

- (instancetype)init {
    self = [super init];
    if (self) {
        _targets = [TargetContainer new];
        _hasProcessedImage = false;
        _internalImage = nil;
    }
    return self;
}

- (instancetype)initWithCGImage:(CGImageRef)image {
    self = [self init];
    if (self) {
        _internalImage = image;
    }
    return self;
}

- (void)processImage {
    __weak __typeof(self) weakSelf = self;
    if (_internalTexture) {
        Texture *texture = _internalTexture;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateTargetsWithTexture:texture];
            weakSelf.hasProcessedImage = true;
        });
    } else {
        MTKTextureLoader *textureLoader = [[MTKTextureLoader alloc] initWithDevice:[MetalRenderingDevice shared].device];
        
        [textureLoader newTextureWithCGImage:_internalImage options:@{MTKTextureLoaderOptionSRGB:@(NO)} completionHandler:^(id<MTLTexture>  _Nullable texture, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Something error: %@", error);
                return;
            }
            if (!texture) {
                NSLog(@"Nil texture received");
                return;
            }
            self.internalImage = nil;
            self.internalTexture = [[Texture alloc] initWithOrientation:ImageOrientationPortrait texture:texture];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateTargetsWithTexture:self.internalTexture];
                self.hasProcessedImage = true;
            });
            
        }];
    }
}

- (void)transmitPreviousImageToTarget:(id<ImageConsumer>)target atIndex:(NSUInteger)index {
    if (_hasProcessedImage) {
        [target newTextureAvailable:self.internalTexture fromSourceIndex:index];
    }
}

@end
