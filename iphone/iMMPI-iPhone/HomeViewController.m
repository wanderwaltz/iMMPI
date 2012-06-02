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
#import "BrowsePersonsViewController.h"
#import "EditPersonViewController.h"
#import "RecordOverviewViewController.h"

#import "DataStorage.h"

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
    BrowsePersonsViewController *controller = 
    [BrowsePersonsViewController instance];
    
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
    Person *person = [DataStorage createPersonRecord];
    
    EditPersonViewController *controller = 
    [EditPersonViewController instanceWithPerson: person];
    
    controller.delegate = self;
    
    [self presentModalViewController: 
     [controller embedInNavigationController]
                            animated: YES];
}


#pragma mark -
#pragma mark View lifecycle

- (void) updateVersionLabel
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    _versionLabel.text = 
    [NSString stringWithFormat: @"iMMPI v%@",
     [bundle.infoDictionary objectForKey: @"CFBundleShortVersionString"]];
}

- (void) loadView
{
    [super loadView];
    [self updateVersionLabel];
}


#pragma mark -
#pragma mark PersonRecordFormViewControllerDelegate

- (void) editPersonViewControllerDidCancel: (EditPersonViewController *) controller
{
    [self dismissModalViewControllerAnimated: YES];
}


- (void) editPersonViewController: (EditPersonViewController *) controller 
                          didSavePerson: (Person *) record
{
    [DataStorage createDocumentForPerson: record];
    
    [self presentRecordOverview];
    [self dismissModalViewControllerAnimated: YES];
}

@end
