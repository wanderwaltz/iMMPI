//
//  PersonsListViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "PersonsListViewController.h"

#pragma mark -
#pragma mark Private constants

static NSString * const kPersonCellIdentifier = @"Person Cell";


#pragma mark -
#pragma mark PersonsListViewController implementation

@implementation PersonsListViewController

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 1;
}


- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return 1;
}


- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kPersonCellIdentifier];
    NSAssert(cell, @"Expected a prototype cell with identifier '%@' to be loaded from storyboard",
             kPersonCellIdentifier);
    
    cell.textLabel.text = @"Иванов Иван Иванович";
    
    return cell;
}

@end
