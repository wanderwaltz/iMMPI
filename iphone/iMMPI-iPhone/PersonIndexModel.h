//
//  PersonIndexModel.h
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 5/30/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PersonIndexRecord.h"

#pragma mark -
#pragma mark PersonIndexModel interface

@interface PersonIndexModel : NSObject
{
    NSMutableArray *_indexRecords;
    NSMutableArray *_sectionRanges;
    NSMutableArray *_sectionTitles;
}

- (void) addIndexRecord: (PersonIndexRecord *) indexRecord;

- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection: (NSUInteger) section;

- (PersonIndexRecord *) recordAtIndexPath: (NSIndexPath *) indexPath NS_RETURNS_NOT_RETAINED;

- (NSString *) titleForSection: (NSUInteger) section NS_RETURNS_NOT_RETAINED;

- (NSArray *) sectionIndexTitles NS_RETURNS_NOT_RETAINED;

- (NSUInteger) sectionForSectionIndexTitle: (NSString *) title;

@end
