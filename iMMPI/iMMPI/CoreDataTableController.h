//
//  CoreDataTableViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "BaseTableViewController.h"

#pragma mark -
#pragma mark Typedefs

// If success==YES, error would be nil
typedef void (^CoreDataTableControllerFetchCallback)(BOOL success, NSError *error);


#pragma mark -
#pragma mark CoreDataTableController

/*  A table view data source implementation used to display a list of objects returned
    by a fetch request.
 */
@interface CoreDataTableController : NSObject
    <UITableViewDataSource, NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}

#pragma mark fetching data

/*  It is not generally safe to call this method if a table view is already
    relying on the target CoreDataTableViewController as on its data source.
 
    Fetching is performed asynchronously, so for longer fetches, there is 
    a chance that the table view would call its data source methods before
    all the objects are fetched. 
 
    The proper solution would be setting table view's dataSource property
    to nil value while fetching data, and setting it back to the 
    CoreDataTableController in the completion callback, which is performed
    on the main thread.
 */
- (void) fetchDataWithCompletion: (CoreDataTableControllerFetchCallback) completion;

#pragma mark working with data

- (id) objectAtIndexPath: (NSIndexPath *) indexPath;

#pragma mark settings

- (NSManagedObjectContext *) managedObjectContext; // Use the main Model context by default

- (NSFetchRequest *) fetchRequest; // Needs to be overridden, fetch request must have sort descriptors
- (NSString *) sectionNameKeyPath; // No sections by default
- (NSString *) cacheName;          // Cache disabled by default


#pragma mark table view cells

// Provides a default implementation in order not to crash the app
- (UITableViewCell *) tableView: (UITableView *) tableView
           cellForManagedObject: (id) managedObject
                    atIndexPath: (NSIndexPath *) indexPath;


@end
