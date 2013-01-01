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

/*! Encapsulates a persistent storage for objects conforming to TestRecordProtocol.
 */
@protocol TestRecordStorage <NSObject>
@required

/*! This method should add a new test record into the storage. 
 
 The behavior is undefined if the record already exists. Classes adopting this protocol may choose to add the same record twice or to update the existing one in this case.
 
 This method should return YES or NO depending on whether the operation was successful.
 
 @param testRecord A TestRecordProtocol object to be added to the storage.
 
 @return YES if the record has been added to storage, NO otherwise.
 */
- (BOOL) addNewTestRecord: (id<TestRecordProtocol>) testRecord;



/*! This method should update the existing record from the storage.
 
 If the record does not yet exist in storage, this method should do nothing and return NO.
 
 @param testRecord A TestRecordProtocol object to be updated in the persistent storage.
 
 @return YES if the record exists in storage and has been successfully updated. NO if update failed or record does not exist.
 */
- (BOOL) updateTestRecord: (id<TestRecordProtocol>) testRecord;



/*! This method should check whether the provided TestRecordProtocol object does exist in the storage.
 
 @param testRecord A TestRecordProtocol object to be searched within storage.
 
 @return YES if the record does exist in storage, NO otherwise.
 */
- (BOOL) containsTestRecord: (id<TestRecordProtocol>) testRecord;



/*! This method should load all TestRecordProtocol objects stored in the persistent storage.
 
 @return YES if operation succeeded, NO otherwise.
 */
- (BOOL) loadStoredTestRecords;



/*! This method should return all test records currently loaded.
 
 @return An array of TestRecordProtocol objects.
 */
- (NSArray *) allTestRecords;

@end
