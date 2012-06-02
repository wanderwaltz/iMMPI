//
//  BrowseRecordsViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "BrowsePersonsViewController.h"
#import "DataStorage.h"

#pragma mark -
#pragma mark BrowseRecordsViewController implementation

@implementation BrowsePersonsViewController

#pragma mark -
#pragma mark initialization methods

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        _model = [DataStorage personIndexModel];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void) loadView
{
    [super loadView];
    _tableView.sectionIndexMinimumDisplayRowCount = 6;
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSString *) tableView: (UITableView *) tableView 
 titleForHeaderInSection: (NSInteger) section
{
    return [_model titleForSection: section];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return [_model numberOfSections];
}


- (NSInteger) tableView: (UITableView *) tableView 
  numberOfRowsInSection: (NSInteger)     section
{
    return [_model numberOfRowsInSection: section];
}


- (UITableViewCell *) tableView: (UITableView *) tableView 
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    WWTableViewCell *cell = [WWTableViewCell cellForTableView: tableView];
    PersonIndexRecord *record = [_model recordAtIndexPath: indexPath];
    
    cell.textLabel.text = [record fullName];
    
    return cell;
}


- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [_model sectionIndexTitles];
}


    - (NSInteger) tableView: (UITableView *) tableView 
sectionForSectionIndexTitle: (NSString *) title 
                    atIndex: (NSInteger) index
{
    return [_model sectionForSectionIndexTitle: title];
}

@end
