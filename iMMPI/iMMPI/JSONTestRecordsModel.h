//
//  JSONTestRecordsModel.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 29.12.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "Model.h"


#pragma mark -
#pragma mark JSONTestRecordsModel interface

@interface JSONTestRecordsModel : NSObject<MutableTableViewModel>

- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection: (NSUInteger) section;

- (id<TestRecord>) objectAtIndexPath: (NSIndexPath *) indexPath;

- (BOOL) addNewObject: (id<TestRecord>) record;
- (BOOL) updateObject: (id<TestRecord>) record;



- (void) loadRecordsFromDisk;

@end
