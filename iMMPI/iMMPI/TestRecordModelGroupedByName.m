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
#import "TestRecordsPersonGroup.h"


#pragma mark -
#pragma mark TestRecordModelGroupedByName private

@interface TestRecordModelGroupedByName()
{
    NSMutableArray *_records;
    NSMutableArray *_groups;
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
        _groups  = [NSMutableArray array];
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
    return _groups.count;
}


- (id<TestRecordProtocol>) objectAtIndexPath: (NSIndexPath *) indexPath
{
    return _groups[indexPath.row];
}


- (void) addObjectsFromArray: (NSArray *) array
{
    [_records addObjectsFromArray: array];
    [self recreateGroups];
}


- (BOOL) addNewObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    [_records addObject: object];
    
    BOOL foundGroup = NO;
    
    for (TestRecordsPersonGroup *group in _groups)
    {
        FRB_AssertClass(group, TestRecordsPersonGroup);
        if ([group.name isEqualToString: object.person.name])
        {
            [group addRecord: object];
            [group sortRecords];
            
            foundGroup = YES;
            break;
        }
    }
    
    if (!foundGroup)
    {
        TestRecordsPersonGroup *group =
        [[TestRecordsPersonGroup alloc] initWithName: object.person.name];
        
        [group addRecord: object];
        
        [_groups addObject: group];
    }
    
    [self sortGroups];
    
    return YES;
}


- (BOOL) updateObject: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        for (TestRecordsPersonGroup *group in _groups)
        {
            FRB_AssertClass(group, TestRecordsPersonGroup);
            if (![group.name isEqualToString: object.person.name])
            {
                [group removeRecord: object];
                
                [_records removeObject: object];
                [self addNewObject:     object];
                
                break;
            }
        }
        
        return YES;
    }
    else return NO;
}


#pragma mark -
#pragma mark private

- (void) recreateGroups
{
    [_groups removeAllObjects];
    
    if (_records.count > 0)
    {
        [_records sortUsingDescriptors:
         @[[NSSortDescriptor sortDescriptorWithKey: @"person.name" ascending: YES]]];
        
        NSString *currentName = [_records[0] person].name;
        
        TestRecordsPersonGroup *group =
        [[TestRecordsPersonGroup alloc] initWithName: currentName];
        
        for (id<TestRecordProtocol> record in _records)
        {
            if ([currentName isEqualToString: record.person.name])
            {
                [group addRecord: record];
            }
            else
            {
                [_groups addObject: group];
                
                currentName = record.person.name;
                group       = [[TestRecordsPersonGroup alloc] initWithName: currentName];
                
                [group addRecord: record];
            }
        }
        
        [_groups addObject: group];
    }
}


- (void) sortGroups
{
    [_groups sortUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey: @"name" ascending: YES]]];
}

@end
