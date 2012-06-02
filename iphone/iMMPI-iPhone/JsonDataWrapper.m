//
//  JsonDataWrapper.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 27.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "JsonDataWrapper.h"

#pragma mark -
#pragma mark JsonDataWrapper implementation

@implementation JsonDataWrapper

#pragma mark -
#pragma mark initialization methods

- (id) initWithData: (NSData *) data
{
    self = [super init];
    
    if (self != nil)
    {
        _jsonData = [[JsonData alloc] initWithData: data];
    }
    return self;
}

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _jsonData = [JsonData instance];
    }
    return self;
}


- (NSData *) serialize
{
    return [_jsonData serialize];
}

@end
