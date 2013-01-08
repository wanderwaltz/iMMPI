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
#import "TestAnswersInputViewController.h"

#import "Model.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kGroupCellIdentifier = @"com.immpi.cells.personsGroup";

static NSString * const kSegueListGroup    = @"com.immpi.segue.listGroup";
static NSString * const kSegueViewTrash    = @"com.immpi.segue.viewTrash";


#pragma mark -
#pragma mark PersonsListViewController private

@interface PersonsListViewController()
<EditTestRecordViewControllerDelegate, TestRecordModelByDateDelegate>
{
    id<TestRecordStorage> _storage;
    id<TestRecordStorage> _trashStorage;
    
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
        self.segueHandler = [MMPISegueHandler new];
        
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

#pragma mark SegueSourceEditAnswers

- (id<TestRecordProtocol>) testRecordToEditAnswersWithSender: (id) sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
    FRB_AssertNotNil(indexPath);
    
    
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    NSAssert((group.numberOfRecords == 1), @"kSegueEditAnswers should be performed only if number of records in a group is exactly equal to 1");
    
    return group.allRecords[0];
}


- (id<TestRecordStorage>) storageToEditAnswersWithSender: (id) sender
{
    return _storage;
}


#pragma mark SegueSourceEditRecord

- (NSString *) titleForEditingTestRecord: (id<TestRecordProtocol>) record withSender: (id) sender
{
    if ([sender isKindOfClass: [UITableViewCell class]])
        return ___Edit_Record;
    else
        return ___New_Record;
}


- (id<TestRecordProtocol>) testRecordToEditWithSender: (id) sender
{
    if ([sender isKindOfClass: [UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        return group.allRecords[0];
    }
    else
    {
        return [TestRecord new];
    }
}


- (id<EditTestRecordViewControllerDelegate>) delegateForEditingTestRecordWithSender: (id) sender
{
    return self;
}


#pragma mark SegueSourceListRecords

- (id<MutableTableViewModel>) modelForListRecordsWithSender: (id) sender
{
    if ([sender isKindOfClass: [UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        TestRecordModelByDate *model = [TestRecordModelByDate new];
        model.delegate = self;
        
        [model addObjectsFromArray: group.allRecords];

        return model;
    }
    else
    {
        TestRecordModelByDate *model = [TestRecordModelByDate new];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_trashStorage loadStoredTestRecords];
            NSArray *allRecords = [_trashStorage allTestRecords];
            
            if (allRecords.count > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [model addObjectsFromArray: allRecords];
                    // TODO: update controller
                });
            }
        });
        
        return model;
    }
}


- (id<TestRecordStorage>) storageForListRecordsWithSender: (id) sender
{
    if ([sender isKindOfClass: [UITableViewCell class]])
        return _storage;
    else
        return _trashStorage;
}


- (NSString *) titleForListRecordsWithSender: (id) sender
{
    if ([sender isKindOfClass: [UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);

        return group.name;
    }
    else
        return ___Trash;
}


#pragma mark -
#pragma mark private

- (void) initStorageInBackgroundIfNeeded
{
    if (_storage == nil)
    {
        _storage      = [[JSONTestRecordsStorage alloc]
                         initWithDirectoryName: kJSONTestRecordStorageDirectoryDefault];
        
        _trashStorage = [[JSONTestRecordsStorage alloc]
                         initWithDirectoryName: kJSONTestRecordStorageDirectoryTrash];
        
        [(id)_storage setTrashStorage: _trashStorage];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_storage loadStoredTestRecords];
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


- (BOOL) deleteGroup: (id<TestRecordsGroupByName>) group
         atIndexPath: (NSIndexPath *) indexPath
{
    for (id<TestRecordProtocol> record in group.allRecords)
    {
        FRB_AssertConformsTo(record, TestRecordProtocol);
        [_storage removeTestRecord: record];
    }
    
    return [_model removeObject: group];
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
        [self performSegueWithIdentifier: kSegueIDAnswersInput sender: sender];
    }
}


                      - (void) tableView: (UITableView *) tableView
accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    id sender = [tableView cellForRowAtIndexPath: indexPath];
    
    [self performSegueWithIdentifier: kSegueIDEditGroup sender: sender];
}


- (UITableViewCellEditingStyle) tableView: (UITableView *) tableView
            editingStyleForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return UITableViewCellEditingStyleDelete;
}


                         - (NSString *) tableView: (UITableView *) tableView
titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);
    
    if (group.numberOfRecords == 1) return ___Delete;
    else
        return [NSString stringWithFormat: ___FORMAT_Delete_N_Records, group.numberOfRecords];
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


   - (BOOL) tableView: (UITableView *) tableView
canEditRowAtIndexPath: (NSIndexPath *) indexPath
{
    return YES;
}


