//
//  CoreDataTableViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 26.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "CoreDataTableController.h"

#pragma mark -
#pragma mark CoreDataTableViewController implementation

@implementation CoreDataTableController

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        [self createFetchedResultsController];
    }
    return self;
}


#pragma mark -
#pragma mark public: working with data

- (id) objectAtIndexPath: (NSIndexPath *) indexPath
{
    return [_fetchedResultsController objectAtIndexPath: indexPath];
}


#pragma mark -
#pragma mark public: fetching data

- (void) fetchDataWithCompletion: (CoreDataTableControllerFetchCallback) completion
{
    completion = [completion copy];
    [_fetchedResultsController.managedObjectContext performBlock:
     ^{
         NSError *error = nil;
         [_fetchedResultsController performFetch: &error];
         
         if (completion != nil)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion((error == nil), error);
             });
         }
     }];
}


- (NSFetchRequest *) fetchRequest
{
    return nil; // To be overridden in subclasses
}


- (NSManagedObjectContext *) managedObjectContext
{
    return [Model coreData].mainContext;
}


- (NSString *) sectionNameKeyPath
{
    return nil;
}


- (NSString *) cacheName
{
    return nil;
}


#pragma mark -
#pragma mark private

- (void) createFetchedResultsController
{
    NSFetchRequest    *fetchRequest = [self fetchRequest];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if ((fetchRequest != nil) && (context != nil))
    {
        _fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                            managedObjectContext: context
                                              sectionNameKeyPath: [self sectionNameKeyPath]
                                                       cacheName: [self cacheName]];
        _fetchedResultsController.delegate = self;
    }
}


#pragma mark -
#pragma mark public: table view cells

- (UITableViewCell *) tableView: (UITableView *) tableView
           cellForManagedObject: (id) managedObject
                    atIndexPath: (NSIndexPath *) indexPath
{
    static NSString * const kCellIdentifier = @"CoreDataTableViewController_Default";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                      reuseIdentifier: kCellIdentifier];
    }
    
    cell.textLabel.text = @"Implement -tableView:cellForManagedObject:atIndexPath:";
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSString *) tableView: (UITableView *) tableView
 titleForHeaderInSection: (NSInteger) section
{
    return [_fetchedResultsController.sectionIndexTitles objectAtIndex: section];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return _fetchedResultsController.sections.count;
}


- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    id<NSFetchedResultsSectionInfo> sectionInfo =
    [_fetchedResultsController.sections objectAtIndex: section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    id object = [_fetchedResultsController objectAtIndexPath: indexPath];
    return [self tableView: tableView
      cellForManagedObject: object
               atIndexPath: indexPath];
}


- (NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView
{
    return [_fetchedResultsController sectionIndexTitles];
}


- (NSInteger) tableView: (UITableView *) tableView
sectionForSectionIndexTitle: (NSString *)    title
                atIndex: (NSInteger)     index
{
    return [_fetchedResultsController sectionForSectionIndexTitle: title
                                                          atIndex: index];
}


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

/*  The section index titles get messed up for some reason
    if we do not implement this method. The whole logic of 
    this method does not seem to have any influence on the
    result. We can return sectionName directly, or take
    a substring to index 1, nothing changes. If this method
    is present, the section index titles are returned as
    intended, if this method is not present, index titles
    are just wrong with cyrillic section titles.
 
    I've added the -rangeOfComposedCharacterSequenceAtIndex:
    because this seems more robust.
 */
      - (NSString *) controller: (NSFetchedResultsController *) controller
sectionIndexTitleForSectionName: (NSString *) sectionName
{
    if (sectionName.length > 0)
        return [sectionName substringWithRange:
                [sectionName rangeOfComposedCharacterSequenceAtIndex: 0]];
    else
        return @"#";
}

@end
