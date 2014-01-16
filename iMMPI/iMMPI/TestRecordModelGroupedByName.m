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
#pragma mark methods

- (TestRecordModelGroupedByName *) modelByFilteringWithSearchQuery: (NSString *) searchTerm
{
    NSArray *filteredRecords =
    [_records filteredArrayUsingPredicate:
     [NSPredicate predicateWithBlock:
      ^BOOL(id<TestRecordProtocol> record, NSDictionary *bindings) {
          return [[[record person] name].lowercaseString rangeOfString:
                  searchTerm.lowercaseString].location != NSNotFound;
    }]];
    
    TestRecordModelGroupedByName *filteredModel = [TestRecordModelGroupedByName new];
    [filteredModel addObjectsFromArray: filteredRecords];
    
    return filteredModel;
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
    if ((indexPath.section == 0) && (indexPath.row < _groups.count))
        return _groups[indexPath.row];
    else
        return nil;
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
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        for (TestRecordsPersonGroup *group in _groups)
        {
            FRB_AssertClass(group, TestRecordsPersonGroup);
            
            if ([group.allRecords indexOfObject: object] != NSNotFound)
            {
                if (![group.name isEqualToString: object.person.name])
                {
                    [group removeRecord: object];
                    
                    if (group.allRecords.count == 0)
                        [_groups removeObject: group];
                    
                    [_records removeObject: object];
                    [self addNewObject:     object];
                    
                    break;
                }
            }
        }
        
        return YES;
    }
    else return NO;
}


- (BOOL) removeObject: (id) recordOrGroup
{
    // This method supports test records
    if ([recordOrGroup conformsToProtocol: @protocol(TestRecordProtocol)])
        return [self removeTestRecord: recordOrGroup];
    
    // Or entire test record groups
    else if ([recordOrGroup conformsToProtocol: @protocol(TestRecordsGroupByName)])
        return [self removeGroup: recordOrGroup];
    
    // Else an assertion is failed to indicate that something went wrong
    else
    {
        FRB_ShouldNeverHappen(@"Expected either TestRecordProtocol object or TestRecordsGroupByName object");
        return NO;
    }
}


- (id<TestRecordsGroupByName>) groupForRecord: (id<TestRecordProtocol>) record
{
    FRB_AssertNotNil(record);
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    id<TestRecordsGroupByName> found = nil;
    
    for (id<TestRecordsGroupByName> group in _groups)
    {
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        if ([group.allRecords indexOfObject: record] != NSNotFound)
        {
            found = group;
            break;
        }
    }
    
    
    return found;
}


- (NSIndexPath *) indexPathForObject: (id) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordsGroupByName);
    
    NSUInteger index = [_groups indexOfObject: object];
    
    if (index != NSNotFound)
    {
        return [NSIndexPath indexPathForRow: index inSection: 0];
    }
    else return nil;
}


#pragma mark -
#pragma mark private

- (BOOL) removeGroup: (id<TestRecordsGroupByName>) group
{
    FRB_AssertNotNil(group);
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    NSUInteger index = [_groups indexOfObject: group];
    
    if (index != NSNotFound)
    {
        for (id<TestRecordProtocol> record in group.allRecords)
        {
            [_records removeObject: record];
        }
        
        [_groups removeObject: group];
        
        return YES;
    }
    else return NO;
}


- (BOOL) removeTestRecord: (id<TestRecordProtocol>) object
{
    FRB_AssertNotNil(object);
    FRB_AssertConformsTo(object, TestRecordProtocol);
    
    NSUInteger index = [_records indexOfObject: object];
    
    if (index != NSNotFound)
    {
        [_records removeObject: object];
        
        for (TestRecordsPersonGroup *group in _groups)
        {
            FRB_AssertClass(group, TestRecordsPersonGroup);
            
            if ([group.allRecords indexOfObject: object] != NSNotFound)
            {
                [group removeRecord: object];
                
                if (group.allRecords.count == 0)
                    [_groups removeObject: group];
                
                [_records removeObject: object];
                
                break;
            }
        }
        
        return YES;
    }
    else return NO;
}

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
