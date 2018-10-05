//
//  LookupFilter.h
//  GPUImageObjC
//
//  Created by CPU11367 on 10/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInput.h"
#import "BasicOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookupFilter : BasicOperation

@property (nonatomic, readwrite) float intensity;

@property (nonatomic, readwrite, strong) PictureInput *lookupImage;

@end

NS_ASSUME_NONNULL_END
