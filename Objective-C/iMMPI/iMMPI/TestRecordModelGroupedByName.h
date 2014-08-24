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

/*! A protocol for grouping multiple TestRecordProtocol objects by the person name.
 */
@protocol TestRecordsGroupByName<NSObject>
@required

/// Number of TestRecordProtocol objects in the group.
- (NSUInteger) numberOfRecords;


/// Name of the group. All TestRecordProtocol objects contained in the group are expected to have the same person name as the group.
- (NSString *) name;


/// An array of TestRecordProtocol objects contained in the group.
- (NSArray *) allRecords;

@end


#pragma mark -
#pragma mark TestRecordModelGroupedByName interface

/*! A MutableTableViewModel which combines TestRecordProtocol objects into groups by the corresponding person name.
 
 This class is asymmetric in terms of the data model objects it uses: it accepts TestRecordProtocol objects as inputs, but returns TestRecordsGroupByName objects as result.
 */
@interface TestRecordModelGroupedByName : NSObject<MutableTableViewModel>

/// Number of sections in the model
- (NSUInteger) numberOfSections;



/*! Number of groups in section with a given index
 
 @param section Section index
 */
- (NSUInteger) numberOfRowsInSection: (NSUInteger) section;



/*! Returns a TestRecordsGroupByName object corresponding to a given index path.
 
 @param indexPath An index path object corresponding to a certain TestRecordsGroupByName
 
 @return A TestRecordsGroupByName object corresponding to the indexPath if the index path is within the bounds provided by the -numberOfSections and -numberOfRowsInSection: methods. Else returns nil.
 */
- (id<TestRecordsGroupByName>) objectAtIndexPath: (NSIndexPath *) indexPath;



/*! Returns a TestRecordsGroupByName object corresponding to a given TestRecordProtocol object.
 
 @param record A TestRecordProtocol object to search within the model.
 
 @return If record is found in one of the groups, returns the corresponding TestRecordsGroupByName object. Else returns nil.
 */
- (id<TestRecordsGroupByName>) groupForRecord: (id<TestRecordProtocol>) record;



/*! Adds multiple TestRecordProtocol objects to the model.
 
 @param array An array of TestRecordProtocol objects to be added to the model.
 */
- (void) addObjectsFromArray: (NSArray *) array;



/*! Adds a new TestRecordProtocolObject to the model.
 
 This method may either create a new TestRecordsGroupByName object or add the record to an existing group depending on the name of the person corresponding to the record provided.
 
 @param testRecord A TestRecordProtocolObject to be added to the model.
 
 @return YES if the testRecord has been successfully added to the model. NO otherwise.
 */
- (BOOL) addNewObject: (id<TestRecordProtocol>) testRecord;



/*! Updates the provided TestRecordProtocolObject in the model.
 
 If the person name corresponding to the record has been changed, this record is removed from a group which it belonged to and is moved to the group with the proper name. This may result in creating a new group if a group with the corresponding name has not been found. Removal of the testRecord from the group it resided in may result in deleting the group as a whole if the record was a single member of the group.
 
 This method does nothing if the testRecord is not found in the model.
 
 @param testRecord A TestRecordProtocolObject to be updated.
 
 @return YES if the operation was a success. NO if the testRecord has not been found in the model or the operation failed.
 */
- (BOOL) updateObject: (id<TestRecordProtocol>) testRecord;



/*! Finds a NSIndexPath corresponding to the provided TestRecordsGroupByName in the model.
 
 @param group A TestRecordsGroupByName to be updated.
 
 @return an NSIndexPath corresponding to the group or nil if the group has not been found in the model.
 */
- (NSIndexPath *) indexPathForObject: (id<TestRecordsGroupByName>) group;



/*! Removes an object from the model.
 
 @param recordOrGroup The object to be removed from the model. Should conform either to TestRecordProtocol or to TestRecordsGroupByName protocol.
 
 @return YES if an TestRecordProtocol object or TestRecordsGroupByName object has been successfully deleted, NO otherwise.
 */
- (BOOL) removeObject: (id) recordOrGroup;


- (TestRecordModelGroupedByName *) modelByFilteringWithSearchQuery: (NSString *) searchTerm;

@end
