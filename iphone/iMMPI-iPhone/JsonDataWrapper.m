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

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _jsonData = [JsonData instance];
    }
    return self;
}


#pragma mark -
#pragma mark NSCoding

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super init];
    
    if (self != nil)
    {
        _jsonData = [[JsonData alloc] initWithCoder: aDecoder];
    }
    
    return self;
}


- (void) encodeWithCoder: (NSCoder *) aCoder
{
    [aCoder encodeObject: _jsonData];
}

@end
