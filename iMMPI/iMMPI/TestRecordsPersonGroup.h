//
//  TestRecordsPersonGroup.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "TestRecordModelGroupedByName.h"


#pragma mark -
#pragma mark TestRecordsPersonGroup interface

@interface TestRecordsPersonGroup : NSObject<TestRecordsGroupByName>
@property (readonly, nonatomic) NSArray  *allRecords;
@property (readonly, nonatomic) NSString *name;

- (NSUInteger) numberOfRecords;

- (id) initWithName: (NSString *) name;

- (void)    addRecord: (id<TestRecordProtocol>) record;
- (void) removeRecord: (id<TestRecordProtocol>) record;

- (void) sortRecords;

@end
