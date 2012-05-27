//
//  HomeViewController.m
//  iMMPI-iPhone
//
//  Created by Egor Chiglintsev on 19.05.12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "HomeViewController.h"
#import "BrowseRecordsViewController.h"
#import "PersonRecordFormViewController.h"
#import "RecordOverviewViewController.h"

#pragma mark -
#pragma mark HomeViewController implementation

@implementation HomeViewController

#pragma mark -
#pragma mark Actions

- (void) browseRecordsAction: (id) sender
{
    [self presentRecordsBrowser];
}


- (void) addNewRecordAction:  (id) sender
{
    [self presentNewRecordForm];
}


#pragma mark -
#pragma mark Navigation

- (void) presentRecordsBrowser
{
    BrowseRecordsViewController *controller = 
    [BrowseRecordsViewController instance];
    
    [self.navigationController pushViewController: controller 
                                         animated: YES];
}


- (void) presentRecordOverview
{
    RecordOverviewViewController *controller = 
    [RecordOverviewViewController instance];
    
    [self.navigationController pushViewController: controller 
                                         animated: YES];
}


- (void) presentNewRecordForm
{
    PersonRecordFormViewController *controller = 
    [PersonRecordFormViewController instance];
    
    controller.delegate = self;
    
    [self presentModalViewController: [controller embedInNavigationController]
                            animated: YES];
}


#pragma mark -
#pragma mark PersonRecordFormViewControllerDelegate

- (void) personRecordFormViewControllerDidCancel: (PersonRecordFormViewController *) controller
{
    [self dismissModalViewControllerAnimated: YES];
}


- (void) personRecordFormViewController: (PersonRecordFormViewController *) controller 
                          didSaveRecord: (id) record
{
    [self presentRecordOverview];
    [self dismissModalViewControllerAnimated: YES];
}

@end
