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
#pragma mark PersonsListViewController implementation

@implementation PersonsListViewController

#pragma mark -
#pragma mark initialization methods

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self != nil)
    {
        _personsListTableController = [PersonsListTableController new];
    }
    return self;
}


#pragma mark -
#pragma mark view lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setPersonListMode];
}


#pragma mark -
#pragma mark private: changing list mode

- (void) setPersonListMode
{
    /*  Important! If we do not do that dataSource swapping,
        tableView would call some of its dataSource methods
        while the fetch is still in progress, raising an
        index out of range exception.
     */
    self.tableView.dataSource = nil;
    [_personsListTableController fetchDataWithCompletion:
     ^(BOOL success, NSError *error)
     {
         if (success)
         {
             self.tableView.dataSource = _personsListTableController;
         }
     }];
}


#pragma mark -
#pragma mark UITableViewDelegate

     - (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    if (tableView.dataSource == _personsListTableController)
    {
        Person *person = [_personsListTableController objectAtIndexPath: indexPath];
        NSAssert([person isKindOfClass: [Person class]],
                 @"Expected object of class Person");
        
        [_delegate personsListViewController: self
                             didSelectPerson: person];
    }
}

@end
