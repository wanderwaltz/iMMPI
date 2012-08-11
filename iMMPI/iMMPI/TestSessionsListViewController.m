//
//  TestSessionsListViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "TestSessionsListViewController.h"

#pragma mark -
#pragma mark Private constants

static NSString * const kTestSessionCellIdentifier = @"Test Session Cell";

static NSString * const kPersonInfoSegue      = @"Person Info";
static NSString * const kTestSessionInfoSegue = @"Test Session Info";


#pragma mark -
#pragma mark TestSessionsListViewController implementation

@implementation TestSessionsListViewController


#pragma mark -
#pragma mark UITableViewDelegate

                      - (void) tableView: (UITableView *) tableView
accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    [self performSegueWithIdentifier: kPersonInfoSegue sender: self];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 1;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section
{
    return 1;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kTestSessionCellIdentifier];
    NSAssert(cell, @"Expected a prototype cell with identifier '%@' to be loaded from storyboard",
             kTestSessionCellIdentifier);
    
    cell.textLabel.text       = @"Иванов И.И.";
    cell.detailTextLabel.text = @"08.08.2012";
    
    return cell;
}


@end
