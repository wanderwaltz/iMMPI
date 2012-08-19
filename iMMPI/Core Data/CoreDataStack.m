//
//  CoreDataStack.m
//  WWBrain
//
//  Created by Egor Chiglintsev on 04.08.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "CoreDataStack.h"

#pragma mark -
#pragma mark Constants

NSString * const kCoreDataException           = @"Core Data Exception";
NSString * const kCoreDataExceptionNSErrorKey = @"Error";

#pragma mark -
#pragma mark CoreDataStack implementation

@implementation CoreDataStack

#pragma mark -
#pragma mark properties

- (NSManagedObjectModel *) model
{
    @synchronized(self)
    {
        if ((_model == nil) && (_modelName.length > 0))
        {
            NSURL *URL = [self URLForModelWithName: _modelName];
            _model = [[NSManagedObjectModel alloc] initWithContentsOfURL: URL];
        }
        
        return _model;
    }
}


- (NSManagedObjectContext *) mainContext
{
    @synchronized(self)
    {
        if (!_mainContext)
        {
            NSPersistentStoreCoordinator *coordinator = [self storeCoordinator];
            
            if (coordinator != nil)
            {
                _mainContext = [[NSManagedObjectContext alloc]
                                initWithConcurrencyType: NSPrivateQueueConcurrencyType];
                
                [_mainContext setPersistentStoreCoordinator: coordinator];
            }
        }
        
        return _mainContext;
    }
}


- (NSPersistentStoreCoordinator *) storeCoordinator
{
    @synchronized(self)
    {
        if (_storeCoordinator == nil)
        {
            NSManagedObjectModel *model = [self model];
            
            if (model != nil)
            {
                _storeCoordinator = [[NSPersistentStoreCoordinator alloc]
                                     initWithManagedObjectModel: model];
            }
        }

        return _storeCoordinator;
    }
}


#pragma mark -
#pragma mark initialization methods

+ (id) coreDataStackWithModelName: (NSString *) modelName
{
    return [[[self class] alloc] initWithModelName: modelName];
}


- (id) initWithModelName: (NSString *) modelName
{
    self = [super init];
    
    if (self != nil)
    {
        _modelName = [modelName copy];
    }
    return self;
}


#pragma mark -
#pragma mark main context operations

- (void) do: (dispatch_block_t) block
{
    [[self mainContext] performBlock: block];
}


- (void) doWait: (dispatch_block_t) block
{
    [[self mainContext] performBlockAndWait: block];
}


- (BOOL) saveMainContext
{
    return [self saveContext: [self mainContext]
                errorHandler:
     ^(NSError *error)
    {
        [self raiseException: kCoreDataException
                      reason: @"Failed to save main managed object context, "
                              @"see userInfo dictionary for details."
                       error: error];
    }];
}


- (BOOL) saveContext: (NSManagedObjectContext *) context
        errorHandler: (CoreDataStackErrorHandler) errorHandler
{
    __block NSError *error = nil;
    __block BOOL     saved = [context save: &error];
    
    if (!saved && (errorHandler != nil))
    {
        errorHandler(error);
    }
    
    return saved;
}


#pragma mark -
#pragma mark persistent stores

- (void) addPersistentStoreWithType: (NSString *) storeType
                                URL: (NSURL *) URL
{
    NSError *error = nil;
    
    [[self storeCoordinator]
     addPersistentStoreWithType: storeType
                  configuration: nil
                            URL: URL
                        options: nil
                          error: &error];
    
    if (error != nil)
    {
        [self raiseException: kCoreDataException
                      reason: [NSString stringWithFormat:
                               @"An error occured while trying to add persistent store of type '%@',"
                               @"see userInfo dictionary for details", storeType]
                       error: error];
    }
}


- (void) addInMemoryStore
{
    [self addPersistentStoreWithType: NSInMemoryStoreType URL: nil];
}


#pragma mark -
#pragma mark defaults

- (NSURL *) URLForModelWithName: (NSString *) modelName
{
    return [[NSBundle mainBundle] URLForResource: modelName
                                   withExtension: @"momd"];
}


#pragma mark -
#pragma mark private: exceptions

- (void) raiseException: (NSString *) exception
                 reason: (NSString *) reason
               userInfo: (NSDictionary *) userInfo
{
    [[NSException exceptionWithName: exception
                             reason: reason
                           userInfo: userInfo]
     raise];
}


- (void) raiseException: (NSString *) exception
                 reason: (NSString *) reason
                  error: (NSError *) error
{
    NSAssert(error != nil, @"Trying to raise exception with nil error value");
    
    [self raiseException: exception
                  reason: reason
                userInfo:
     [NSDictionary dictionaryWithObject: error forKey: kCoreDataExceptionNSErrorKey]];
}

@end
