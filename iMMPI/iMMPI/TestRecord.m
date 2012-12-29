//
//  TestRecord.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestRecord.h"


#pragma mark -
#pragma mark TestRecord implementation

@implementation TestRecord

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _person = [Person new];
        _date   = [NSDate date];
        
        _testAnswers = [TestAnswers new];
    }
    
    return self;
}

@end
