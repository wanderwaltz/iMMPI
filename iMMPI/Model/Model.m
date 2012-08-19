//
//  Model.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 19.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "Model.h"

#pragma mark -
#pragma mark Model implementation

@implementation Model

#pragma mark -
#pragma mark methods

+ (CoreDataStack *) coreData
{
    return [[self sharedModel] coreData];
}


+ (void) setupCoreData
{
    [[self sharedModel] setupCoreData];
}


+ (void) tearDownCoreData
{
    [[self sharedModel] tearDownCoreData];
}


#pragma mark -
#pragma mark private

- (void) setupCoreData
{
    _coreData = [CoreDataStack coreDataStackWithModelName: @"Model"];
    [_coreData addInMemoryStore];
}


- (void) tearDownCoreData
{
    _coreData = nil;
}


- (CoreDataStack *) coreData
{
    return _coreData;
}


#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        
    }
    return self;
}


#pragma mark -
#pragma mark singleton

+ (Model *) sharedModel
{
    static dispatch_once_t predicate  = 0;
    __strong static id sharedInstance = nil;
    
    dispatch_once(&predicate,
                  ^{
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}


@end
