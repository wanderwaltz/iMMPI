//
//  TestRecordStorageProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark TestRecordStorage protocol

@protocol TestRecordStorage <NSObject>
@required

- (BOOL) addNewTestRecord: (id<TestRecord>) testRecord;
- (BOOL) updateTestRecord: (id<TestRecord>) testRecord;

- (BOOL) loadStoredTestRecords;

- (NSArray *) allTestRecords;

@end
