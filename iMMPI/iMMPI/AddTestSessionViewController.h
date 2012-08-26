//
//  NewTestSessionViewController.h
//  iMMPI
//
//  Created by Egor Chiglintsev on 11.08.12.
//  Copyright (c) 2012 Egor Chiglintsev. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PersonsListViewController.h"

#pragma mark -
#pragma mark Forward declarations

@class AddTestSessionViewController;


#pragma mark -
#pragma mark Delegate protocol

@protocol AddTestSessionViewControllerDelegate<NSObject>
@optional

- (void) addTestSessionViewControllerDidCancel: (AddTestSessionViewController *) controller;

@end


#pragma mark -
#pragma mark NewTestSessionViewController interface

@interface AddTestSessionViewController : BaseTableViewController
<UITextFieldDelegate, PersonsListViewControllerDelegate>
{
    // Model
    __weak id<AddTestSessionViewControllerDelegate> _delegate;
    
    
    // Views
    IBOutlet UITextField *_firstNameTextField;
    IBOutlet UITextField *_patronymicNameTextField;
    IBOutlet UITextField *_lastNameTextField;
}

@property (weak, nonatomic) id<AddTestSessionViewControllerDelegate> delegate;

- (IBAction) cancelButtonAction: (id) sender;

@end
