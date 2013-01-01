//
//  TestRecordModelGroupedByName.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestRecordModelGroupedByName.h"


#pragma mark -
#pragma mark TestRecordModelGroupedByName private

@interface TestRecordModelGroupedByName()
{
    NSMutableArray *_records;
}

@end


#pragma mark -
#pragma mark TestRecordModelGroupedByName implementation

@implementation TestRecordModelGroupedByName

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


- (id<TestRecordProtocol>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    return _records[indexPath.row];
}


- (void) addObjectsFromArray: (NSArray *) array
{
    [_records addObjectsFromArray: array];
}


- (BOOL) addNewObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    
    [_records addObject: object];
    
    return YES;
}


- (BOOL) updateObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        return YES;
    }
    else return NO;
}

@end
