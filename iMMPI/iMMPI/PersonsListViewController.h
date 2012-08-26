//
//  PersonsListViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "PersonsListTableController.h"

#pragma mark -
#pragma mark External declarations

@class PersonsListViewController;


#pragma mark -
#pragma mark PersonsListViewControllerDelegate protocol

@protocol PersonsListViewControllerDelegate<NSObject>

- (void) personsListViewController: (PersonsListViewController *) controller
                   didSelectPerson: (Person *) person;

@end


#pragma mark -
#pragma mark PersonsListViewController interface

/*  This view controller is used to display a list of Person objects
    allowing to select one. The selection callback is then invoked on
    the delegate.
 */
@interface PersonsListViewController : BaseTableViewController
{
    PersonsListTableController *_personsListTableController;
    
    __weak id<PersonsListViewControllerDelegate> _delegate;
}

@property (weak, nonatomic) id<PersonsListViewControllerDelegate> delegate;

@end
