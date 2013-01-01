//
//  TestRecordModelGroupedByName.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark TestRecordsGroupByName protocol

@protocol TestRecordsGroupByName<NSObject>
@required

- (NSUInteger) numberOfRecords;
- (NSString *) name;

- (NSArray *) allRecords;

@end


#pragma mark -
#pragma mark TestRecordModelGroupedByName interface

@interface TestRecordModelGroupedByName : NSObject<MutableTableViewModel>

- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection: (NSUInteger) section;

- (id<TestRecordsGroupByName>) objectAtIndexPath: (NSIndexPath *) indexPath;

- (void) addObjectsFromArray: (NSArray *) array;

- (BOOL) addNewObject: (id<TestRecordProtocol>) testRecord;
- (BOOL) updateObject: (id<TestRecordProtocol>) testRecord;

@end
