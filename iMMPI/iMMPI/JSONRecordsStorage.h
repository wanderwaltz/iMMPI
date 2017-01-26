//
//  JSONRecordsStorage.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "RecordStorageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class JSONRecordSerialization;
@class JSONRecordIndexSerialization;

#pragma mark -
#pragma mark Constants

extern NSString * const kJSONRecordStorageDirectoryDefault;
extern NSString * const kJSONRecordStorageDirectoryTrash;


#pragma mark -
#pragma mark JSONRecordsStorage interface

/*! An implementation of RecordStorage which stores each RecordProtocol object in JSON format in a separate file in Documents directory.
 */
@interface JSONRecordsStorage: NSObject<RecordStorage>

@property (strong, nonatomic) JSONRecordSerialization *serialization;
@property (strong, nonatomic) JSONRecordIndexSerialization *indexSerialization;

/*! Another RecordStorage object which will be used to store records deleted
 from the current storage.
 */
@property (strong, nonatomic) id<RecordStorage> _Nullable trashStorage;


/*! Initializes the storage with a directory name to store the records within.
 
 The subdirectory with a given name is created in Documents directory to store the records, so all the files will be backed up to iCloud by default.
 
 @param storageDirectoryName Name of a directory to store the records within.
 */
- (id)initWithDirectoryName:(NSString *)storageDirectoryName;



/*! This method serializes the record object in JSON format and saves it to disk. The file name is selected depending on the test record data and if the file with the same name already exists, it is not overwritten, and a new file name is selected to save the record.
 
 @param record A RecordProtocol object to be added to the storage.
 
 @return YES if the record has been added to storage, NO otherwise.
 */
- (BOOL)addNewRecord:(id<RecordProtocol>)record;



/*! This method serializes the record object in JSON format ans saves it to disk. The test record file is overwritten as the result of this operation.
 
 If the record does not yet exist in storage, this method does nothing and returns NO.
 
 @param record A RecordProtocol object to be updated in the persistent storage.
 
 @return YES if the record exists in storage and has been successfully updated. NO if update failed or record does not exist.
 */
- (BOOL)updateRecord:(id<RecordProtocol>)record;


/*! This method checks whether the provided RecordProtocol object does exist in the storage.
 
 Test records are compared by reference.
 
 @param record A RecordProtocol object to be searched within storage.
 
 @return YES if the record does exist in storage, NO otherwise.
 */
- (BOOL)containsRecord:(id<RecordProtocol>)record;



/*! This method loads all JSON test record files and parses these into RecordProtocol objects.
 
 @return YES if operation succeeded, NO otherwise.
 */
- (BOOL)loadStoredRecords;



/*! This method returns all test records currently loaded.
 
 This method does create a new NSArray instance with the list of test records currently loaded, so it should not be called too often for performance reasons.
 
 @return An array of RecordProtocol objects.
 */
- (NSArray<id<RecordProtocol>> *)allRecords;

@end
NS_ASSUME_NONNULL_END
