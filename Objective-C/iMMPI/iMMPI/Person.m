//
//  Person.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Person.h"


#pragma mark -
#pragma mark Person implementation

@implementation Person

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _ageGroup = AgeGroupAdult;
        _gender   = GenderMale;
    }
    return self;
}

@end
