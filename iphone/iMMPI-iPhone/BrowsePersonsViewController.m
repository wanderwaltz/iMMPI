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
#import "RecordOverviewViewController.h"

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
        _model = [BasicListModel instance];
        _needsReload = YES;
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


#pragma mark -
#pragma mark Reloading

- (void) reload
{
    [(BasicListModel *)_model setElements: 
     [[DataStorage shared] personsListElements]];
    [super reload];
}


#pragma mark -
#pragma mark Navigation

- (void) pushRecordOverviewWithDocument: (MMPIDocument *) document
{
    RecordOverviewViewController *controller =
    [RecordOverviewViewController instanceWithMMPIDocument: document];
    
    [self.navigationController pushViewController: controller 
                                         animated: YES];
}


#pragma mark -
#pragma mark UITableViewDelegate

     - (void) tableView: (UITableView *) tableView 
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    id object = [_model objectAtIndexPath: indexPath];
    MMPIDocument *document = [DataStorage documentForPersonsListElement: object];
    [self pushRecordOverviewWithDocument: document];
    
    [tableView deselectRowAtIndexPath: indexPath 
                             animated: YES];
}

@end
