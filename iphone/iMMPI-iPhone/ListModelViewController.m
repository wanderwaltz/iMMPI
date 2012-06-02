//
//  ListModelViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 02.06.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "ListModelViewController.h"

#pragma mark -
#pragma mark ListModelViewController implementation

@implementation ListModelViewController

#pragma mark -
#pragma mark Properties

@synthesize model = _model;

- (void) setModel: (id<ListModel>) model
{
    _model = model;
    [self setNeedsReload];
}


#pragma mark -
#pragma mark Reloading

- (void) setNeedsReload
{
    _needsReload = YES;
}


- (void) reloadIfNeeded
{
    if (_needsReload)
    {
        [self reload];
    }
}


- (void) reload
{
    [_model reload];
    [_tableView reloadData];
    _needsReload = NO;
}


#pragma mark -
#pragma mark View lifecycle

- (void) loadView
{
    [super loadView];
    
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame: self.view.bounds 
                                                  style: UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleBounds;
        
        [self.view addSubview: _tableView];
    }
}


- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self reloadIfNeeded];
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
    WWTableViewCell *cell = [WWTableViewCell cellForTableView: tableView
                                                   setupBlock: nil 
                                                        style: UITableViewCellStyleSubtitle];
    
    id<ListModelElement> object = [_model objectAtIndexPath: indexPath];
    
    cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text       = [object title];
    cell.detailTextLabel.text = [object subtitle];
    
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
