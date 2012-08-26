//
//  CoreDataTableViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "BaseTableViewController.h"

#pragma mark -
#pragma mark CoreDataTableViewController

/*  A table view controller used to display a list of objects returned
    by a fetch request. Optionally supports editing.
 */
@interface CoreDataTableViewController : BaseTableViewController
<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultsController;
}

#pragma mark fetching data

- (NSManagedObjectContext *) managedObjectContext;

- (NSFetchRequest *) fetchRequest; // Fetch request must have sort descriptors

- (NSString *) sectionNameKeyPath;
- (NSString *) cacheName;

#pragma mark table view cells

- (UITableViewCell *) tableView: (UITableView *) tableView
           cellForManagedObject: (id) managedObject
                    atIndexPath: (NSIndexPath *) indexPath;

@end
