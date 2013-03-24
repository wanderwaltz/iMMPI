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

#import "MMPIATestRecordReader.h"

#import "ProgressAlertView.h"

#import "Model.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kGroupCellIdentifier = @"com.immpi.cells.personsGroup";


#pragma mark -
#pragma mark PersonsListViewController private

@interface PersonsListViewController()
<EditTestRecordViewControllerDelegate, TestRecordModelByDateDelegate>
{
    id<TestRecordStorage> _storage;
    id<TestRecordStorage> _trashStorage;
    
    MMPIATestRecordReader *_legacyRecordsReader;
    
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
#pragma mark actions

- (void) refreshAction: (UIRefreshControl *) sender
{
    [self loadLegacyMMPIARecords];
}


#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        self.segueHandler = [MMPISegueHandler new];
        
        _model = [TestRecordModelGroupedByName new];
        
        _legacyRecordsReader = [[MMPIATestRecordReader alloc] initWithDirectoryName:
                                kMMPIATestRecordReaderDirectoryDefault];
        
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle: ___Back
                                         style: UIBarButtonItemStyleBordered
                                        target: nil
                                        action: nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserverForName: UIApplicationDidBecomeActiveNotification
                     object: nil
                      queue: [NSOperationQueue mainQueue]
                 usingBlock:
         ^(NSNotification *note) {
             [self loadLegacyMMPIARecords];
         }];
    }
    return self;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void) awakeFromNib
{
    // For some weird reason setting the action for refresh control
    // in Interface Builder would not work, and setting the action
    // programmatically in -initWithCoder: would crash the app with
    // some strange error:
    //
    // 'NSInternalInconsistencyException', reason: 'Could not load NIB in bundle:
    //    'NSBundle <path to the .app here> (loaded)' with name 'nvo-jh-oP6-view-txJ-t0-aON''
    //
    // So the only solution was to do assign the action in -awakeFromNib
    [self.refreshControl addTarget: self
                            action: @selector(refreshAction:)
                  forControlEvents: UIControlEventValueChanged];
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
    // Either a table view cell can end up as a 'sender' for segue
    if ([sender isKindOfClass: [UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        NSAssert((group.numberOfRecords == 1), @"kSegueEditAnswers should be performed only if number of records in a group is exactly equal to 1");
        
        return group.allRecords[0];
    }
    // Or a test record (this happens if we perform segue
    // programmatically after adding a new test record)
    else if ([sender conformsToProtocol: @protocol(TestRecordProtocol)])
    {
        return sender;
    }
    // No other sender objects are supported
    else
    {
        NSAssert(NO, @"Unsupported sender object in -testRecordToEditAnswersWithSender: method: %@", sender);
        return nil;
    }
}


- (id<TestRecordStorage>) storageToEditAnswersWithSender: (id) sender
{
    return _storage;
}


#pragma mark SegueSourceEditRecord

- (NSString *) titleForEditingTestRecord: (id<TestRecordProtocol>) record withSender: (id) sender
{
    // If the segue was initiated by a table view cell,
    // then we are editing an existing test record or group
    // displayed by the table view cell.
    if ([sender isKindOfClass: [UITableViewCell class]])
        return ___Edit_Record;
    
    // If a bar button item initiates the segue, then
    // it is the '+' button to add new record
    else if ([sender isKindOfClass: [UIBarButtonItem class]])
        return ___New_Record;
    
    // Other sender objects are not supported
    else
    {
        NSAssert(NO, @"Unknown sender object in -titleForEditingTestRecord:withSender: method: %@", sender);
        return nil;
    }
}


- (id<TestRecordProtocol>) testRecordToEditWithSender: (id) sender
{
    // If a table view cell initiates the segue, then we have
    // a certain test records group to work with. We select a
    // first record in the group and return it for editing.
    if ([sender isKindOfClass: [UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        return group.allRecords[0];
    }
    
    // If a bar button item initiated the segue, it is the '+'
    // button which adds a new record, so we create a new
    // TestRecord instance to edit
    else if ([sender isKindOfClass: [UIBarButtonItem class]])
    {
        return [TestRecord new];
    }
    
    else
    {
        NSAssert(NO, @"Unknown sender object in -testRecordToEditWithSender: method: %@", sender);
        return nil;
    }
}


- (id<EditTestRecordViewControllerDelegate>) delegateForEditingTestRecordWithSender: (id) sender
{
    return self;
}


#pragma mark SegueSourceAnalyzeRecord

- (id<TestRecordProtocol>) recordForAnalysisWithSender: (id) sender
{
    // Essentialy we can open the analyzer screen only in the
    // same circumstances as if we were editing answers for
    // a certain record - when the corresponding records group
    // contains a single record. So we return the value of an
    // existing method to avoid duplication of code
    return [self testRecordToEditAnswersWithSender: sender];
}


- (id<TestRecordStorage>) storageForAnalysisWithSender:(id)sender
{
    return _storage;
}


#pragma mark SegueSourceListRecords

- (id<MutableTableViewModel>) modelForListRecordsWithSender: (id) sender
{
    // If a table view cell initiated the segue then we have
    // a test records group to work with. We create model
    // accordingly, but first have to find the group object
    // using the indexPath of the cell.
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
    
    // If the sender itself conforms to TestRecordProtocol,
    // we find the group which it belongs to and create the model
    // according to the group found.
    else if ([sender conformsToProtocol: @protocol(TestRecordProtocol)])
    {
        id<TestRecordsGroupByName> group = [_model groupForRecord: sender];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        TestRecordModelByDate *model = [TestRecordModelByDate new];
        model.delegate = self;
        
        [model addObjectsFromArray: group.allRecords];
        
        return model;
    }
    
    // If a bar button item initiated the segue, it is the
    // trash bar button item, so we return a model suitable
    // for displaying trash contents.
    else if ([sender isKindOfClass: [UIBarButtonItem class]])
    {
        TestRecordModelByDate *model = [TestRecordModelByDate new];
        [model addObjectsFromArray: _trashStorage.allTestRecords];
        
        return model;
    }
    
    // All other sender objects are not supported
    else
    {
        NSAssert(NO, @"Unknown sender object in -modelForListRecordsWithSender: method: %@", sender);
        return nil;
    }
}


- (id<TestRecordStorage>) storageForListRecordsWithSender: (id) sender
{
    // If sender is a table view cell then we have a test records group
    // to work with; if sender itself conforms to TestRecordProtocol then
    // we also have a test records group which it belongs to. In both of
    // these cases we assume that the current storage is used to store
    // these records.
    if ([sender isKindOfClass: [UITableViewCell class]] ||
        [sender conformsToProtocol: @protocol(TestRecordProtocol)])
        return _storage;
    
    // If sender is a bar button item, then it is the trash button,
    // so we return the trash storage.
    else if ([sender isKindOfClass: [UIBarButtonItem class]])
        return _trashStorage;
    
    // All other sender objects are unsupported
    else
    {
        NSAssert(NO, @"Unknown sender object in -storageForListRecordsWithSender: method: %@", sender);
        return nil;
    }
}


- (NSString *) titleForListRecordsWithSender: (id) sender
{
    // If sender is a table view cell then we find the group
    // which is represented by this cell and return the group's name
    if ([sender isKindOfClass: [UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        FRB_AssertNotNil(indexPath);
        
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);

        return group.name;
    }
    
    // If sender itself conforms to TestRecordProtocol, we find a group
    // which it belongs to and return the group's name.
    else if ([sender conformsToProtocol: @protocol(TestRecordProtocol)])
    {
        id<TestRecordsGroupByName> group = [_model groupForRecord: sender];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        return group.name;
    }
    
    // If sender is a bar button item then it is the trash button,
    // so we return the ___Trash title.
    else if ([sender isKindOfClass: [UIBarButtonItem class]])
        return ___Trash;
    
    else
    {
        NSAssert(NO, @"Unknown sender object in -titleForListRecordsWithSender: method: %@", sender);
        return nil;
    }
}


- (id<TestRecordProtocol>) selectedTestRecordForListRecordsWithSender: (id) sender
{
    if ([sender conformsToProtocol: @protocol(TestRecordProtocol)])
        return sender;
    else
        return nil;
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
            [_storage      loadStoredTestRecords];
            [_trashStorage loadStoredTestRecords];
            
            NSArray *allRecords = [_storage allTestRecords];
            
            if (allRecords.count > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_model addObjectsFromArray: allRecords];
                    [self.tableView reloadData];
                    [self loadLegacyMMPIARecords];
                });
            }
            else
            {
                [self loadLegacyMMPIARecords];
            }
        });
    }
    else
    {
        [self loadLegacyMMPIARecords];
    }
}


