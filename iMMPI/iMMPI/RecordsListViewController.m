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
#import "Model.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kRecordCellIdentifier = @"RecordCell";

static NSString * const kSegueAddRecord  = @"com.immpi.segue.addRecord";
static NSString * const kSegueEditRecord = @"com.immpi.segue.editRecord";


#pragma mark -
#pragma mark RecordsListViewController private

@interface RecordsListViewController()<EditTestRecordViewControllerDelegate>
{
    JSONTestRecordsModel    *_model;
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
        JSONTestRecordsModel *model = [JSONTestRecordsModel new];
        [model loadRecordsFromDisk];
        
        _model = model;
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark navigation

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: kSegueAddRecord])
    {
        EditTestRecordViewController *controller =
        (id)[segue.destinationViewController viewControllers][0];
        
        FRB_AssertClass(controller, EditTestRecordViewController);
        
        controller.delegate = self;
        controller.record   = [TestRecord new];
        controller.title    = ___New_Record;
    }
    else if ([segue.identifier isEqualToString: kSegueEditRecord])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell: sender];
        
        FRB_AssertNotNil(indexPath);
        
        id<TestRecord> record = [self testRecordAtIndexPath: indexPath];
        
        
        EditTestRecordViewController *controller = segue.destinationViewController;
        
        FRB_AssertClass(controller, EditTestRecordViewController);
        
        controller.delegate = self;
        controller.title    = ___Edit_Record;
        controller.record   = record;
    }
}


#pragma mark -
#pragma mark private

- (id<TestRecord>) testRecordAtIndexPath: (NSIndexPath *) indexPath
{
    return [_model objectAtIndexPath: indexPath];
}


#pragma mark - 
#pragma mark Table view data source

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
    
    id<TestRecord> record = [self testRecordAtIndexPath: indexPath];
    FRB_AssertNotNil(record);
    
    cell.textLabel.text       = record.person.name;
    cell.detailTextLabel.text = [_dateFormatter stringFromDate: record.date];
    
    return cell;
}


#pragma mark -
#pragma mark EditTestRecordViewControllerDelegate

- (void) editTestRecordViewController: (EditTestRecordViewController *) controller
               didFinishEditingRecord: (id<TestRecord>) record
{
    // In this case, we've adding a new record (form is presented modally)
    if (controller.navigationController.presentingViewController != nil)
    {
        [self dismissViewControllerAnimated: YES
                                 completion: nil];
        
        if (record != nil)
        {
            [_model addNewObject: record];
            [self.tableView reloadData];
        }
    }
    else
    {
        [self.navigationController popToViewController: self
                                              animated: YES];
        
        if (record != nil)
        {
            [_model updateObject: record];
            [self.tableView reloadData];
        }
    }
}

@end
