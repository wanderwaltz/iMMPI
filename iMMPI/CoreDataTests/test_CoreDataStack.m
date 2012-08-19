//
//  test_CoreDataStack.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "test_CoreDataStack.h"

#pragma mark -
#pragma mark test_CoreDataStack implementation

@implementation test_CoreDataStack

#pragma mark -
#pragma mark setup

/*  For some of the test cases it is important that the persistent store
    is of the in-memory type, so we state this explicitly.
 */
- (NSString *) persistentStoreType
{
    return NSInMemoryStoreType;
}


#pragma mark -
#pragma mark test cases

- (void) test_init
{
    GHAssertNotNil(_coreData                 , @"");
    GHAssertNotNil(_coreData.model           , @"");
    GHAssertNotNil(_coreData.mainContext     , @"");
    GHAssertNotNil(_coreData.storeCoordinator, @"");
}


- (void) test_performBlockAndWait
{
    __block BOOL blockWasPerformed = NO;
    
    [_coreData doWait:^{
        blockWasPerformed = YES;
    }];
    
    GHAssertTrue(blockWasPerformed, @"");
}


- (void) test_performBlock
{
    __block BOOL blockWasPerformed = NO;
    
    [_coreData do:^{
        blockWasPerformed = YES;
    }];
    
    while (!blockWasPerformed) {};
    
    GHAssertTrue(blockWasPerformed, @"");
}


/*  This test case verifies if [self teardownCoreData]; [self setupCoreData]; calls
    indeed delete the core data stack and recreate it from scratch so that objects
    are not persisted between 'old' core data stack and 'new' core data stack.
 
    This test case relies on the store type being NSInMemoryStoreType.
 */
- (void) test_recreateCoreData
{
    [_coreData doWait: ^{
        Entity *entity =
        [NSEntityDescription insertNewObjectForEntityForName: @"Entity"
                                      inManagedObjectContext: _coreData.mainContext];
        
        GHAssertNotNil(entity, @"");
        
        entity.stringAttribute = @"Entity";
    }];
    
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName: @"Entity"];
    
    
    [_coreData doWait: ^{
        
        NSError *error = nil;
        
        NSArray *results = [_coreData.mainContext executeFetchRequest: fetchRequest
                                                                error: &error];
        
        GHAssertNil(error, @"Expected error to be nil, got %@", error);
        GHAssertEquals(results.count, 1u, @"");
        
        GHAssertEqualStrings([[results lastObject] stringAttribute], @"Entity", @"");
    }];
    
    [self teardownCoreData];
    
    GHAssertNil(_coreData, @"");
    
    [self setupCoreData];
    
    [self test_init]; // Check the _coreData is intact
    
    [_coreData doWait: ^{
        
        NSError *error = nil;
        
        NSArray *results = [_coreData.mainContext executeFetchRequest: fetchRequest
                                                                error: &error];
        
        GHAssertNil(error, @"Expected error to be nil, got %@", error);
        GHAssertEquals(results.count, 0u, @"");
    }];
}


@end
