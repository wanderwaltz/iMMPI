//
//  NewTestSessionViewController.m
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#if (!__has_feature(objc_arc))
#error "This file should be compiled with ARC support"
#endif

#import "AddTestSessionViewController.h"

#pragma mark -
#pragma mark Private constants

static NSString * const kPersonsListSegue = @"Persons List";


#pragma mark -
#pragma mark NewTestSessionViewController implementation

@implementation AddTestSessionViewController

#pragma mark -
#pragma mark actions

- (IBAction) cancelButtonAction: (id) sender
{
    [self delegate_cancel];
}


#pragma mark -
#pragma mark UITableViewDelegate

                      - (void) tableView: (UITableView *) tableView
accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath
{
    [self performSegueWithIdentifier: kPersonsListSegue sender: self];
}


#pragma mark -
#pragma mark private: delegate callbacks

- (void) delegate_cancel
{
    if ([_delegate respondsToSelector: @selector(addTestSessionViewControllerDidCancel:)])
    {
        [_delegate addTestSessionViewControllerDidCancel: self];
    }
}

@end
