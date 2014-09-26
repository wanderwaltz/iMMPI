//
//  NSArray+Helpers.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.09.14.
//  Copyright (c) 2014 Egor Chiglintsev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Helpers)

- (NSArray *)map:(id (^)(id item))block;
- (NSArray *)filter:(BOOL (^)(id item))block;

@end
