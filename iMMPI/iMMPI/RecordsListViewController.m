//
//  RecordsListViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 27.10.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "RecordsListViewController.h"
#import "EditTestRecordViewController.h"
#import "TestAnswersViewController.h"
#import "TestAnswersInputViewController.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kRecordCellIdentifier = @"com.immpi.cells.record";


#pragma mark -
#pragma mark RecordsListViewController private

@interface RecordsListViewController()<EditTestRecordViewControllerDelegate>
{
    NSDateFormatter *_dateFormatter;
}

@end


#pragma mark -
#pragma mark RecordsListViewController implementation

@implementation RecordsListViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    // Model may be set externally by the object which created
    // the RecordsListViewController; if not, create a default
    // model as TestRecordModelByDate
    if (_model == nil) _model = [TestRecordModelByDate new];
    
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
    
    id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    return record;
}


- (id<TestRecordStorage>) storageToEditAnswersWithSender: (id) sender
{
    return _storage;
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


- (id<TestRecordStorage>) storageForAnalysisWithSender: (id) sender
{
    return self.storage;
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
        
        id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
        FRB_AssertConformsTo(record, TestRecordProtocol);
        
        return record;
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


#pragma mark -
#pragma mark private

- (void) initStorageInBackgroundIfNeeded
{
    if (_storage == nil)
    {
        _storage = [JSONTestRecordsStorage new];
    }
    
    
    if (_storage.allTestRecords.count == 0)
    {
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


- (NSString *) abbreviatePersonName: (NSString *) name
{
    NSArray *components = [name componentsSeparatedByCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (components.count == 0) return nil;
    
    NSMutableArray *abbreviated = [NSMutableArray array];
    
    [abbreviated addObject: components[0]];
    
    if (components.count > 1)
    {
        for (NSUInteger i = 1; i < components.count; ++i)
        {
            NSString *component = components[i];
            
            if (component.length > 0)
                [abbreviated addObject:
                 [NSString stringWithFormat: @"%@.",
                 [[component substringToIndex: 1] uppercaseString]]];
        }
    }
    
    return [abbreviated componentsJoinedByString: @" "];
}


- (BOOL) deleteTestRecord: (id<TestRecordProtocol>) record
              atIndexPath: (NSIndexPath *) indexPath
{
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    [_storage removeTestRecord: record];
    
    return [_model removeObject: record];
}


#pragma mark -
#pragma mark UITableViewDelegate

     - (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    id sender = [tableView cellForRowAtIndexPath: indexPath];
    
    
    // If already answered the test, go straight to analyzer
    if (record.testAnswers.allStatementsAnswered)
        [self performSegueWithIdentifier: kSegueIDAnalyzer sender: sender];
    
    // Else we have to input all answers first
    else
        [self performSegueWithIdentifier: kSegueIDAnswersInput sender: sender];
}


- (UITableViewCellEditingStyle) tableView: (UITableView *) tableView
            editingStyleForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (NSString *) tableView: (UITableView *) tableView
titleForDeleteConfirmationButtonForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return ___Delete;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kRecordCellIdentifier];
    FRB_AssertNotNil(cell);
    
    id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    cell.textLabel.text       = [self abbreviatePersonName: record.person.name];
    cell.detailTextLabel.text = [_dateFormatter stringFromDate: record.date];
    
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
    
    id<TestRecordProtocol> record = [_model objectAtIndexPath: indexPath];
    FRB_AssertConformsTo(record, TestRecordProtocol);
    
    if ([self deleteTestRecord: record
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
#pragma mark SegueDestinationListRecords

- (void) setModelForListRecords: (id<MutableTableViewModel>) model
{
    self.model = model;
}


- (void) setStorageForListRecords: (id<TestRecordStorage>) storage
{
    self.storage = storage;
}


- (void) setTitleForListRecords: (NSString *) title
{
    self.title = title;
}


- (void) setSelectedTestRecord:(id<TestRecordProtocol>)testRecord
{
    if (testRecord != nil)
    {
        NSIndexPath *indexPath = [_model indexPathForObject: testRecord];
        
        // For some reason row cannot be selected without dispatch_async here
        // even though 'Selection: clear on appearance' is set to NO in the storyboard
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView selectRowAtIndexPath: indexPath
                                        animated: YES
                                  scrollPosition: UITableViewScrollPositionNone];
        });
    }
}

@end
