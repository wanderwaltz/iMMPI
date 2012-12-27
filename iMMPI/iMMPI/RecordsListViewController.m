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


#pragma mark -
#pragma mark Static constants

static NSString * const kRecordCellIdentifier = @"RecordCell";


#pragma mark -
#pragma mark RecordsListViewController private

@interface RecordsListViewController ()
@end


#pragma mark -
#pragma mark RecordsListViewController implementation

@implementation RecordsListViewController

#pragma mark -
#pragma mark navigation

- (IBAction) cancelAddingRecord: (UIStoryboardSegue *) segue
{
    [self dismissViewControllerAnimated: YES completion: nil];
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
    return 10;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kRecordCellIdentifier];
    FRB_AssertNotNil(cell);
    
    return cell;
}


@end
