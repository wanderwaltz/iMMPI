//
//  NSArray+Helpers.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (NSArray *)map:(id (^)(id item))block
{
    NSParameterAssert(block != nil);
    if (!block) {
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: self.count];
    
    for (id item in self) {
        id mappedItem = block(item);
        
        if (mappedItem) {
            [result addObject: mappedItem];
        }
    }
    
    return [result copy];
}


- (NSArray *)filter:(BOOL (^)(id item))block
{
    NSParameterAssert(block != nil);
    if (!block) {
        return nil;
    }
    
    return [self map:^id(id item) {
        return (block(item)) ? item : nil;
    }];
}

@end
