//
//  TestRecordModelByDate.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestRecordModelByDate.h"


#pragma mark -
#pragma mark TestRecordModelByDate private

@interface TestRecordModelByDate()
{
    NSMutableArray *_records;
}

@end


#pragma mark -
#pragma mark TestRecordModelByDate implementation

@implementation TestRecordModelByDate

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _records = [NSMutableArray array];
    }
    return self;
}

#pragma mark -
#pragma mark MutableTableViewModel

- (NSUInteger) numberOfSections
{
    return 1;
}


- (NSUInteger) numberOfRowsInSection: (NSUInteger) section
{
    return _records.count;
}


- (id<TestRecord>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    return _records[indexPath.row];
}


- (void) addObjectsFromArray: (NSArray *) array
{
    [_records addObjectsFromArray: array];
}


- (BOOL) addNewObject: (id<TestRecord>) object
{
    FRB_AssertNotNil(object);
    
    [_records addObject: object];
    
    return YES;
}


- (BOOL) updateObject: (id<TestRecord>) object
{
    FRB_AssertNotNil(object);
    return [_records indexOfObject: object] != NSNotFound;
}

@end
