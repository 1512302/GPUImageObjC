//
//  FilterEntity.h
//  GPUImageObjC
//
//  Created by CPU11367 on 10/5/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#ifndef FilterEntity_h
#define FilterEntity_h

#import "Pipeline.h"
#import <Foundation/Foundation.h>

@interface FilterEntity : NSObject

@property (nonatomic, readwrite, strong) NSString *filterName;

@property (nonatomic, readwrite, strong) id<ImageProcessing> filter;

@end


#endif /* FilterEntity_h */
