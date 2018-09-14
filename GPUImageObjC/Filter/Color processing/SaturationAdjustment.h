//
//  SaturationAdjustment.h
//  GPUImageObjC
//
//  Created by CPU11367 on 9/14/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicOperation.h"

@interface SaturationAdjustment : BasicOperation

@property (nonatomic, readwrite) float saturation;

@end
