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

#import "BrowseRecordsViewController.h"

#pragma mark -
#pragma mark BrowseRecordsViewController implementation

@implementation BrowseRecordsViewController

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView: (UITableView *) tableView 
  numberOfRowsInSection: (NSInteger)     section
{
    return 0;
}


- (UITableViewCell *) tableView: (UITableView *) tableView 
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return nil;
}

@end
