//
//  TestRecordsPersonGroup.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestRecordsPersonGroup.h"


#pragma mark -
#pragma mark TestRecordsPersonGroup private

@interface TestRecordsPersonGroup()
{
    NSMutableArray *_allRecords;
}

@end


#pragma mark -
#pragma mark TestRecordsPersonGroup implementation

@implementation TestRecordsPersonGroup

#pragma mark -
#pragma mark initialization methods

- (id) initWithName: (NSString *) name
{
    self = [super init];
    
    if (self != nil)
    {
        _name       = name;
        _allRecords = [NSMutableArray array];
    }
    return self;
}


#pragma mark -
#pragma mark methods

- (void) sortRecords
{
    [_allRecords sortUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey: @"date" ascending: NO]]];
}


- (NSUInteger) numberOfRecords
{
    return _allRecords.count;
}


- (void) addRecord: (id<TestRecordProtocol>) record
{
    FRB_AssertConformsTo(record, TestRecordProtocol);

    NSAssert([_name isEqualToString: record.person.name], @"Expected records with the same person name to be added to a TestRecordsPersonGroup");
    
    [_allRecords addObject: record];
}


- (void) removeRecord: (id<TestRecordProtocol>) record
{
    FRB_AssertConformsTo(record, TestRecordProtocol);
    [_allRecords removeObject: record];
}

@end
