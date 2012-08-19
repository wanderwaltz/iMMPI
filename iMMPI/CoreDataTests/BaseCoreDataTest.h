//
//  BaseCoreDataTest.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "CoreDataStack.h"
#import "Entity.h"

#pragma mark -
#pragma mark BaseCoreDataTest interface

/*  Base test class for 'Core Data' target. Creates and tears down a CoreDataStack object.
 */
@interface BaseCoreDataTest : GHTestCase
{
    CoreDataStack *_coreData;
}

- (void) setupCoreData;
- (void) teardownCoreData;


#pragma mark persistent store

- (NSString *) persistentStoreType;

- (NSURL *) persistentStoreURL;

- (void) deletePersistentStore;

@end
