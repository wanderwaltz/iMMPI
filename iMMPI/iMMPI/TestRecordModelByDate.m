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


- (id<TestRecordProtocol>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordProtocol> object = _records[indexPath.row];
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    return object;
}


- (void) addObjectsFromArray: (NSArray *) array
{
    for (id<TestRecordProtocol> object in array)
    {
        FRB_AssertConformsTo(object, TestRecordProtocol);
    }
    
    [_records addObjectsFromArray: array];
    [self sortRecords];
}


- (BOOL) addNewObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    if ([self delegate_shouldAddNewObject: object])
    {
        [_records addObject: object];
        [self sortRecords];
        
        [self delegate_didAddNewObject: object];
        
        return YES;
    }
    else return NO;
}


- (BOOL) updateObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        if ([self delegate_shouldUpdateObject: object])
        {
            [self sortRecords];
            [self delegate_didUpdateObject: object];
            
            return YES;
        }
        else return NO;
    }
    else return NO;
}


- (BOOL) removeObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        if ([self delegate_shouldRemoveObject: object])
        {
            [_records removeObject: object];
            [self delegate_didRemoveObject: object];
            
            return YES;
        }
        else return NO;
    }
    else return NO;
}


- (NSIndexPath *) indexPathForObject: (id) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        return [NSIndexPath indexPathForRow: index inSection: 0];
    }
    else return nil;
}


#pragma mark -
#pragma mark private 

- (void) sortRecords
{
    [_records sortUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO]]];
}


#pragma mark -
#pragma mark delegate callbacks

- (void) delegate_didAddNewObject: (id<TestRecordProtocol>) record
{
    if ([_delegate respondsToSelector: @selector(testRecordModelByDate:didAddNewObject:)])
    {
        [_delegate testRecordModelByDate: self
                         didAddNewObject: record];
    }
}


- (void) delegate_didUpdateObject: (id<TestRecordProtocol>) record
{
    if ([_delegate respondsToSelector: @selector(testRecordModelByDate:didUpdateObject:)])
    {
        [_delegate testRecordModelByDate: self
                         didUpdateObject: record];
    }
}


- (void) delegate_didRemoveObject: (id<TestRecordProtocol>) record
{
    if ([_delegate respondsToSelector: @selector(testRecordModelByDate:didRemoveObject:)])
    {
        [_delegate testRecordModelByDate: self
                         didRemoveObject: record];
    }
}


- (BOOL) delegate_shouldAddNewObject: (id<TestRecordProtocol>) record
{
    if ([_delegate respondsToSelector: @selector(testRecordModelByDate:shouldAddNewObject:)])
    {
        return [_delegate testRecordModelByDate: self
                             shouldAddNewObject: record];
    }
    else return YES;
}


- (BOOL) delegate_shouldUpdateObject: (id<TestRecordProtocol>) record
{
    if ([_delegate respondsToSelector: @selector(testRecordModelByDate:shouldUpdateObject:)])
    {
        return [_delegate testRecordModelByDate: self
                             shouldUpdateObject: record];
    }
    else return YES;
}


- (BOOL) delegate_shouldRemoveObject: (id<TestRecordProtocol>) record
{
    if ([_delegate respondsToSelector: @selector(testRecordModelByDate:shouldRemoveObject:)])
    {
        return [_delegate testRecordModelByDate: self
                             shouldRemoveObject: record];
    }
    else return YES;
}

@end
