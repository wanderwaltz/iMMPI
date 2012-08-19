//
//  CoreDataStack.h
//  WWBrain
//
//  Created by Egor Chiglintsev on 04.08.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#pragma mark -
#pragma mark Constants

extern NSString * const kCoreDataException;
extern NSString * const kCoreDataExceptionNSErrorKey;


#pragma mark -
#pragma mark Typedefs

typedef void (^CoreDataStackErrorHandler)(NSError *error);


#pragma mark -
#pragma mark CoreDataStack interface

@interface CoreDataStack : NSObject
{
    /*  Core Data objects (model, context, store coordinator) are
        created lazily, i.e. on-demand, when user tries to access
        these objects. So the model name specified when creating
        the CoreDataStack object should be stored somewhere till
        then. 
     */
    NSString *_modelName;
    
    // Core Data
    NSManagedObjectModel         *_model;
    NSManagedObjectContext       *_mainContext;
    NSPersistentStoreCoordinator *_storeCoordinator;
}

@property (readonly, atomic) NSManagedObjectModel         *model;
@property (readonly, atomic) NSManagedObjectContext       *mainContext;
@property (readonly, atomic) NSPersistentStoreCoordinator *storeCoordinator;

+ (id) coreDataStackWithModelName: (NSString *) modelName;
- (id) initWithModelName: (NSString *) modelName;

#pragma mark main context operations

/*  Calls -pefrormBlock: with a given block on main managed object context.
    Note that this block will be performed asynchronously.
 */
- (void) do: (dispatch_block_t) block;


/* Calls -performBlockAndWait: with a given block on main managed object context
 */
- (void) doWait: (dispatch_block_t) block;

- (BOOL) saveMainContext;

- (BOOL) saveContext: (NSManagedObjectContext *) context
        errorHandler: (CoreDataStackErrorHandler) errorHandler;

#pragma mark persistent stores

- (void) addInMemoryStore;
- (void) addPersistentStoreWithType: (NSString *) storeType
                                URL: (NSURL *) URL;


#pragma mark defaults 

/*  By default model is assumed to be stored in the application
    main bundle, this method is used to return the URL for the
    .momd file with a specified name stored there. 
 
    If the model is stored somewhere else, you could subclass
    the CoreDataStack and override this method to return the
    proper URL.
 */
- (NSURL *) URLForModelWithName: (NSString *) modelName;


@end