- (void) loadLegacyMMPIARecords
{
    if (!_legacyRecordsReader.isProcessingRecords)
    {
        __block ProgressAlertView *progressAlert = nil;
        
        [_legacyRecordsReader readRecordFilesInBackgroundWithCallback:
         ^(id<TestRecordProtocol> record, NSString *fileName,
           NSUInteger filesTotal, NSUInteger recordsRead) {
             
             if (progressAlert == nil)
             {
                 progressAlert = [[ProgressAlertView alloc] initWithTitle: ___Importing_Records];
                 [progressAlert show];
             }
             
             double progress = 0.0;
             
             if (filesTotal > 0) progress = (double)recordsRead / (double)filesTotal;
             
             progressAlert.progressView.progress = progress;
             progressAlert.message = fileName;
             
             [progressAlert setNeedsDisplay];
             [progressAlert setNeedsLayout];
             
             [_model       addNewObject: record];
             [_storage addNewTestRecord: record];
             
             [self.tableView reloadData];
         }
                                                           completion:
         ^(NSUInteger filesProcessed, NSUInteger recordsRead) {
             [self.refreshControl endRefreshing];
             [progressAlert dismissWithClickedButtonIndex: 0 animated: YES];
         }];
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


- (void) showContentsOfGroupAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath != nil)
    {
        // Expect a group of test records with a same person name in the model
        id<TestRecordsGroupByName> group = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(group, TestRecordsGroupByName);
        
        id sender = [self.tableView cellForRowAtIndexPath: indexPath];
        
        // If group contains several records, show the group contents as a list,
        // if only one record in the group, select it immediately.
        if (group.numberOfRecords > 1)
        {
            [self performSegueWithIdentifier: kSegueIDListGroup sender: sender];
        }
        else if (group.numberOfRecords == 1)
        {
            // A single record in the group
            id<TestRecordProtocol> record = group.allRecords[0];
            
            // If already answered the test, go straight to analyzer
            if (record.testAnswers.allStatementsAnswered)
                [self performSegueWithIdentifier: kSegueIDAnalyzer sender: sender];
            
            // Else we have to input all answers first
            else
                [self performSegueWithIdentifier: kSegueIDAnswersInput sender: sender];
        }
        else
        {
            NSAssert(NO, @"Unexpected group with 0 records");
        }
    }
}


