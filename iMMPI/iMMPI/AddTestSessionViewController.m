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
#pragma mark Static constants

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
#pragma mark private: data processing

- (void) loadDataFromPerson: (Person *) person
{
    _firstNameTextField.text      = person.firstName;
    _lastNameTextField.text       = person.lastName;
    _patronymicNameTextField.text = person.patronymicName;
}


#pragma mark -
#pragma mark private: navigation

- (void) prepareForPersonsListViewControllerSegue: (UIStoryboardSegue *) segue
{
    PersonsListViewController *controller = (id)segue.destinationViewController;
    
    NSAssert([controller isKindOfClass: [PersonsListViewController class]],
             @"Expected PersonsListViewController instance");
    
    controller.delegate = self;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue
                  sender: (id) sender
{
    if ([segue.identifier isEqualToString: kPersonsListSegue])
    {
        [self prepareForPersonsListViewControllerSegue: segue];
    }
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


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    UIView *view = [self.view viewWithTag: textField.tag+1];
    
    if ([view isKindOfClass: [UITextField class]])
    {
        [view becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}


#pragma mark -
#pragma mark PersonsListViewControllerDelegate

- (void) personsListViewController: (PersonsListViewController *) controller
                   didSelectPerson: (Person *) person
{
    [self loadDataFromPerson: person];
    [self.navigationController popToViewController: self animated: YES];
}

@end