- (void) tableView: (UITableView *) tableView
commitEditingStyle: (UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath: (NSIndexPath *) indexPath
{
    FRB_AssertNotNil(indexPath);
    
    id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(group, TestRecordsGroupByName);

    if ([self deleteGroup: group
              atIndexPath: indexPath])
    {
        [self.tableView deleteRowsAtIndexPaths: @[indexPath]
                              withRowAnimation: UITableViewRowAnimationAutomatic];
    }
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
        
        [self performSegueWithIdentifier: kSegueIDBlankDetail sender: self];
    }
}


#pragma mark -
#pragma mark TestRecordModelByDateDelegate

// PersonsListViewController is set as a delegate to a certain TestRecordModelByDate
// when a group of records is selected. Then RecordsListViewContronller is pushed to
// the current navigation stack and is set up to share the _storage with this class
// and to have a TestRecordModelByDate as a model.
//
// This happens when a group is not empty and contains more than one test record.

- (BOOL) testRecordModelByDate: (TestRecordModelByDate *) model
            shouldAddNewObject: (id<TestRecordProtocol>) record
{
    // We select a first test record in the model.
    //
    // This method assumes that at least one record does exist in the model.
    // This is true if no records were deleted in RecordsListViewController which
    // manages the TestRecordModelByDate. But if the last record has been deleted
    // from the model, the corresponding delegate method should ensure that the
    // navigation stack is popped to the current PersonsListViewController, which
    // will result in deleting of the model, and no more delegate methods firing.
    //
    // That said, we can relatively safely assume that there is at least one record
    // in the TestRecordModelByDate.
    
    NSIndexPath             *indexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    id<TestRecordProtocol> otherRecord = [model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(otherRecord, TestRecordProtocol);
    
    // And check whether the new record has the same person name
    if ([otherRecord.person.name isEqualToString: record.person.name])
        // If name is the same, add the record to TestRecordModelByDate,
        // it will be added to the _model in -testRecordModelByDate:didAddNewObject:
        // delegate method
        return YES;
    else
    {
        // If the name is not the same, we should not add this record to the
        // TestRecordModelByDate, since we try to contain a list of persons
        // with the same name there.
        //
        // Instead we add the record to _model and pop the navigation stack
        // to show a list of all persons where the newly added record will
        // also be contained.
        [_model addNewObject: record];
        [self.tableView reloadData];
        [self.navigationController popToViewController: self
                                              animated: YES];
        return NO;
    }
    
    // IMPORTANT!!!
    //
    // Note that none of the delegate methods implementations are
    // storing the record into permanent storage here. This is a
    // smelly code somewhat since we assume that the record is saved
    // elsewhere (it indeed is being saved by the RecordsListViewController,
    // but it is a private implementation detail).
    //
}


- (void) testRecordModelByDate: (TestRecordModelByDate *) model
               didAddNewObject: (id<TestRecordProtocol>) record
{
    // If the -testRecordModelByDate:shouldAddNewObject: returned YES,
    // the record is already added to the TestRecordModelByDate, so
    // we only add it to _model and reload the table view.
    [_model addNewObject: record];
    [self.tableView reloadData];
}


// The delegate methods which handle records update are essentially
// the same as the delegate methods which handle addition of a new
// record, see comments there for the explanation of how this works
// and why.
- (BOOL) testRecordModelByDate: (TestRecordModelByDate *) model
            shouldUpdateObject: (id<TestRecordProtocol>) record
{
    id<TestRecordsGroupByName> group = [_model groupForRecord: record];
    
    if ([group.name isEqualToString: record.person.name])
        return YES;
    else
    {
        [_model updateObject: record];
        [self.tableView reloadData];
        [self.navigationController popToViewController: self
                                              animated: YES];
        return NO;
    }
}


- (void) testRecordModelByDate: (TestRecordModelByDate *) model
               didUpdateObject: (id<TestRecordProtocol>) record
{
    [_model updateObject: record];
    [self.tableView reloadData];

}


// The delegate methods which handle records removal are essentially
// the same as the delegate methods which handle addition of a new
// record, see comments there for the explanation of how this works
// and why.
- (BOOL) testRecordModelByDate: (TestRecordModelByDate *) model
            shouldRemoveObject: (id<TestRecordProtocol>) record
{
    id<TestRecordsGroupByName> group = [_model groupForRecord: record];
    
    if (group.numberOfRecords > 1)
        return YES;
    else
    {
        [_model removeObject: record];
        [self.tableView reloadData];
        [self.navigationController popToViewController: self
                                              animated: YES];
    
        return NO;
    }
}


- (void) testRecordModelByDate: (TestRecordModelByDate *) model
               didRemoveObject: (id<TestRecordProtocol>) record
{
    [_model removeObject: record];
    [self.tableView reloadData];
    
}


@end