- (void) editAnswersForRecord: (id<TestRecordProtocol>) record
{
    FRB_AssertNotNil(record);
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    id<TestRecordsGroupByName> group = [_model groupForRecord: record];
    
    if (group != nil)
    {
        NSIndexPath *indexPath = [_model indexPathForObject: group];
        
        if (indexPath != nil)
        { 
            // If group contains several records, show the group contents as a list,
            // if only one record in the group, select it immediately.
            if (group.numberOfRecords > 1)
            {
                [self performSegueWithIdentifier: kSegueIDListGroup    sender: record];
                [self performSegueWithIdentifier: kSegueIDAnswersInput sender: record];
            }
            else
            {
                [self performSegueWithIdentifier: kSegueIDAnswersInput sender: record];
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDelegate

     - (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self showContentsOfGroupAtIndexPath: indexPath];
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            id<TestRecordsGroupByName> group = [_model groupForRecord: record];
            
            if (group != nil)
            {
                NSIndexPath *indexPath = [_model indexPathForObject: group];
                
                if (indexPath != nil)
                {
                    [self.tableView selectRowAtIndexPath: indexPath
                                                animated: YES
                                          scrollPosition: UITableViewScrollPositionNone];
                    [self editAnswersForRecord: record];
                }
            }
        });
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
