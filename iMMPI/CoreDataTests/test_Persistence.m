//
//  test_Persistence.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "test_Persistence.h"

#pragma mark -
#pragma mark test_Persistence implementation

@implementation test_Persistence

#pragma mark -
#pragma mark setup

- (BOOL) shouldRunOnMainThread
{
    return YES;
}


- (NSString *) persistentStoreType
{
    return NSBinaryStoreType;
}


- (NSURL *) persistentStoreURL
{
    return [NSDocumentsDirectoryURL() URLByAppendingPathComponent: @"Store"];
}


#pragma mark -
#pragma mark helper methods

- (void) insertEntityObject
{
    [_coreData doWait: ^{
        Entity *entity =
        [NSEntityDescription insertNewObjectForEntityForName: @"Entity"
                                      inManagedObjectContext: _coreData.mainContext];
        
        GHAssertNotNil(entity, @"");
        
        entity.stringAttribute = @"Entity";
        entity.boolAttribute   = YES;
        entity.dateAttribute   = [NSDate dateWithTimeIntervalSince1970: 0.0];
    }];
}


- (void) validateEntityObject: (Entity *) entity
{
    GHAssertEqualStrings(entity.stringAttribute, @"Entity", @"");
    GHAssertTrue(entity.boolAttribute, @"");
    GHAssertEqualObjects(entity.dateAttribute, [NSDate dateWithTimeIntervalSince1970: 0.0], @"");
}


- (NSArray *) fetch: (NSFetchRequest *) request
{
    NSError *error   = nil;
    NSArray *results = [_coreData.mainContext executeFetchRequest: request
                                                            error: &error];
    
    GHAssertNil(error, @"Expected error to be nil, got %@", error);
    
    return results;
}


#pragma mark -
#pragma mark assertions

- (void) assert_exactlyOneEntity
{
    [_coreData doWait: ^{
        
        NSFetchRequest *fetchRequest =
        [NSFetchRequest fetchRequestWithEntityName: @"Entity"];
        
        NSArray *results = [self fetch: fetchRequest];
        
        GHAssertEquals(results.count, 1u, @"");
        
        [self validateEntityObject: [results lastObject]];
    }];
}


- (void) assert_noEntities
{
    [_coreData doWait: ^{
        
        NSFetchRequest *fetchRequest =
        [NSFetchRequest fetchRequestWithEntityName: @"Entity"];
        
        NSArray *results = [self fetch: fetchRequest];
        
        GHAssertEquals(results.count, 0u, @"");
    }];
}


#pragma mark -
#pragma mark test cases

- (void) test_recreateCoreData_saveStore
{
    [self insertEntityObject];
    
    [self assert_exactlyOneEntity];
    
    [_coreData doWait:^{
       [_coreData saveMainContext];
    }];
    
    [self teardownCoreData];
    
    GHAssertNil(_coreData, @"");

    [self setupCoreData];
    
    [self assert_exactlyOneEntity];
}


- (void) test_recreateCoreData_deleteStore
{
    [self insertEntityObject];
    
    [self assert_exactlyOneEntity];
    
    [_coreData doWait:^{
        [_coreData saveMainContext];
    }];
    
    [self teardownCoreData];
    [self deletePersistentStore];
    
    GHAssertNil(_coreData, @"");
    
    [self setupCoreData];
    
    [self assert_noEntities];
}

@end
