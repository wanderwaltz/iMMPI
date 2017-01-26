//
//  RecordStorageProtocol.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol RecordProtocol;

#pragma mark -
#pragma mark RecordStorage protocol

/*! Encapsulates a persistent storage for objects conforming to RecordProtocol.
 */
@protocol RecordStorage<NSObject>
@required

/*! This method should add a new test record into the storage. 
 
 The behavior is undefined if the record already exists. Classes adopting this protocol may choose to add the same record twice or to update the existing one in this case.
 
 This method should return YES or NO depending on whether the operation was successful.
 
 @param record A RecordProtocol object to be added to the storage.
 
 @return YES if the record has been added to storage, NO otherwise.
 */
- (BOOL)addNewRecord:(id<RecordProtocol>)record NS_SWIFT_NAME(add(_:));



/*! This method should update the existing record from the storage.
 
 If the record does not yet exist in storage, this method should do nothing and return NO.
 
 @param record A RecordProtocol object to be updated in the persistent storage.
 
 @return YES if the record exists in storage and has been successfully updated. NO if update failed or record does not exist.
 */
- (BOOL)updateRecord:(id<RecordProtocol>)record NS_SWIFT_NAME(update(_:));



/*! This method should remove the existing record from the storage.
 
 If the record does not yet exist in storage, this method should do nothing and return NO.
 
 @param record A RecordProtocol object to be removed from the persistent storage.
 
 @return YES if the record existed in storage and has been successfully removed. NO if removal failed or record does not exist.
 */
- (BOOL)removeRecord:(id<RecordProtocol>)record NS_SWIFT_NAME(remove(_:));



/*! This method should check whether the provided RecordProtocol object does exist in the storage.
 
 @param record A RecordProtocol object to be searched within storage.
 
 @return YES if the record does exist in storage, NO otherwise.
 */
- (BOOL)containsRecord:(id<RecordProtocol>)record NS_SWIFT_NAME(contains(_:));



/*! This method should load all RecordProtocol objects stored in the persistent storage.
 
 @return YES if operation succeeded, NO otherwise.
 */
- (BOOL)loadStoredRecords NS_SWIFT_NAME(load());



/*! This method should return all test records currently loaded.
 
 @return An array of RecordProtocol objects.
 */
- (NSArray<id<RecordProtocol>> *)allRecords NS_SWIFT_NAME(all());

@end

NS_ASSUME_NONNULL_END
