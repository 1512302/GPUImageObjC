//
//  FilterPipeline.m
//  GPUImageObjC
//
//  Created by CPU11367 on 9/27/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#import "FilterPipeline.h"

@import UIKit;

@interface FilterPipeline ()

@property (nonatomic, readwrite, strong) NSString *stringValue;

@property (nonatomic, readwrite, strong) NSMutableArray *filters;

@end

@implementation FilterPipeline

- (instancetype)initWithConfiguration:(NSDictionary *)configuration input:(id<ImageSource>)input output:(id<ImageConsumer>)output {
    self = [super init];
    if (self) {
        _input = input;
        _output = output;
        if (![self parseConfiguration:configuration]) {
            NSLog(@"Sorry, a parsing error occurred.");
            //abort();
        }
        [self refreshFilters];
    }
    return self;
}

- (instancetype)initWithConfigurationFile:(NSURL *)configuration input:(id<ImageSource>)input output:(id<ImageConsumer>)output {
    return [self initWithConfiguration:[NSDictionary dictionaryWithContentsOfURL:configuration] input:input output:output];
}

- (BOOL)parseConfiguration:(NSDictionary *)configuration {
    NSArray *filters = [configuration objectForKey:@"Filters"];
    if (!filters) {
        return NO;
    }
    
    NSError *regexError = nil;
    NSRegularExpression *parsingRegex = [NSRegularExpression regularExpressionWithPattern:@"(float|CGPoint|NSString)\\((.*?)(?:,\\s*(.*?))*\\)"
                                                                                  options:0
                                                                                    error:&regexError];
    
    // It's faster to put them into an array and then pass it to the filters property than it is to call [self addFilter:] every time
    NSMutableArray *orderedFilters = [NSMutableArray arrayWithCapacity:[filters count]];
    for (NSDictionary *filter in filters) {
        NSString *filterName = [filter objectForKey:@"FilterName"];
        Class theClass = NSClassFromString(filterName);
        id<ImageProcessingOperation> genericFilter = [[theClass alloc] init];
        // Set up the properties
        NSDictionary *filterAttributes;
        if ((filterAttributes = [filter objectForKey:@"Attributes"])) {
            for (NSString *propertyKey in filterAttributes) {
                // Set up the selector
                SEL theSelector = NSSelectorFromString(propertyKey);
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[theClass instanceMethodSignatureForSelector:theSelector]];
                [inv setSelector:theSelector];
                [inv setTarget:genericFilter];
                
                // check selector given with parameter
                if ([propertyKey hasSuffix:@":"]) {
                    
                    _stringValue = nil;
                    
                    // Then parse the arguments
                    NSMutableArray *parsedArray;
                    if ([[filterAttributes objectForKey:propertyKey] isKindOfClass:[NSArray class]]) {
                        NSArray *array = [filterAttributes objectForKey:propertyKey];
                        parsedArray = [NSMutableArray arrayWithCapacity:[array count]];
                        for (NSString *string in array) {
                            NSTextCheckingResult *parse = [parsingRegex firstMatchInString:string
                                                                                   options:0
                                                                                     range:NSMakeRange(0, [string length])];
                            
                            NSString *modifier = [string substringWithRange:[parse rangeAtIndex:1]];
                            if ([modifier isEqualToString:@"float"]) {
                                // Float modifier, one argument
                                CGFloat value = [[string substringWithRange:[parse rangeAtIndex:2]] floatValue];
                                [parsedArray addObject:[NSNumber numberWithFloat:value]];
                                [inv setArgument:&value atIndex:2];
                            } else if ([modifier isEqualToString:@"CGPoint"]) {
                                // CGPoint modifier, two float arguments
                                CGFloat x = [[string substringWithRange:[parse rangeAtIndex:2]] floatValue];
                                CGFloat y = [[string substringWithRange:[parse rangeAtIndex:3]] floatValue];
                                CGPoint value = CGPointMake(x, y);
                                [parsedArray addObject:[NSValue valueWithCGPoint:value]];
                            } else if ([modifier isEqualToString:@"NSString"]) {
                                // NSString modifier, one string argument
                                _stringValue = [[string substringWithRange:[parse rangeAtIndex:2]] copy];
                                [inv setArgument:&_stringValue atIndex:2];
                                
                            } else {
                                return NO;
                            }
                        }
                        [inv setArgument:&parsedArray atIndex:2];
                    } else {
                        NSString *string = [filterAttributes objectForKey:propertyKey];
                        NSTextCheckingResult *parse = [parsingRegex firstMatchInString:string
                                                                               options:0
                                                                                 range:NSMakeRange(0, [string length])];
                        
                        NSString *modifier = [string substringWithRange:[parse rangeAtIndex:1]];
                        if ([modifier isEqualToString:@"float"]) {
                            // Float modifier, one argument
                            CGFloat value = [[string substringWithRange:[parse rangeAtIndex:2]] floatValue];
                            [inv setArgument:&value atIndex:2];
                        } else if ([modifier isEqualToString:@"CGPoint"]) {
                            // CGPoint modifier, two float arguments
                            CGFloat x = [[string substringWithRange:[parse rangeAtIndex:2]] floatValue];
                            CGFloat y = [[string substringWithRange:[parse rangeAtIndex:3]] floatValue];
                            CGPoint value = CGPointMake(x, y);
                            [inv setArgument:&value atIndex:2];
                        } else if ([modifier isEqualToString:@"NSString"]) {
                            // NSString modifier, one string argument
                            _stringValue = [[string substringWithRange:[parse rangeAtIndex:2]] copy];
                            [inv setArgument:&_stringValue atIndex:2];
                            
                        } else {
                            return NO;
                        }
                    }
                }
                
                
                [inv invoke];
            }
        }
        [orderedFilters addObject:genericFilter];
    }
    _filters = orderedFilters;
    
    return YES;
}

- (void)refreshFilters {
    
    id prevFilter = _input;
    id<ImageProcessingOperation> theFilter = nil;
    
    for (int i = 0; i < [_filters count]; i++) {
        theFilter = [_filters objectAtIndex:i];
        [prevFilter removeAllTargets];
        [prevFilter addTarget:theFilter];
        prevFilter = theFilter;
    }
    
    [prevFilter removeAllTargets];
    
    if (_output != nil) {
        [prevFilter addTarget:_output];
    }
}


@end
