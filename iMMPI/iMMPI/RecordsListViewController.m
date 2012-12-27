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
#import "Model.h"


#pragma mark -
#pragma mark Static constants

static NSString * const kRecordCellIdentifier = @"RecordCell";


#pragma mark -
#pragma mark RecordsListViewController private

@interface RecordsListViewController ()
{
    NSMutableArray *_testRecords;
    
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
        _testRecords = [NSMutableArray new];
        
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        _dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    return self;
}


#pragma mark -
#pragma mark navigation

- (IBAction) cancelAddingRecord: (UIStoryboardSegue *) segue
{
    [self dismissViewControllerAnimated: YES completion: nil];
}


- (IBAction) confirmAddingRecord: (UIStoryboardSegue *) segue
{
    [self dismissViewControllerAnimated: YES completion: nil];
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    
}


#pragma mark -
#pragma mark private

- (id<TestRecord>) testRecordAtIndexPath: (NSIndexPath *) indexPath
{
    return _testRecords[indexPath.row];
}


#pragma mark - 
#pragma mark Table view data source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 1;
}


- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return _testRecords.count;
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

@end
