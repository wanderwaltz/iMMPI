//
//  PersonsListViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 02.01.13.
//  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
//

#import "PersonsListViewController.h"
#import "RecordsListViewController.h"
#import "EditTestRecordViewController.h"
#import "TestAnswersViewController.h"
#import "Model.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kGroupCellIdentifier = @"com.immpi.cells.personsGroup";

static NSString * const kSegueAddRecord   = @"com.immpi.segue.addRecord";
static NSString * const kSegueEditGroup   = @"com.immpi.segue.editGroup";
static NSString * const kSegueListGroup   = @"com.immpi.segue.listGroup";
static NSString * const kSegueEditAnswers = @"com.immpi.segue.editAnswers";


#pragma mark -
#pragma mark PersonsListViewController private

@interface PersonsListViewController()<EditTestRecordViewControllerDelegate>
{
    id<TestRecordStorage> _storage;
    
    // This view controller depends alot on the TestRecordModelGroupedByName
    // functionality, so the coupling could not be loosened by using
    // MutableTableViewModel protocol
    TestRecordModelGroupedByName *_model;
}

@end


#pragma mark -
#pragma mark PersonsListViewController implementation

@implementation PersonsListViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _model = [TestRecordModelGroupedByName new];
        
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle: ___Back
                                         style: UIBarButtonItemStyleBordered
                                        target: nil
                                        action: nil];
    }
    return self;
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // We do init storage here since if the view never appears
    // there is no sense loading the records anyway.
    //
    // Once the storage has been initialized, this method does
    // nothing.
    [self initStorageInBackgroundIfNeeded];
}


#pragma mark -
#pragma mark navigation

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Creating a new test record
    if ([segue.identifier isEqualToString: kSegueAddRecord])
    {
        EditTestRecordViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        
        FRB_AssertClass(controller, EditTestRecordViewController);
        
        controller.delegate = self;
        controller.record   = [TestRecord new];
        controller.title    = ___New_Record;
    }
    
    // Editing existing group of test records
    else if ([segue.identifier isEqualToString: kSegueEditGroup])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        
        EditTestRecordViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        FRB_AssertClass(controller, EditTestRecordViewController);
        
        
        controller.delegate = self;
        controller.title    = ___Edit_Record;
        controller.record   = group.allRecords[0];
    }
    
    // Editing test answers for a record
    else if ([segue.identifier isEqualToString: kSegueEditAnswers])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        NSAssert((group.numberOfRecords == 1), @"kSegueEditAnswers should be performed only if number of records in a group is exactly equal to 1");
        
        
        TestAnswersViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        FRB_AssertClass(controller, TestAnswersViewController);
        
        
        controller.record  = group.allRecords[0];
        controller.storage = _storage;
    }
    
    // Viewing contents of a records group
    else if ([segue.identifier isEqualToString: kSegueListGroup])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        
        RecordsListViewController *controller = segue.destinationViewController;
        FRB_AssertClass(controller, RecordsListViewController);
        
        
        controller.model   = [TestRecordModelByDate new];
        controller.storage = _storage;
        controller.title   = group.name;
        
        [controller.model addObjectsFromArray: group.allRecords];
    }
}


#pragma mark -
#pragma mark private

- (void) initStorageInBackgroundIfNeeded
{
    if (_storage == nil)
    {
        _storage = [JSONTestRecordsStorage new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_storage loadStoredTestRecords];
            NSArray *allRecords = [_storage allTestRecords];
            
            if (allRecords.count > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_model addObjectsFromArray: allRecords];
                    [self.tableView reloadData];
                });
            }
        });
    }
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    id sender = [tableView cellForRowAtIndexPath: indexPath];
    
    if (group.numberOfRecords > 1)
    {
        [self performSegueWithIdentifier: kSegueListGroup sender: sender];
    }
    else
    {
        [self performSegueWithIdentifier: kSegueEditAnswers sender: sender];
    }
}


- (void) tableView: (UITableView *) tableView
accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    id sender = [tableView cellForRowAtIndexPath: indexPath];
    
    [self performSegueWithIdentifier: kSegueEditGroup sender: sender];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return [_model numberOfSections];
}


- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_model numberOfRowsInSection: section];
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kGroupCellIdentifier];
    FRB_AssertNotNil(cell);
    
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    cell.textLabel.text = group.name;
    
    if (group.numberOfRecords > 1)
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%d", group.numberOfRecords];
    else
        cell.detailTextLabel.text = nil;
    
    return cell;
    
}


#pragma mark -
#pragma mark EditTestRecordViewControllerDelegate

- (void) editTestRecordViewController: (EditTestRecordViewController *) controller
               didFinishEditingRecord: (id<TestRecordProtocol>) record
{
    [self dismissViewControllerAnimated: YES
                             completion: nil];
    
    if (record != nil)
    {
        if ([_storage containsTestRecord: record])
        {
            [_model       updateObject: record];
            [_storage updateTestRecord: record];
        }
        else
        {
            [_model       addNewObject: record];
            [_storage addNewTestRecord: record];
        }
        
        [self.tableView reloadData];
    }
}

@end
