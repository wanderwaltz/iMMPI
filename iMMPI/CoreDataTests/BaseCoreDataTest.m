//
//  BaseCoreDataTest.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "BaseCoreDataTest.h"

#pragma mark -
#pragma mark BaseCoreDataTest implementation

@implementation BaseCoreDataTest

#pragma mark -
#pragma mark GHTestCase

- (void) setUp
{
    [self setupCoreData];
}


- (void) tearDown
{
    [self teardownCoreData];
    [self deletePersistentStore];
}


#pragma mark -
#pragma mark core data

- (void) setupCoreData
{
    _coreData = [CoreDataStack coreDataStackWithModelName: @"Model"];
    [_coreData addPersistentStoreWithType: [self persistentStoreType]
                                      URL: [self persistentStoreURL]];
}


- (void) teardownCoreData
{
    _coreData = nil;
}


#pragma mark -
#pragma mark persistent store

- (NSString *) persistentStoreType
{
    return NSInMemoryStoreType;
}


- (NSURL *) persistentStoreURL
{
    return nil;
}


- (void) deletePersistentStore
{
    NSURL *URL  = [self persistentStoreURL];
    
    if (URL != nil)
    {
        NSString *path = [URL path];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath: path])
        {
            NSError *error = nil;
            
            [fileManager removeItemAtPath: path
                                    error: &error];
            
            NSAssert(error == nil, @"");
        }
    }
}

@end
